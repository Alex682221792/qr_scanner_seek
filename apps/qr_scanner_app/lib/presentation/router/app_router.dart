import 'package:go_router/go_router.dart';
import 'package:qr_scanner_app/presentation/pages/home.dart';
import 'package:qr_scanner_app/presentation/pages/login.dart';
import 'package:qr_scanner_app/presentation/pages/splash_screen.dart';

final GoRouter app_router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => SplashScreen()
  ),
  GoRoute(
      path: "/login",
      builder: (context, state) => Login()
  ),
  GoRoute(
      path: "/home",
      builder: (context, state) => Home()
  )
]);