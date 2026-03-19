import 'package:flutter/material.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/bloc/packing_slip/packing_slip_state.dart';
import 'package:zili_coffee/data/middlewares/warehouse_middleware.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

class PackingSlipCubit extends BaseCubit<PackingSlipState> {
  PackingSlipCubit() : super(const PackingSlipInitial());

  final _warehouseMiddleware = di<WarehouseMiddleware>();
  final _productRepository = di<ProductRepository>();

  // ============================================================================
  // DATA COLLECTION METHODS
  // ============================================================================
  /// Thu thập dữ liệu materials từ các variants đã chọn và controllers
  ///
  /// products: List<Map<String, dynamic>> với format:
  /// [
  ///   {
  ///     'productId': 'productId-id-1',
  ///     'productVariantId': 'variant-id-1',
  ///     'totalWeight': 10.5,
  ///   },
  ///   {
  ///     'productId': 'productId-id-2',
  ///     'productVariantId': 'variant-id-2',
  ///     'totalWeight': 20.0,
  ///   },
  /// ]
  ///
  /// body: Map<String, dynamic> với format:
  /// {
  ///   'products': List<Map<String, dynamic>>,
  ///   'itemId': 'packing-slip-item-id',
  ///   'note': 'note-text',
  /// }
  ///
  ///
  /// return body
  Map<String, dynamic> _getMaterialsData(
    Map<String, TextEditingController> weightControllers,
    String slipItemId,
    String note,
  ) {
    final variants = _productRepository.materialVariants.valueOrNull ?? [];
    final products = <Map<String, dynamic>>[];

    for (final variant in variants) {
      final controller = weightControllers[variant.id];
      if (controller == null) continue;

      // Parse weight từ controller text
      final weightText = controller.text.trim().replaceAll(',', '.');
      final weight = double.tryParse(weightText);

      // Chỉ thêm vào list nếu weight hợp lệ và > 0
      if (weight != null && weight > 0) {
        products.add({
          'productId': variant.productId ?? variant.product?.id ?? '',
          'productVariantId': variant.id,
          'totalWeight': weight,
        });
      }
    }

    // Return body với format đầy đủ
    return {'products': products, 'itemId': slipItemId, 'note': note};
  }

  Future<void> exportWarehouseVariant({
    required Map<String, TextEditingController> weightControllers,
    required String slipItemId,
    required String note,
  }) async {
    emit(const PackingSlipLoading(action: PackingSlipAction.exportWarehouse));
    final body = _getMaterialsData(weightControllers, slipItemId, note);
    final result = await _warehouseMiddleware.confirmPackagingMix(body);

    if (result is ResponseSuccessState<bool>) {
      emit(
        PackingSlipSuccess(
          data: result.responseData,
          action: PackingSlipAction.exportWarehouse,
        ),
      );
    } else if (result is ResponseFailedState) {
      emit(
        PackingSlipFailure(
          error: result,
          action: PackingSlipAction.exportWarehouse,
        ),
      );
    } else {
      emit(
        PackingSlipFailure(
          error: ResponseFailedState.unknownError(),
          action: PackingSlipAction.exportWarehouse,
        ),
      );
    }
  }

  // ============================================================================
  // DATA COLLECTION METHODS
  // ============================================================================
  /// Thu thập dữ liệu materials từ các variants đã chọn và controllers
  ///
  /// products: List<Map<String, dynamic>> với format:
  /// [
  ///   {
  ///     'productId': 'productId-id-1',
  ///     'productVariantId': 'variant-id-1',
  ///     'totalQuantity': 10.5,
  ///   },
  ///   {
  ///     'productId': 'productId-id-2',
  ///     'productVariantId': 'variant-id-2',
  ///     'totalQuantity': 20.0,
  ///   },
  /// ]
  ///
  /// body: Map<String, dynamic> với format:
  /// {
  ///   'products': List<Map<String, dynamic>>,
  ///   'itemId': 'packing-slip-item-id',
  ///   'note': 'note-text',
  /// }
  ///
  ///
  /// return body
  Map<String, dynamic> _getPackagesData(
    Map<String, TextEditingController> weightControllers,
    String slipItemId,
    String note,
  ) {
    final variants = _productRepository.packageVariants.valueOrNull ?? [];
    final products = <Map<String, dynamic>>[];

    for (final variant in variants) {
      final controller = weightControllers[variant.id];
      if (controller == null) continue;

      // Parse weight từ controller text
      final weightText = controller.text.trim().replaceAll(',', '.');
      final weight = double.tryParse(weightText);

      // Chỉ thêm vào list nếu weight hợp lệ và > 0
      if (weight != null && weight > 0) {
        products.add({
          'productId': variant.productId ?? variant.product?.id ?? '',
          'productVariantId': variant.id,
          'totalQuantity': weight,
        });
      }
    }

    // Return body với format đầy đủ
    return {'products': products, 'itemId': slipItemId, 'note': note};
  }

  Future<void> exportWarehousePackage({
    required Map<String, TextEditingController> weightControllers,
    required String slipItemId,
    required String note,
  }) async {
    emit(const PackingSlipLoading(action: PackingSlipAction.exportPackage));
    final body = _getPackagesData(weightControllers, slipItemId, note);
    final result = await _warehouseMiddleware.confirmPackaging(body);

    if (result is ResponseSuccessState<bool>) {
      emit(
        PackingSlipSuccess(
          data: result.responseData,
          action: PackingSlipAction.exportPackage,
        ),
      );
    } else if (result is ResponseFailedState) {
      emit(
        PackingSlipFailure(
          error: result,
          action: PackingSlipAction.exportPackage,
        ),
      );
    } else {
      emit(
        PackingSlipFailure(
          error: ResponseFailedState.unknownError(),
          action: PackingSlipAction.exportPackage,
        ),
      );
    }
  }

  Future<void> completePackingSlip({
    required String slipItemId,
    required double actualQuantity,
    required String? note,
  }) async {
    emit(const PackingSlipLoading(action: PackingSlipAction.completePacking));
    final body = {
      'itemId': slipItemId,
      'actualQuantity': actualQuantity,
      'note': note,
    };
    final result = await _warehouseMiddleware.completePackagingSlip(body);

    if (result is ResponseSuccessState<bool>) {
      emit(
        PackingSlipSuccess(
          data: result.responseData,
          action: PackingSlipAction.completePacking,
        ),
      );
    } else if (result is ResponseFailedState) {
      emit(
        PackingSlipFailure(
          error: result,
          action: PackingSlipAction.completePacking,
        ),
      );
    } else {
      emit(
        PackingSlipFailure(
          error: ResponseFailedState.unknownError(),
          action: PackingSlipAction.completePacking,
        ),
      );
    }
  }
}
