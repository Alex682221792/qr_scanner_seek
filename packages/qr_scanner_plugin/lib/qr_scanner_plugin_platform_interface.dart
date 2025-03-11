import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qr_scanner_plugin_method_channel.dart';

abstract class QrScannerPluginPlatform extends PlatformInterface {
  /// Constructs a QrScannerPluginPlatform.
  QrScannerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static QrScannerPluginPlatform _instance = MethodChannelQrScannerPlugin();

  /// The default instance of [QrScannerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelQrScannerPlugin].
  static QrScannerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QrScannerPluginPlatform] when
  /// they register themselves.
  static set instance(QrScannerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> setUp() {
    throw UnimplementedError('setUp() has not been implemented.');
  }
}
