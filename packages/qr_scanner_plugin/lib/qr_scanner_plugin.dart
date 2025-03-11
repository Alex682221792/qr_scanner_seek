
import 'qr_scanner_plugin_platform_interface.dart';
import 'qrcode_scanner_api.dart';

class QrScannerPlugin {

  static final QRCodeScannerApi _api = QRCodeScannerApi();

  static Future<ScanQRCodeResult> scanQRCode() async {
    return await _api.scanQRCode();
  }

  Future<String?> setUp() {
    return QrScannerPluginPlatform.instance.setUp();
  }
}
