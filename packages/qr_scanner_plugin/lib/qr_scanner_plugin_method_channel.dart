import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qr_scanner_plugin_platform_interface.dart';

/// An implementation of [QrScannerPluginPlatform] that uses method channels.
class MethodChannelQrScannerPlugin extends QrScannerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('qr_scanner_plugin');

  @override
  Future<String?> setUp() async {
    final version = await methodChannel.invokeMethod<String>('setUp');
    return version;
  }
}
