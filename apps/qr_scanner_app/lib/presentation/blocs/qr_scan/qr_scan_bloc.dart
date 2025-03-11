import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_app/di/di_initializer.dart';
import 'package:qr_scanner_app/domain/entities/history_item.dart';
import 'package:qr_scanner_app/domain/use_cases/history_item_uc.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_event.dart';
import 'package:qr_scanner_app/presentation/blocs/qr_scan/qr_scan_state.dart';
import 'package:qr_scanner_plugin/qr_scanner_plugin.dart';
import 'package:qr_scanner_plugin/qrcode_scanner_api.dart';

class QRScanBloc extends Bloc<QRScanEvent, QRScanState> {

  final SaveHistoryItem saveHistoryItem = getIt<SaveHistoryItem>();
  final GetAllHistoryItem getAllHistory = getIt<GetAllHistoryItem>();


  QRScanBloc(): super(QRScanState(List.empty())) {
    on<LaunchQRScannerEvent>((event, emmit) async {
      ScanQRCodeResult result = await QrScannerPlugin.scanQRCode();
      print("*** LOG: errorMessage-scan: ${result.errorMessage}");
      if(result.code != null){
        await saveHistoryItem.execute(result.code!);
        await _performGetAllHistory(emmit);
      }
    });


    on<SetUpQRScannerEvent>((event, emmit) {
      QrScannerPlugin().setUp();
    });

    on<GetAllHistoryEvent>((event, emmit) async{
      _performGetAllHistory(emmit);
    });
    Future.delayed(Duration(seconds: 1), () {
      _performGetAllHistory(null);
    });

  }

  _performGetAllHistory(Emitter<QRScanState>? emmit) async{
    List<HistoryItem> result = await getAllHistory.execute();
    if(emmit != null) {
      emmit(QRScanState(result));
    } else {
      emit(QRScanState(result));
    }
  }
}

