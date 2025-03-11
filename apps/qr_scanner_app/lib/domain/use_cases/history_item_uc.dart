import 'package:qr_scanner_app/di/di_initializer.dart';
import 'package:qr_scanner_app/domain/entities/history_item.dart';
import 'package:qr_scanner_app/domain/repositories/history_item_repository.dart';

class SaveHistoryItem {
  final HistoryItemRepository repository = getIt<HistoryItemRepository>();

  SaveHistoryItem();

  Future<void> execute(String data){
    return repository.saveHistoryItem(data);
  }
}


class GetAllHistoryItem {
  final HistoryItemRepository repository = getIt<HistoryItemRepository>();

  GetAllHistoryItem();

  Future<List<HistoryItem>> execute(){
    return repository.getHistoryItems();
  }
}

