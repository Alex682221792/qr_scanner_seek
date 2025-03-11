import 'package:hive/hive.dart';
import 'package:qr_scanner_app/domain/entities/history_item.dart';

part 'history_item_model.g.dart';


@HiveType(typeId: 1)
class HistoryItemModel extends HiveObject {
  @HiveField(0)
  String data;


  @HiveField(1)
  DateTime date;

  HistoryItemModel({required this.data, required this.date});
  
  HistoryItem toDomain(){
    String shortDate = "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}";
    return HistoryItem(data: data, shortDate: shortDate);
  }
}