import 'package:flutter_test/flutter_test.dart';
import 'package:auth_plugin/auth_plugin.dart';
import 'package:auth_plugin/auth_plugin_platform_interface.dart';
import 'package:auth_plugin/auth_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAuthPluginPlatform
    with MockPlatformInterfaceMixin
    implements AuthPluginPlatform {

  @override
  Future<String?> setUp() => Future.value('SetUp performed');
}

void main() {
  final AuthPluginPlatform initialPlatform = AuthPluginPlatform.instance;

  test('$MethodChannelAuthPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAuthPlugin>());
  });

  test('setUp', () async {
    AuthPlugin authPlugin = AuthPlugin();
    MockAuthPluginPlatform fakePlatform = MockAuthPluginPlatform();
    AuthPluginPlatform.instance = fakePlatform;

    expect(await authPlugin.setUp(), 'SetUp performed');
  });
}
