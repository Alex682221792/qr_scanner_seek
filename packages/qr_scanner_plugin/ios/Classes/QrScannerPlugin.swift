import UIKit
import AVFoundation
import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif


public class QrScannerPlugin: NSObject, FlutterPlugin, AVCaptureMetadataOutputObjectsDelegate {
  static var regLocal : FlutterPluginRegistrar? = nil
  public static func register(with registrar: FlutterPluginRegistrar) {
      regLocal = registrar
    let channel = FlutterMethodChannel(name: "qr_scanner_plugin", binaryMessenger: registrar.messenger())
    let instance = QrScannerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setUp":
        QRCodeScannerApiSetup.setUp(binaryMessenger: QrScannerPlugin.regLocal!.messenger(), api: QRCodeScannerApiImpl())
      result("SetUp performed")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}


private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct ScanQRCodeResult {
  var errorMessage: String? = nil
  var code: String? = nil

  static func fromList(_ list: [Any?]) -> ScanQRCodeResult? {
    let errorMessage: String? = nilOrValue(list[0])
    let code: String? = nilOrValue(list[1])

    return ScanQRCodeResult(
      errorMessage: errorMessage,
      code: code
    )
  }
  func toList() -> [Any?] {
    return [
      errorMessage,
      code,
    ]
  }
}
private class QRCodeScannerApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return ScanQRCodeResult.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class QRCodeScannerApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? ScanQRCodeResult {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class QRCodeScannerApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return QRCodeScannerApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return QRCodeScannerApiCodecWriter(data: data)
  }
}

class QRCodeScannerApiCodec: FlutterStandardMessageCodec {
  static let shared = QRCodeScannerApiCodec(readerWriter: QRCodeScannerApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol QRCodeScannerApi {
  func scanQRCode() async throws -> ScanQRCodeResult
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class QRCodeScannerApiSetup {
  /// The codec used by QRCodeScannerApi.
  static var codec: FlutterStandardMessageCodec { QRCodeScannerApiCodec.shared }
  /// Sets up an instance of `QRCodeScannerApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: QRCodeScannerApi?) {
    let scanQRCodeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.qr_scanner_plugin.QRCodeScannerApi.scanQRCode", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      scanQRCodeChannel.setMessageHandler { _, reply in
        Task {
          do {
            let result = try await api.scanQRCode()
            reply(wrapResult(result))
          } catch {
            reply(wrapError(error))
          }
        }
      }
    } else {
      scanQRCodeChannel.setMessageHandler(nil)
    }
  }
}


open class QRCodeScannerApiImpl: NSObject, QRCodeScannerApi, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession?
    private var completion: ((ScanQRCodeResult) -> Void)?
    private var continuation: CheckedContinuation<ScanQRCodeResult, Never>?

    func scanQRCode() async -> ScanQRCodeResult {
        var scanResult = ScanQRCodeResult()

        guard let viewController = await UIApplication.shared.keyWindow?.rootViewController else {
            scanResult.errorMessage = "No se pudo acceder al ViewController"
            return scanResult
        }

        let captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scanResult.errorMessage = "Cámara no disponible"
            return scanResult
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                scanResult.errorMessage = "No se pudo agregar entrada de cámara"
                return scanResult
            }
        } catch {
            scanResult.errorMessage = "Error al acceder a la cámara"
            return scanResult
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            scanResult.errorMessage = "No se pudo agregar salida de metadatos"
            return scanResult
        }

        self.captureSession = captureSession
        self.completion = { result in
            DispatchQueue.main.async {
                captureSession.stopRunning()
                viewController.dismiss(animated: true, completion: nil)
                self.continuation!.resume(returning: result)
            }
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = await viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill

        let scannerVC = await UIViewController()
        await scannerVC.view.layer.addSublayer(previewLayer)

        await viewController.present(scannerVC, animated: true) {
            captureSession.startRunning()
        }

        // Esperamos a que se complete el escaneo
        scanResult = await withCheckedContinuation { continuation in
            self.continuation = continuation
        }
        
        return scanResult
    }

    // El delegado captura el resultado cuando se encuentra un código QR
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let qrCodeValue = metadataObject.stringValue {

            var result = ScanQRCodeResult()
            result.code = qrCodeValue

            self.completion?(result)
        }
    }
}
