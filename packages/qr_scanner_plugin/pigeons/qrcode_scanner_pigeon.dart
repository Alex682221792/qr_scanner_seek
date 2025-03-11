import 'package:pigeon/pigeon.dart';

class ScanQRCodeResult {
  final String? errorMessage;
  final String? code;

  ScanQRCodeResult({this.errorMessage, this.code});
}

@HostApi()
abstract class QRCodeScannerApi {
  ScanQRCodeResult scanQRCode();
}