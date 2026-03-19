import 'dart:io';

import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/bloc/warehouse/warehouse_state.dart';
import 'package:zili_coffee/data/middlewares/warehouse_middleware.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/models/warehouse/roasting_slip_detail.dart';
import 'package:zili_coffee/data/models/warehouse/packing_slip_detail.dart';
import 'package:zili_coffee/data/models/warehouse/packing_slip_item.dart';
import 'package:zili_coffee/data/models/warehouse/roasting_slip.dart';
import 'package:zili_coffee/data/models/warehouse/packing_slip.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/warehouse_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/enums/warehouse_enum.dart';

import '../../utils/enums.dart';

class WarehouseCubit extends BaseCubit<WarehouseState> {
  WarehouseCubit() : super(WarehouseInitial());

  final _middleware = di<WarehouseMiddleware>();
  final _repository = di<WarehouseRepository>();

  Future<void> filterGreenBeans({
    int limit = 20,
    int offset = 0,
    String? keyword,
    bool isLoadMore = false,
    BaseEvent? event,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore, event: event));
    final result = await _middleware.filterWarehouseVariants(
      limit: limit,
      offset: offset,
      keyword: keyword,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessListState<List<ProductVariant>>) {
      final data = result.responseData;
      final items = data;
      final total = result.total;
      if (isLoadMore) {
        _repository.appendGreenBeans(items, total);
      } else {
        _repository.setGreenBeans(items, total);
      }
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> getRoastingSlips({
    RoastingSlipStatus? status,
    int limit = 20,
    int offset = 0,
    String? keyword,
    bool isLoadMore = false,
    BaseEvent? event,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore, event: event));
    final result = await _middleware.filterRoastingSlips(
      limit: limit,
      offset: offset,
      keyword: keyword,
      statusList: status != null ? [status] : null,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessListState<List<RoastingSlip>>) {
      final data = result.responseData;
      _repository.roastingSlipSubject.add(data);
      _repository.totalRSRecord = result.total;

      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> loadMoreRoastingSlips({
    RoastingSlipStatus? status,
    String? keyword,
    int limit = 20,
    int offset = 0,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(event: BaseEvent.loadMore));
    final result = await _middleware.filterRoastingSlips(
      limit: limit,
      offset: offset,
      keyword: keyword,
      statusList: status != null ? [status] : null,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );
    if (result is ResponseSuccessListState<List<RoastingSlip>>) {
      final currentRoastingSlips =
          _repository.roastingSlipSubject.valueOrNull ?? [];
      _repository.roastingSlipSubject.add([
        ...currentRoastingSlips,
        ...result.responseData,
      ]);
      _repository.totalRSRecord = result.total;
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result.errorMessage));
    } else {
      emit(
        const WarehouseError('Có lỗi xảy ra khi tải danh sách phiếu báo giá'),
      );
    }
  }

