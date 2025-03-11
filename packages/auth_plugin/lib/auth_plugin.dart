
import 'auth_plugin_platform_interface.dart';
import 'auth_biometrics_api.dart';

class AuthPlugin {
  static final BiometricAuthApi _api = BiometricAuthApi();

  static Future<bool> authenticate() async {
    final result = await _api.authenticate();
    return result.isSuccess;
  }
  
  Future<String?> setUp() {
    return AuthPluginPlatform.instance.setUp();
  }
}
