import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner_app/domain/entities/history_item.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_event.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_state.dart';
import 'package:qr_scanner_app/presentation/widgets/history_item_widget.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          context.read<QRScanBloc>().add(LaunchQRScannerEvent());
        },
        label:  Text('Escanear', style: Theme.of(context).textTheme.bodySmall),
        icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 25),
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 90, left: 20.0, right: 20.0),
            child: Row(
              children: [
                Hero(
                  tag: "logo",
                  child: SvgPicture.asset(
                    "assets/seek.svg",
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    width: 50,
                    height: 50,
                  ),
                ),
                Text("QR CODE\nSCANNER", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Container(padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Text("Historial", style: TextStyle(color: Colors.white),)),
          BlocBuilder<QRScanBloc, QRScanState>(
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height*0.7,
                padding: EdgeInsets.all(20.0),
                child: ListView.builder(
                  itemCount: state.historyLogs.length,
                  itemBuilder: (context, index) {
                    return HistoryItemWidget(state.historyLogs[index]);
                  },
                )
              );
            },
          )
        ],
      ),
    );
  }
}
