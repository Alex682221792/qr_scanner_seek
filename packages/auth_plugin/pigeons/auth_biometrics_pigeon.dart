import 'package:pigeon/pigeon.dart';

class AuthResult {
  final String? errorMessage;
  final bool isSuccess;

  AuthResult({this.errorMessage, required this.isSuccess});
}

@HostApi()
abstract class BiometricAuthApi {
  AuthResult authenticate();
}