  Future<void> filterRoastingSlips({
    required RoastingSlipStatus status,
    int limit = 20,
    int offset = 0,
    String? keyword,
    bool isLoadMore = false,
    BaseEvent? event,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore, event: event));
    final result = await _middleware.filterRoastingSlips(
      limit: limit,
      offset: offset,
      keyword: keyword,
      statusList: [status],
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessListState<List<RoastingSlip>>) {
      final data = result.responseData;

      if (isLoadMore) {
        _repository.appendRoastingSlips(status, data, result.total);
      } else {
        _repository.setRoastingSlips(status, data, result.total);
      }
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  /// Lấy danh sách tất cả phiếu rang (roasting slips) của một hạt rang cụ thể.
  ///
  /// Hàm này truy vấn và trả về toàn bộ phiếu rang liên quan đến một roasted bean
  /// được xác định bởi [roastedBeanId].
  ///
  /// **Parameters:**
  /// - [roastedBeanId]: ID của roasted bean cần lấy danh sách phiếu rang.
  ///
  /// **Behavior:**
  /// - Nếu [roastedBeanId] null hoặc rỗng: emit [WarehouseError] với mã lỗi [HttpStatus.badRequest].
  /// - Khi bắt đầu lấy dữ liệu: emit [WarehouseLoading].
  /// - Nếu thành công ([ResponseSuccessListState<List<RoastingSlip>>]): cập nhật danh sách qua repository, emit [WarehouseLoaded] với items và total tương ứng.
  /// - Nếu lỗi: emit [WarehouseError] với mã lỗi [HttpStatus.notFound].
  /// - Nếu trường hợp khác: emit [WarehouseError] với mã lỗi [HttpStatus.connectionClosedWithoutResponse].
  Future<void> getRoastingSlipsOfRoastedBean(String? roastedBeanId) async {
    if (roastedBeanId == null || roastedBeanId.isEmpty) {
      emit(const WarehouseError<int>(HttpStatus.badRequest));
      return;
    }

    emit(const WarehouseLoading());
    final result = await _middleware.getRoastingSlipsById(roastedBeanId);
    if (result is ResponseSuccessListState<List<RoastingSlip>>) {
      final data = result.responseData;
      _repository.setRoastingSlipsOfRoastedBean(data, result.total);
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(const WarehouseError<int>(HttpStatus.notFound));
    } else {
      emit(
        const WarehouseError<int>(HttpStatus.connectionClosedWithoutResponse),
      );
    }
  }

  Future<void> filterRoastedBeans({
    int limit = 20,
    int offset = 0,
    String? keyword,
    bool isLoadMore = false,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore));
    final result = await _middleware.filterRoastedBeans(
      limit: limit,
      offset: offset,
      keyword: keyword,
    );

    if (result is ResponseSuccessListState<List<ProductVariant>>) {
      final data = result.responseData;
      if (isLoadMore) {
        _repository.appendRoastedBeans(data, result.total);
      } else {
        _repository.setRoastedBeans(data, result.total);
      }
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> filterVariantSpecial({
    int limit = 20,
    int offset = 0,
    String? keyword,
    bool isLoadMore = false,
    BaseEvent? event,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore, event: event));
    final result = await _middleware.filterVariantSpecial(
      limit: limit,
      offset: offset,
      keyword: keyword,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessListState<List<ProductVariant>>) {
      final data = result.responseData;
      if (isLoadMore) {
        _repository.appendVariantSpecials(data, result.total);
      } else {
        _repository.setVariantSpecials(data, result.total);
      }
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> getRoastingSlipDetail(String code, {BaseEvent? event}) async {
    emit(WarehouseLoading(event: event));
    final result = await _middleware.getRoastingSlipDetail(code);
    if (result is ResponseSuccessState<RoastingSlipDetail>) {
      emit(
        WarehouseLoaded(
          items: [result.responseData],
          total: 1,
          type: 'roasting_slip_detail',
        ),
      );
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> getPackingSlipDetail(String code, {BaseEvent? event}) async {
    emit(WarehouseLoading(event: event));
    final result = await _middleware.getPackingSlipDetail(code);
    if (result is ResponseSuccessState<PackingSlipDetail>) {
      emit(
        WarehouseLoaded(
          items: [result.responseData],
          total: 1,
          type: 'packing_slip_detail',
        ),
      );
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  /// Get packing slip item detail by code
  ///
  /// Returns PackingSlipDetailItem directly without emitting state.
  /// Returns null if error occurs.
  ///
  /// Example:
  /// ```dart
  /// final item = await cubit.getPackingSlipItemDetail('ITEM_CODE');
  /// if (item != null) {
  ///   // Use item data
  /// }
  /// ```
  Future<PackingSlipDetailItem?> getPackingSlipItemDetail(String code) async {
    final result = await _middleware.getPackingSlipItemDetail(code);
    if (result is ResponseSuccessState<PackingSlipDetailItem>) {
      return result.responseData;
    }
    return null;
  }

  Future<void> exportRoastingSlipGreenBean({
    required String roastingSlipId,
    required double weight,
    String? note,
  }) async {
    emit(const WarehouseLoading(event: BaseEvent.post));
    final result = await _middleware.exportRoastingSlipGreenBean(
      weight: weight,
      roastingSlipId: roastingSlipId,
      note: note,
    );
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        final warehouseCubit = di<WarehouseCubit>();
        await warehouseCubit.filterRoastingSlips(
          status: RoastingSlipStatus.newRequest,
        );
        await warehouseCubit.filterRoastingSlips(
          status: RoastingSlipStatus.roasting,
        );
        await warehouseCubit.getTotalOfNewRequestSlip();
        getRoastingSlipDetail(roastingSlipId);
        emit(ExportWarehouseSucceed());
      } else {
        emit(ExportWarehouseFailed());
      }
    } else {
      emit(ExportWarehouseFailed());
    }
  }

  Future<void> cancelRoastingSlip({
    required String roastingSlipId,
    required String note,
  }) async {
    emit(const WarehouseLoading(event: BaseEvent.post));
    final result = await _middleware.cancelRoastingSlip(
      roastingSlipId: roastingSlipId,
      note: note,
    );
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        final warehouseCubit = di<WarehouseCubit>();
        await warehouseCubit.filterRoastingSlips(
          status: RoastingSlipStatus.newRequest,
        );
        await warehouseCubit.filterRoastingSlips(
          status: RoastingSlipStatus.roasting,
        );
        await warehouseCubit.getTotalOfNewRequestSlip();
        await getRoastingSlipDetail(roastingSlipId);
        emit(CancelWarehouseSucceed());
      } else {
        emit(CancelWarehouseFailed());
      }
    } else {
      emit(CancelWarehouseFailed());
    }
  }

  Future<void> completeRoastingSlip({
    required String roastingSlipId,
    required double weight,
    String? note,
  }) async {
    emit(const WarehouseLoading(event: BaseEvent.post));
    final result = await _middleware.completeRoastingSlip(
      weight: weight,
      roastingSlipId: roastingSlipId,
      note: note,
    );
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        final warehouseCubit = di<WarehouseCubit>();
        await warehouseCubit.filterRoastingSlips(
          status: RoastingSlipStatus.roasting,
        );
        await warehouseCubit.filterRoastingSlips(
          status: RoastingSlipStatus.completed,
        );
        await getRoastingSlipDetail(roastingSlipId);
        emit(CompleteWarehouseSucceed());
      } else {
        emit(CompleteWarehouseFailed());
      }
    } else {
      emit(CompleteWarehouseFailed());
    }
  }

  Future<void> getPackingSlips({
    PackingSlipStatus? status,
    int limit = 20,
    int offset = 0,
    String? keyword,
    bool isLoadMore = false,
    BaseEvent? event,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore, event: event));
    final result = await _middleware.filterPacking(
      limit: limit,
      offset: offset,
      keyword: keyword,
      statuses: status != null ? [status.toConstant] : null,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessListState<List<PackingSlip>>) {
      final data = result.responseData;
      _repository.packingSlipSubject.add(data);
      _repository.totalPSRecord = result.total;

      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> loadMorePackingSlips({
    PackingSlipStatus? status,
    String? keyword,
    int limit = 20,
    int offset = 0,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(event: BaseEvent.loadMore));
    final result = await _middleware.filterPacking(
      limit: limit,
      offset: offset,
      keyword: keyword,
      statuses: status != null ? [status.toConstant] : null,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );
    if (result is ResponseSuccessListState<List<PackingSlip>>) {
      final currentPackingSlips =
          _repository.packingSlipSubject.valueOrNull ?? [];
      _repository.packingSlipSubject.add([
        ...currentPackingSlips,
        ...result.responseData,
      ]);
      _repository.totalPSRecord = result.total;
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result.errorMessage));
    } else {
      emit(
        const WarehouseError('Có lỗi xảy ra khi tải danh sách phiếu báo giá'),
      );
    }
  }

