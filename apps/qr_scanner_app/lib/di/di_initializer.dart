import 'package:get_it/get_it.dart';
import 'package:qr_scanner_app/data/repositories/history_item_repository_impl.dart';
import 'package:qr_scanner_app/domain/repositories/history_item_repository.dart';
import 'package:qr_scanner_app/domain/use_cases/history_item_uc.dart';

final getIt = GetIt.instance;

void initializeDI() {
  getIt.registerLazySingleton<HistoryItemRepository>(()=>HistoryItemRepositoryImpl());
  getIt.registerFactory<SaveHistoryItem>(() => SaveHistoryItem());
  getIt.registerFactory<GetAllHistoryItem>(() => GetAllHistoryItem());
}