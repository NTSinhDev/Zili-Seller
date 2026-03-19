import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/formatters/input_field.dart';
import 'package:zili_coffee/views/common/empty_view_state.dart';

import '../../../../bloc/packing_slip/packing_slip_cubit.dart';
import '../../../../bloc/packing_slip/packing_slip_state.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/warehouse/packing_slip_item.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/formatters/export.dart';
import '../../../../utils/functions/order_function.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/input_form_field.dart';
import '../../../common/note_input_field.dart';
import '../../../product/select_material_variants/select_material_variants_screen.dart';

part 'components/product_card.dart';
part 'components/material_variant_card.dart';
part 'components/materials_entry_by_search_button.dart';
part 'components/bottom_actions.dart';

class ExportWarehouseForSlipItemScreen extends StatefulWidget {
  static const routeName = '/export-warehouse-for-slip-item';
  final PackingSlipDetailItem slipItem;
  const ExportWarehouseForSlipItemScreen({super.key, required this.slipItem});

  @override
  State<ExportWarehouseForSlipItemScreen> createState() =>
      _ExportWarehouseForSlipItemScreenState();
}

class _ExportWarehouseForSlipItemScreenState
    extends State<ExportWarehouseForSlipItemScreen> {
  // ============================================================================
  // DEPENDENCIES
  // ============================================================================
  final PackingSlipCubit _cubit = di<PackingSlipCubit>();
  final ProductRepository _prodRepository = di<ProductRepository>();

  // ============================================================================
  // CONTROLLERS & FORM KEYS
  // ============================================================================
  /// Controller cho trường ghi chú
  final TextEditingController _noteController = TextEditingController();

  /// Map lưu các TextEditingController cho từng variant (key: variantId)
  /// Mỗi variant có một controller riêng để nhập khối lượng
  final Map<String, TextEditingController> _weightControllers = {};

  /// Map lưu các GlobalKey cho form validation của từng variant
  final Map<String, GlobalKey<FormFieldState>> _weightFieldKeys = {};

  // ============================================================================
  // REACTIVE STATE MANAGEMENT
  // ============================================================================
  /// ValueNotifier để track tổng khối lượng và tự động rebuild UI
  /// Khi bất kỳ controller nào thay đổi, sẽ cập nhật giá trị này
  final ValueNotifier<double> _totalWeightNotifier = ValueNotifier<double>(0.0);

  /// Map lưu các listener callbacks để có thể dispose đúng cách
  /// Key: variantId, Value: listener callback function
  final Map<String, VoidCallback> _controllerListeners = {};

  // ============================================================================
  // CONTROLLER MANAGEMENT METHODS
  // ============================================================================
  /// Lấy hoặc tạo mới TextEditingController cho variant
  ///
  /// Khi tạo controller mới, tự động thêm listener để cập nhật tổng khối lượng
  /// khi người dùng nhập liệu
  ///
  /// [variantId] - ID của variant cần lấy controller
  /// Returns: TextEditingController tương ứng với variantId
  TextEditingController _getWeightController(String variantId) {
    if (!_weightControllers.containsKey(variantId)) {
      final controller = TextEditingController();
      _weightControllers[variantId] = controller;

      // Tạo listener để tự động cập nhật tổng khối lượng khi text thay đổi
      void listener() => _updateTotalWeight();
      controller.addListener(listener);
      _controllerListeners[variantId] = listener;
    }
    return _weightControllers[variantId]!;
  }

  /// Lấy hoặc tạo mới GlobalKey cho form validation của variant
  ///
  /// [variantId] - ID của variant cần lấy key
  /// Returns: GlobalKey<FormFieldState> tương ứng với variantId
  GlobalKey<FormFieldState> _getWeightFieldKey(String variantId) {
    if (!_weightFieldKeys.containsKey(variantId)) {
      _weightFieldKeys[variantId] = GlobalKey<FormFieldState>();
    }
    return _weightFieldKeys[variantId]!;
  }

  /// Xóa controller và các resources liên quan của variant
  ///
  /// Thực hiện cleanup đúng cách:
  /// 1. Remove listener để tránh memory leak
  /// 2. Dispose controller
  /// 3. Xóa khỏi các maps
  /// 4. Cập nhật lại tổng khối lượng
  ///
  /// [variantId] - ID của variant cần xóa
  void _removeVariantControllers(String variantId) {
    // Bước 1: Remove listener trước khi dispose để tránh memory leak
    final controller = _weightControllers[variantId];
    final listener = _controllerListeners[variantId];
    if (controller != null && listener != null) {
      controller.removeListener(listener);
    }

    // Bước 2: Dispose controller và xóa khỏi maps
    controller?.dispose();
    _weightControllers.remove(variantId);
    _weightFieldKeys.remove(variantId);
    _controllerListeners.remove(variantId);

    // Bước 3: Cập nhật lại tổng khối lượng sau khi remove variant
    _updateTotalWeight();
  }

  // ============================================================================
  // TOTAL WEIGHT CALCULATION
  // ============================================================================
  /// Tính toán và cập nhật tổng khối lượng từ tất cả các controller
  ///
  /// Method này được gọi tự động khi bất kỳ controller nào thay đổi
  /// (thông qua listener). Sau đó cập nhật ValueNotifier để trigger
  /// rebuild của ValueListenableBuilder trong UI
  void _updateTotalWeight() {
    // Tính tổng từ tất cả các controller
    final total = _weightControllers.values.fold<double>(0.0, (
      sum,
      controller,
    ) {
      // Parse text thành số, nếu không hợp lệ thì mặc định là 0
      final addWeight = NumExt.tryParseComma(controller.text.trim()) ?? 0;
      return sum + addWeight;
    });

    // Cập nhật ValueNotifier để trigger rebuild UI
    _totalWeightNotifier.value = total;
  }

  @override
  void dispose() {
    // ========================================================================
    // CLEANUP: Dispose tất cả resources để tránh memory leak
    // ========================================================================

    // Bước 1: Remove tất cả listeners trước khi dispose controllers
    for (final entry in _weightControllers.entries) {
      final listener = _controllerListeners[entry.key];
      if (listener != null) {
        entry.value.removeListener(listener);
      }
      entry.value.dispose();
    }

    // Bước 2: Clear tất cả maps
    _weightControllers.clear();
    _weightFieldKeys.clear();
    _controllerListeners.clear();

    // Bước 3: Dispose ValueNotifier
    _totalWeightNotifier.dispose();

    // Bước 4: Reset repository state
    _prodRepository.materialVariants.sink.add([]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackingSlipCubit, PackingSlipState>(
      bloc: _cubit,
      listener: _exportWarehouseListener,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Chọn nguyên liệu đóng gói',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
        ),
        body: SingleChildScrollView(
          padding: .symmetric(vertical: 20.h),
          child: ColumnWidget(
            gap: 20.h,
            children: [
              // ================================================================
              // SECTION 1: Thông tin sản phẩm
              // ================================================================
              ColumnWidget(
                padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                backgroundColor: Colors.white,
                crossAxisAlignment: .start,
                gap: 12.h,
                children: [
                  Text(
                    'Thông tin sản phẩm',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                  _ProductCard(slip: widget.slipItem),
                ],
              ),
              // ================================================================
              // SECTION 2: Thông tin nguyên liệu xuất kho
              // ================================================================
              StreamBuilder<List<ProductVariant>>(
                stream: _prodRepository.materialVariants.stream,
                builder: (context, snapshot) {
                  // Cleanup: Xóa controllers của các variant đã bị remove
                  if (snapshot.hasData) {
                    final currentVariantIds = snapshot.data!
                        .map((v) => v.id)
                        .toSet();
                    final removedIds = _weightControllers.keys
                        .where((id) => !currentVariantIds.contains(id))
                        .toList();
                    for (final id in removedIds) {
                      _removeVariantControllers(id);
                    }
                  }

                  return ColumnWidget(
                    padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                    backgroundColor: Colors.white,
                    crossAxisAlignment: .start,
                    gap: 16.h,
                    children: [
                      Text(
                        'Chọn nguyên liệu',
                        style: AppStyles.text.semiBold(fSize: 16.sp),
                      ),

                      // Nút tìm kiếm và chọn nguyên liệu
                      _MaterialsEntryBySearchButton(_prodRepository),

                      // Hiển thị empty state nếu chưa chọn nguyên liệu nào
                      if (snapshot.data.isNullOrEmpty)
                        const EmptyViewState(
                          message: 'Bạn chưa chọn sản phẩm nào!',
                        )
                      else
                        // Hiển thị danh sách các variant đã chọn
                        ...snapshot.data!.map(
                          (variant) => _MaterialVariantCard(
                            isWeightBased: widget.slipItem.isWeightBased,
                            variant: variant,
                            onRemove: () {
                              // Xóa variant khỏi danh sách
                              _prodRepository.materialVariants.sink.add(
                                _prodRepository.materialVariants.valueOrNull
                                        ?.where((v) => v.id != variant.id)
                                        .toList() ??
                                    [],
                              );
                              // Cleanup controller của variant đã xóa
                              _removeVariantControllers(variant.id);
                            },
                            weightController: _getWeightController(variant.id),
                            weightFieldKey: _getWeightFieldKey(variant.id),
                          ),
                        ),
                      Divider(
                        height: 8.h,
                        color: AppColors.greyC0,
                        thickness: 1.sp,
                      ),
                      // Hiển thị tổng khối lượng - tự động cập nhật khi có thay đổi\
                      ValueListenableBuilder<double>(
                        valueListenable: _totalWeightNotifier,
                        builder: (context, totalWeight, child) {
                          return RowWidget(
                            mainAxisAlignment: .spaceBetween,
                            padding: .only(bottom: 4.h),
                            children: [
                              Text(
                                'Tổng khối lượng thực tế',
                                style: AppStyles.text.semiBold(fSize: 16.sp),
                              ),
                              Text(
                                totalWeight > 0
                                    ? '${totalWeight.toUSD} kg'
                                    : "0",
                                style: AppStyles.text.semiBold(
                                  fSize: 16.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              // ================================================================
              // SECTION 3: Ghi chú
              // ================================================================
              ColumnWidget(
                padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                backgroundColor: Colors.white,
                crossAxisAlignment: .start,
                gap: 12.h,
                children: [
                  Text('Ghi chú', style: AppStyles.text.semiBold(fSize: 16.sp)),
                  NoteInputField(
                    controller: _noteController,
                    labelText: 'Ghi chú',
                    hintText: 'Ghi chú',
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomActions(
          onCancel: () => _handleCancel(context),
          onSubmit: () => _onSubmit(context),
        ),
      ),
    );
  }

  // ============================================================================
  // BLOC LISTENER & STATE HANDLING
  // ============================================================================
  /// Listener để xử lý các state từ PackingSlipCubit
  ///
  /// Xử lý các trường hợp:
  /// - Loading state: Hiển thị/ẩn loading indicator
  /// - Success state: Hiển thị dialog thành công và pop về màn hình trước
  /// - Failure state: Hiển thị dialog lỗi
  void _exportWarehouseListener(BuildContext context, PackingSlipState state) {
    // Xử lý loading state
    if (state is PackingSlipLoading) {
      context.showLoading();
    } else {
      context.hideLoading();
    }

    // Xử lý success state khi xuất kho thành công
    if (state is PackingSlipSuccess &&
        state.action == PackingSlipAction.exportWarehouse) {
      context.navigator.pop(state.action);
    }

    // Xử lý failure state khi xuất kho thất bại
    if (state is PackingSlipFailure &&
        state.action == PackingSlipAction.exportWarehouse) {
      _showError(context, state.error.errorMessage);
    }
  }

  // ============================================================================
  // FORM SUBMISSION & VALIDATION
  // ============================================================================
  /// Xử lý khi người dùng nhấn nút xác nhận xuất kho
  ///
  /// Flow:
  /// 1. Validate tất cả các trường input (nếu cần)
  /// 2. Hiển thị dialog xác nhận
  /// 3. Gọi API để xuất kho (sau khi xác nhận)
  Future<void> _onSubmit(BuildContext context) async {
    // ========================================================================
    // VALIDATION STEP 1: Kiểm tra đã chọn ít nhất một nguyên liệu
    // ========================================================================
    final variants = _prodRepository.materialVariants.valueOrNull;
    if (variants == null || variants.isEmpty) {
      return;
    }

    // ========================================================================
    // VALIDATION STEP 2: Validate tất cả các trường khối lượng
    // ========================================================================
    bool allFieldsValid = true;

    // Validate từng variant đã chọn
    for (final variant in variants) {
      final fieldKey = _weightFieldKeys[variant.id];

      // Kiểm tra xem variant có field key tương ứng không
      if (fieldKey == null) {
        // Trường hợp này không nên xảy ra, nhưng nếu có thì hiển thị dialog
        return _showError(
          context,
          'Vui lòng nhập khối lượng cho nguyên liệu "${renderProductVariantName(variant, variant.options)}"',
        );
      }

      // Validate field - trigger error state trên field nếu invalid
      final isValid = fieldKey.currentState?.validate() ?? false;

      if (!isValid) {
        allFieldsValid = false;
        // Không hiển thị dialog vì field đã tự hiển thị error state
      }
    }

    // Nếu có lỗi validation của input fields, dừng lại (không hiển thị dialog)
    // Vì các input field đã tự hiển thị error state rồi
    if (!allFieldsValid) {
      return;
    }

    // ========================================================================
    // VALIDATION STEP 3: Kiểm tra tổng khối lượng > 0
    // ========================================================================
    final totalWeight = _totalWeightNotifier.value;
    if (totalWeight <= 0) {
      return _showError(context, 'Tổng khối lượng phải lớn hơn 0');
    }

    // ========================================================================
    // Tất cả validation đã pass -> Hiển thị dialog xác nhận
    // ========================================================================

    await showNoticeDialog(
      context: context,
      title: 'Xuất kho nguyên liệu',
      message: 'Xác nhận xuất kho nguyên liệu từ các thông tin đã chọn?',
      variant: NoticeVariant.confirm,
      secondaryAction: NoticeDialogAction(
        label: 'Hủy',
        onPressed: context.navigator.pop,
      ),
      primaryAction: NoticeDialogAction(
        label: 'Xác nhận',
        onPressed: () async {
          context.navigator.pop(); // Đóng dialog confirm
          await _cubit.exportWarehouseVariant(
            slipItemId: widget.slipItem.id,
            weightControllers: _weightControllers,
            note: _noteController.text.trim(),
          );
        },
      ),
    );
  }

  // ============================================================================
  // UI HELPERS
  // ============================================================================
  /// Hiển thị dialog lỗi với message tương ứng
  ///
  /// [context] - BuildContext để hiển thị dialog
  /// [message] - Nội dung thông báo lỗi
  void _showError(BuildContext context, String message) {
    showNoticeDialog(
      context: context,
      title: 'Lỗi',
      message: message,
      variant: NoticeVariant.error,
      primaryAction: NoticeDialogAction(
        label: 'Đóng',
        onPressed: context.navigator.pop,
      ),
    );
  }

  /// Xử lý khi người dùng nhấn nút hủy/thoát
  ///
  /// Nếu đã có dữ liệu nhập vào, hiển thị dialog xác nhận trước khi thoát
  /// Nếu chưa có dữ liệu, thoát ngay lập tức
  void _handleCancel(BuildContext context) {
    // Kiểm tra xem đã có nguyên liệu nào được chọn chưa
    if (_prodRepository.materialVariants.valueOrNull?.isNotEmpty == true) {
      // Có dữ liệu -> Hiển thị dialog xác nhận
      showNoticeDialog(
        context: context,
        title: 'Thoát khỏi trang?',
        message:
            'Thông tin xuất kho nguyên liệu sẽ mất, xác nhận để thoát khỏi trang.',
        variant: NoticeVariant.confirm,
        secondaryAction: NoticeDialogAction(
          label: 'Hủy',
          onPressed: context.navigator.pop,
        ),
        primaryAction: NoticeDialogAction(
          label: 'Xác nhận',
          onPressed: () => context.navigator
            ..pop() // Đóng dialog
            ..pop(), // Pop về màn hình trước
          isDestructive: true,
        ),
      );
    } else {
      // Chưa có dữ liệu -> Thoát ngay
      context.navigator.pop();
    }
  }
}
