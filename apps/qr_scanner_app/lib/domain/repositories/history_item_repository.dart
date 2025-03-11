import 'package:qr_scanner_app/domain/entities/history_item.dart';

abstract class HistoryItemRepository{
  Future<void> saveHistoryItem(String data);
  Future<List<HistoryItem>> getHistoryItems();
}