import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/bloc/roasting_slip/roasting_slip_state.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

import '../../data/middlewares/middlewares.dart';

class RoastingSlipCubit extends BaseCubit<RoastingSlipState> {
  RoastingSlipCubit() : super(const RoastingSlipInitial());

  final _productMiddleware = di<ProductMiddleware>();
  final _warehouseMiddleware = di<WarehouseMiddleware>();
  final _productRepository = di<ProductRepository>();

  Future<void> fetchGreenBeanDefault(String id, {String? branchId}) async {
    emit(const RoastingSlipLoading(action: .fetchGreenBeanDefault));
    final result = await _productMiddleware.getGreenBeanDefault(id: id);

    if (result is ResponseSuccessState<ProductVariant?>) {
      if (branchId != null &&
          branchId.isNotEmpty &&
          result.responseData != null) {
        final inventory = await getInventoryOfVariantByBranch(
          result.responseData!.id,
          branchId,
        );
        if (inventory != null) {
          _productRepository.greenBeanDefault.sink.add(
            result.responseData?.copyWith(slotBuy: inventory.toString()),
          );
        }
      } else {
        _productRepository.greenBeanDefault.sink.add(result.responseData);
      }
      emit(
        RoastingSlipSuccess(
          data: result.responseData,
          action: RoastingSlipAction.fetchGreenBeanDefault,
        ),
      );
    } else {
      emit(
        RoastingSlipFailure(
          error: ResponseFailedState.unknownError(),
          action: RoastingSlipAction.fetchGreenBeanDefault,
        ),
      );
    }
  }

  Future<num?> getInventoryOfVariantByBranch(
    String variantId,
    String branchId,
  ) async {
    final result = await _warehouseMiddleware.getInventoryOfVariantByBranch(
      branchId,
      variantId,
    );
    if (result is ResponseSuccessState<num?>) {
      return result.responseData ?? 0;
    } else {
      return 0;
    }
  }

  Future<void> createRoastingSlip({
    required double weight,
    required String variantId,
    required String variantGreenBeanId,
    required String warehouseImportId,
    required String warehouseId,
  }) async {
    emit(const RoastingSlipLoading(action: RoastingSlipAction.create));
    final result = await _productMiddleware.createRoastingSlip(
      weight: weight,
      variantId: variantId,
      variantGreenBeanId: variantGreenBeanId,
      warehouseImportId: warehouseImportId,
      warehouseId: warehouseId,
    );

    if (result is ResponseSuccessState) {
      emit(
        RoastingSlipSuccess(
          data: result.responseData,
          action: RoastingSlipAction.create,
        ),
      );
    } else if (result is ResponseFailedState) {
      emit(
        RoastingSlipFailure(error: result, action: RoastingSlipAction.create),
      );
    } else {
      emit(
        RoastingSlipFailure(
          error: ResponseFailedState.unknownError(),
          action: RoastingSlipAction.create,
        ),
      );
    }
  }
}
