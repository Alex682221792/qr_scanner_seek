
abstract class QRScanEvent {}

class LaunchQRScannerEvent extends QRScanEvent {}

class SetUpQRScannerEvent extends QRScanEvent {}

class GetAllHistoryEvent extends QRScanEvent {}

class SaveHistoryItemEvent extends QRScanEvent {}