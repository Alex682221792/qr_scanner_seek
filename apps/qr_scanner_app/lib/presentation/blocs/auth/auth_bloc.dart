import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_app/presentation/blocs/auth/auth_event.dart';
import 'package:qr_scanner_app/presentation/blocs/auth/auth_state.dart';
import 'package:auth_plugin/auth_plugin.dart';
import 'package:go_router/go_router.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoRouter goRouter;


  AuthBloc({required this.goRouter}): super(AuthState(false)) {
    on<InitAuthEvent>((event, emmit) async {
      emmit(AuthState(true));
      bool authenticated = await AuthPlugin.authenticate();
      emmit(AuthState(false));
      if(authenticated){
        goRouter.go("/home");
      }
    });


    on<SetUpAuthEvent>((event, emmit) {
      AuthPlugin().setUp();
    });
  }
}