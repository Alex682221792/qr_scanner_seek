import UIKit
import LocalAuthentication
import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

public class AuthPlugin: NSObject, FlutterPlugin {
  static var regLocal : FlutterPluginRegistrar? = nil
  public static func register(with registrar: FlutterPluginRegistrar) {
      regLocal = registrar
    let channel = FlutterMethodChannel(name: "auth_plugin", binaryMessenger: registrar.messenger())
    let instance = AuthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setUp":
        BiometricAuthApiSetup.setUp(binaryMessenger: AuthPlugin.regLocal!.messenger(), api: BiometricAuthImpl())
      result("iOS " + UIDevice.current.systemVersion)
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
struct AuthResult {
  var errorMessage: String? = nil
  var isSuccess: Bool

  static func fromList(_ list: [Any?]) -> AuthResult? {
    let errorMessage: String? = nilOrValue(list[0])
    let isSuccess = list[1] as! Bool

    return AuthResult(
      errorMessage: errorMessage,
      isSuccess: isSuccess
    )
  }
  func toList() -> [Any?] {
    return [
      errorMessage,
      isSuccess,
    ]
  }
}
private class BiometricAuthApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return AuthResult.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class BiometricAuthApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? AuthResult {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class BiometricAuthApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return BiometricAuthApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return BiometricAuthApiCodecWriter(data: data)
  }
}

class BiometricAuthApiCodec: FlutterStandardMessageCodec {
  static let shared = BiometricAuthApiCodec(readerWriter: BiometricAuthApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol BiometricAuthApi {
    func authenticate() async throws -> AuthResult
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class BiometricAuthApiSetup {
  /// The codec used by BiometricAuthApi.
  static var codec: FlutterStandardMessageCodec { BiometricAuthApiCodec.shared }
  /// Sets up an instance of `BiometricAuthApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: BiometricAuthApi?) {
    let authenticateChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.auth.BiometricAuthApi.authenticate", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      authenticateChannel.setMessageHandler { _, reply in
        Task {
          do {
            let result = try await api.authenticate()
            reply(wrapResult(result))
          } catch {
            reply(wrapError(error))
          }
        }
      }
    } else {
      authenticateChannel.setMessageHandler(nil)
    }
  }
}

open class BiometricAuthImpl: NSObject, BiometricAuthApi {
    func authenticate() async throws -> AuthResult {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return AuthResult(errorMessage: "Biometric authentication not available", isSuccess: false)
        }

        let reason = "Authenticate with biometrics"
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            return AuthResult(errorMessage: nil, isSuccess: success)
        } catch {
            return AuthResult(errorMessage: error.localizedDescription, isSuccess: false)
        }
    }
}
