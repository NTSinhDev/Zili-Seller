import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

import '../entity/printer.dart';
import '../entity/system/reason.dart';

class SettingRepository extends BaseRepository {
  /// Stream cho sale channels (kênh bán hàng)
  ///
  /// Chứa danh sách các kênh bán hàng từ API setting/terms?type=SALE_CHANNELS
  /// Ví dụ: ["TIKTOK", "FB", "WEBSITE", "..."]
  final BehaviorSubject<List<String>> saleChannels =
      BehaviorSubject<List<String>>();

  /// Get current value của sale channels
  List<String> get saleChannelsValue => saleChannels.valueOrNull ?? [];

  /// Stream cho danh sách lý do
  ///
  final BehaviorSubject<List<ReasonEntity>> reasons =
      BehaviorSubject<List<ReasonEntity>>();

  /// Get current value của danh sách lý do
  List<ReasonEntity> get reasonsValue => reasons.valueOrNull ?? [];

  final BehaviorSubject<List<Printer>> printers =
      BehaviorSubject<List<Printer>>();

  @override
  Future<void> clean() async {
    saleChannels.sink.add([]);
  }
}