  Future<void> filterPackings({
    int limit = 20,
    int offset = 0,
    String? keyword,
    bool isLoadMore = false,
    PackingSlipStatus status = PackingSlipStatus.newRequest,
    BaseEvent? event,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore, event: event));
    final result = await _middleware.filterPacking(
      limit: limit,
      offset: offset,
      keyword: keyword,
      statuses: [status.toConstant],
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessListState<List<PackingSlip>>) {
      final data = result.responseData;
      if (isLoadMore) {
        _repository.appendPackings(data, result.total, status);
      } else {
        _repository.setPackings(data, result.total, status);
      }
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> getPackingSlipsByCode({
    required String itemCode,
    int limit = 20,
    int offset = 0,
    bool isLoadMore = false,
  }) async {
    emit(WarehouseLoading(isLoadMore: isLoadMore));
    final result = await _middleware.filterPackingItemsByItemCode(
      itemCode: itemCode,
      limit: limit,
      offset: offset,
    );

    if (result is ResponseSuccessListState<List<PackingSlipDetailItem>>) {
      final data = result.responseData;
      _repository.packingSlipsOfSpecialVariant.sink.add(data);
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      emit(WarehouseError(result));
    } else {
      emit(WarehouseError(ResponseFailedState.unknownError()));
    }
  }

  Future<void> getTotalOfNewRequestSlip() async {
    final resultRoasting = await _middleware.getTotalOfNewRequestRoastingSlip();
    final resultPacking = await _middleware.getTotalOfNewRequestPackingSlip();
    if (resultRoasting is ResponseSuccessState<int>) {
      _repository.newRoastingSlipsCounter.sink.add(resultRoasting.responseData);
    }
    if (resultPacking is ResponseSuccessState<int>) {
      _repository.newPackingSlipsCounter.sink.add(resultPacking.responseData);
    }
  }

  Future<bool> cancelMixPacking(String itemId, String cancelReason) async {
    emit(WarehouseLoading());
    final result = await _middleware.cancelMixPacking(itemId, cancelReason);
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        emit(WarehouseLoaded());
        return true;
      } else {
        emit(WarehouseFailed());
        return false;
      }
    }
    emit(WarehouseFailed());
    return false;
  }

  Future<void> getTotalRoastingSlips() async {
    _repository.technicalRoleStatistic.sink.add([]);
    emit(const WarehouseLoading());
    final result = await _middleware.getTotalRoastingSlips();
    if (result is ResponseSuccessState<List<int>>) {
      _repository.technicalRoleStatistic.sink.add(result.responseData);
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      _repository.technicalRoleStatistic.sink.add([0, 0, 0]);
      emit(const WarehouseError<int>(HttpStatus.notFound));
    } else {
      _repository.technicalRoleStatistic.sink.add([0, 0, 0]);
      emit(
        const WarehouseError<int>(HttpStatus.connectionClosedWithoutResponse),
      );
    }
  }

  Future<void> getNewestRoastingSlips() async {
    final result = await _middleware.filterRoastingSlips(
      limit: 3,
      offset: 0,
      statusList: [RoastingSlipStatus.newRequest],
    );
    if (result is ResponseSuccessState<List<RoastingSlip>>) {
      _repository.newestRoastingSlip.sink.add(result.responseData);
    }
  }

  Future<void> getProcessingRoastingSlips() async {
    final result = await _middleware.filterRoastingSlips(
      limit: 3,
      offset: 0,
      statusList: [RoastingSlipStatus.roasting],
    );
    if (result is ResponseSuccessState<List<RoastingSlip>>) {
      _repository.processingRoastingSlip.sink.add(result.responseData);
    }
  }

  Future<void> getTotalPackingSlips() async {
    _repository.technicalRoleStatistic.sink.add([]);
    emit(const WarehouseLoading());
    final result = await _middleware.getTotalPackingSlips();
    if (result is ResponseSuccessState<List<int>>) {
      _repository.technicalRoleStatistic.sink.add(result.responseData);
      emit(const WarehouseLoaded());
    } else if (result is ResponseFailedState) {
      _repository.technicalRoleStatistic.sink.add([0, 0, 0]);
      emit(const WarehouseError<int>(HttpStatus.notFound));
    } else {
      _repository.technicalRoleStatistic.sink.add([0, 0, 0]);
      emit(
        const WarehouseError<int>(HttpStatus.connectionClosedWithoutResponse),
      );
    }
  }

  Future<void> getAwaitPackingSlipItems() async {
    final result = await _middleware.filterPackingItems(
      limit: 3,
      offset: 0,
      status: PackingSlipStatus.newRequest,
    );
    if (result is ResponseSuccessListState<List<PackingSlipDetailItem>>) {
      _repository.awaitPackingSlip.sink.add(result.responseData);
    }
  }

  Future<void> getExportedPackingSlipItems() async {
    final result = await _middleware.filterPackingItems(
      limit: 3,
      offset: 0,
      status: PackingSlipStatus.packing,
    );
    if (result is ResponseSuccessListState<List<PackingSlipDetailItem>>) {
      _repository.exportedPackingSlip.sink.add(result.responseData);
    }
  }

  Future<void> getWaitForCompletePackingSlipItems() async {
    final result = await _middleware.filterPackingItems(
      limit: 3,
      offset: 0,
      status: PackingSlipStatus.confirmed,
    );
    if (result is ResponseSuccessListState<List<PackingSlipDetailItem>>) {
      _repository.waitCompletePackingSlip.sink.add(result.responseData);
    }
  }
}
