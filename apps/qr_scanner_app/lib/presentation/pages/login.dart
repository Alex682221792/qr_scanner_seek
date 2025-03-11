import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:qr_scanner_app/presentation/blocs/auth/auth_event.dart';
import 'package:qr_scanner_app/presentation/blocs/auth/auth_state.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_event.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(SetUpAuthEvent());
    BlocProvider.of<QRScanBloc>(context).add(SetUpQRScannerEvent());
  }

  //class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 90),
            child: Hero(
              tag: "logo",
              child: SvgPicture.asset(
                "assets/seek.svg",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 100,
                height: 100,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                "QR CODE\nSCANNER",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Spacer(),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Container(
                  padding: EdgeInsets.only(bottom: 90.0),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(InitAuthEvent());
                        },
                        icon: Icon(
                          Icons.fingerprint,
                          color: Colors.grey,
                          size: 64.0,
                        ),
                      ),

                      Text(
                        "Ingresar",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),

                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
