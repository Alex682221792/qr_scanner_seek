import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_app/di/di_initializer.dart';
import 'package:qr_scanner_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:qr_scanner_app/presentation/router/app_router.dart';


void main() {
  initializeDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
//    HistoryItemRepositoryImpl _historyItemRepositoryImpl = HistoryItemRepositoryImpl();
   return MultiBlocProvider(providers:[
       BlocProvider(create: (context) => AuthBloc(goRouter: app_router)),
       BlocProvider(create: (context) => QRScanBloc()),
   ],
     child: MaterialApp.router(
       title: 'Flutter Demo',
       theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
         textTheme: TextTheme(
           displayLarge: const TextStyle(
             fontSize: 72,
             fontWeight: FontWeight.bold,
           ),
           // ···
           titleLarge: const TextStyle(
             fontSize: 30,
             fontStyle: FontStyle.italic,
           ),
           bodyMedium: const TextStyle(
             fontSize: 25,
             color: Colors.white
           ),
           bodySmall: const TextStyle(
               fontSize: 15,
               color: Colors.white
           ),
         ),
       ),

       routerConfig: app_router,
     )
   );
  }
}



