import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'auth_plugin_method_channel.dart';

abstract class AuthPluginPlatform extends PlatformInterface {
  /// Constructs a AuthPluginPlatform.
  AuthPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AuthPluginPlatform _instance = MethodChannelAuthPlugin();

  /// The default instance of [AuthPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelAuthPlugin].
  static AuthPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AuthPluginPlatform] when
  /// they register themselves.
  static set instance(AuthPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> setUp() {
    throw UnimplementedError('setUp() has not been implemented.');
  }
}
