import 'package:hive/hive.dart';
import 'package:qr_scanner_app/data/models/history_item_model.dart';
import 'package:qr_scanner_app/domain/entities/history_item.dart';
import 'package:qr_scanner_app/domain/repositories/history_item_repository.dart';
import 'package:path_provider/path_provider.dart';

class HistoryItemRepositoryImpl extends HistoryItemRepository {
  late Box<HistoryItemModel> historyItemBox;
  final String boxName = "historyItemBox";
  final String historyLogsKey = "history_logs";

  HistoryItemRepositoryImpl() {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(HistoryItemModelAdapter());
    historyItemBox = await Hive.openBox<HistoryItemModel>(boxName);
    print("*** LOG: _initializeHive");
  }

  @override
  Future<void> saveHistoryItem(String data) async {

    await historyItemBox.add(HistoryItemModel(data: data, date: DateTime.now()));
  }

  @override
  Future<List<HistoryItem>> getHistoryItems() async{
    List<HistoryItemModel> historyItemList = historyItemBox.values.toList();
    return historyItemList.map((e) => e.toDomain()).toList();
  }
}