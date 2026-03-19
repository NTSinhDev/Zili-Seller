import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';

import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/data/middlewares/setting_middleware.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

import '../../data/entity/printer.dart';
import '../../data/repositories/setting_repository.dart';
import '../../utils/enums/setting_enum.dart';

part 'setting_state.dart';

class SettingCubit extends BaseCubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  final SettingRepository _settingRepository = di<SettingRepository>();
  final SettingMiddleware _settingMiddleware = di<SettingMiddleware>();

  /// Get sale channels (kênh bán hàng)
  ///
  /// Lấy danh sách kênh bán hàng từ API và add vào stream
  ///
  /// States:
  /// - LoadingSettingState: Loading
  /// - LoadedSettingState: Success
  /// - ErrorSettingState: Error
  Future<void> getSaleChannels() async {
    emit(LoadingSettingState());
    final result = await _settingMiddleware.getTerms(TermType.saleChannels);

    if (result is ResponseSuccessState<List<String>>) {
      _settingRepository.saleChannels.sink.add(result.responseData);
      emit(LoadedSettingState());
    } else if (result is ResponseFailedState) {
      emit(ErrorSettingState(error: result));
    }
  }

  /// Lấy danh sách máy in sẵn có trong hệ thống
  ///
  Future<void> getPrinters() async {
    if ((_settingRepository.printers.valueOrNull ?? []).isNotEmpty) {
      return;
    }
    emit(LoadingSettingState());
    final result = await _settingMiddleware.getTerms(TermType.printerApi);

    if (result is ResponseSuccessState<List<Printer>>) {
      _settingRepository.printers.sink.add(result.responseData);
      emit(LoadedSettingState());
    } else if (result is ResponseFailedState) {
      emit(ErrorSettingState(error: result));
    }
  }
}
