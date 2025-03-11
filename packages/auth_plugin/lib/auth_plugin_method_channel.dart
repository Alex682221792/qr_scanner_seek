import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'auth_plugin_platform_interface.dart';

/// An implementation of [AuthPluginPlatform] that uses method channels.
class MethodChannelAuthPlugin extends AuthPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('auth_plugin');

  @override
  Future<String?> setUp() async {
    final version = await methodChannel.invokeMethod<String>('setUp');
    return version;
  }
}
