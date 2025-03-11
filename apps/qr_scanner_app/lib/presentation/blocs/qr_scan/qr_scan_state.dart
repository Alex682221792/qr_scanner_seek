import 'package:qr_scanner_app/domain/entities/history_item.dart';

class QRScanState {
  final List<HistoryItem> historyLogs;

  const QRScanState(this.historyLogs);
}