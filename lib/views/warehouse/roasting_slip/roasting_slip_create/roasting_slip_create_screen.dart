import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/roasting_slip/roasting_slip_cubit.dart';
import '../../../../bloc/roasting_slip/roasting_slip_state.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/warehouse/warehouse.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/repositories/warehouse_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums/product_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/formatters/export.dart';
import '../../../../utils/functions/order_function.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/input_form_field.dart';
import '../../../product/select_coffee_variant/select_coffee_variant_screen.dart';

part 'components/bottom_actions.dart';
part 'components/green_bean_view.dart';
part 'components/import_warehouse.dart';
part 'components/roasted_beans_selector.dart';
part 'components/export_warehouse.dart';

class RoastingSlipCreateScreen extends StatefulWidget {
  static const routeName = '/roasting-slip-create';
  const RoastingSlipCreateScreen({super.key});

  @override
  State<RoastingSlipCreateScreen> createState() =>
      _RoastingSlipCreateScreenState();
}

class _RoastingSlipCreateScreenState extends State<RoastingSlipCreateScreen> {
  // Repositories/streams
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();
  final ProductRepository _prodRepository = di<ProductRepository>();
  final RoastingSlipCubit _cubit = di<RoastingSlipCubit>();

  // Form controllers & selections
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _weightController = TextEditingController(
    text: '',
  );
  final GlobalKey<FormFieldState> _weightFieldKey = GlobalKey<FormFieldState>();
  Warehouse? _importWarehouse;
  Warehouse? _exportWarehouse;
  ProductVariant? _roastedBean;
  ProductVariant? _greenBean;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _warehouseRepository.warehouseSubject.listen((warehouses) {
        if (warehouses.isNotEmpty) {
          _importWarehouse = warehouses.firstWhere(
            (w) => w.isDefault == true,
            orElse: () => warehouses.first,
          );
          _exportWarehouse = _importWarehouse;
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _weightController.dispose();
    _prodRepository.greenBeanDefault.drain();
    _prodRepository.greenBeanDefault.sink.add(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoastingSlipCubit, RoastingSlipState>(
      bloc: _cubit,
      listener: _createListener,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Tạo phiếu rang',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
          onBack: () {
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            context.navigator.pop();
          },
        ),
        body: SingleChildScrollView(
          padding: .symmetric(vertical: 20.h),
          child: ColumnWidget(
            gap: 20.h,
            children: [
              ColumnWidget(
                padding: .symmetric(horizontal: 16.w, vertical: 20.h),
                backgroundColor: Colors.white,
                crossAxisAlignment: .start,
                gap: 16.h,
                children: [
                  Text(
                    'Thông tin hạt rang thành phẩm',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                  _ImportWarehouse(
                    importWarehouse: _importWarehouse,
                    onChanged: _handleWarehouseSelected,
                  ),
                  // Chọn thành phẩm hạt rang (1 sản phẩm duy nhất)
                  _RoastedBeansSelector(
                    selected: _roastedBean,
                    importBranchId: _importWarehouse?.id ?? '',
                    onSelected: (variant) =>
                        setState(() => _roastedBean = variant),
                    onClear: () => setState(() => _roastedBean = null),
                    weightController: _weightController,
                    onFetchGreenBeanDefault: (id) =>
                        _cubit.fetchGreenBeanDefault(
                          id,
                          branchId: _exportWarehouse?.id ?? '',
                        ),
                    weightFieldKey: _weightFieldKey,
                  ),
                ],
              ),
              // Khi đã có green bean default detail, hiển thị khối xuất kho
              if (_roastedBean != null) ...[
                StreamBuilder<ProductVariant?>(
                  stream: _prodRepository.greenBeanDefault.stream,
                  builder: (context, snapshot) {
                    return ColumnWidget(
                      padding: .symmetric(horizontal: 16.w, vertical: 20.h),
                      backgroundColor: Colors.white,
                      crossAxisAlignment: .start,
                      gap: 16.h,
                      children: [
                        Text(
                          'Thông tin xuất kho',
                          style: AppStyles.text.semiBold(fSize: 16.sp),
                        ),
                        _ExportWarehouse(
                          exportWarehouse: _exportWarehouse,
                          onChanged: (warehouse) {
                            setState(() => _exportWarehouse = warehouse);
                            final greenBeanVariant =
                                _prodRepository.greenBeanDefault.valueOrNull ??
                                _greenBean;
                            if (greenBeanVariant != null) {
                              _cubit
                                  .getInventoryOfVariantByBranch(
                                    greenBeanVariant.id,
                                    warehouse.id,
                                  )
                                  .then((value) {
                                    if (value != null) {
                                      if (_prodRepository
                                              .greenBeanDefault
                                              .valueOrNull !=
                                          null) {
                                        _prodRepository.greenBeanDefault.sink
                                            .add(
                                              greenBeanVariant.copyWith(
                                                slotBuy: value.toString(),
                                              ),
                                            );
                                      } else {
                                        setState(
                                          () =>
                                              _greenBean = _greenBean!.copyWith(
                                                slotBuy: value.toString(),
                                              ),
                                        );
                                      }
                                    }
                                  });
                            }
                          },
                        ),
                        _GreenBeanView(
                          greenBean: snapshot.data ?? _greenBean,
                          isDefault: snapshot.data != null,
                          branchId: _exportWarehouse?.id ?? '',
                          onSelected: (greenBean) =>
                              setState(() => _greenBean = greenBean),
                        ),
                      ],
                    );
                  },
                ),
              ],
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

  void _createListener(BuildContext context, RoastingSlipState state) {
    if (state is RoastingSlipLoading) {
      context.showLoading();
    } else {
      context.hideLoading();
    }

    if (state is RoastingSlipSuccess &&
        state.action == RoastingSlipAction.create) {
      context.navigator.pop(state.data);
      CustomSnackBarWidget(
        context,
        type: CustomSnackBarType.success,
        message: 'Đã tạo phiếu rang thành công.',
      ).show(duration: const Duration(seconds: 2));
    }

    if (state is RoastingSlipFailure &&
        state.action == RoastingSlipAction.create) {
      _showError(context, state.error.errorMessage);
    }

    if (state is RoastingSlipFailure &&
        state.action == RoastingSlipAction.fetchGreenBeanDefault) {
      _showError(context, state.error.errorMessage);
    }
  }

  Future<void> _onSubmit(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final isWeightValid = _weightFieldKey.currentState?.validate() ?? false;
    if (!isWeightValid) return;

    final weightRaw = _weightController.text.trim().replaceAll(',', '.');
    final weightValue = NumExt.tryParseComma(weightRaw);
    final greenBean = _prodRepository.greenBeanDefault.valueOrNull;
    // Validate selections
    if (_importWarehouse == null) {
      return _showError(context, 'Vui lòng chọn chi nhánh nhập.');
    }
    if (_exportWarehouse == null) {
      return _showError(context, 'Vui lòng chọn chi nhánh xuất.');
    }
    if (_roastedBean == null) {
      return _showError(context, 'Vui lòng chọn sản phẩm hạt rang thành phẩm.');
    }
    if (_greenBean == null && greenBean == null) {
      return _showError(
        context,
        'Vui lòng chọn sản phẩm hạt xanh nguyên liệu.',
      );
    }
    if (weightValue == null || weightValue < 0.01) {
      return _showError(
        context,
        'Khối lượng rang phải lớn hơn hoặc bằng 0.01.',
      );
    }

    // Confirm before submitting
    await showNoticeDialog(
      context: context,
      title: 'Tạo phiếu rang',
      message: 'Xác nhận tạo phiếu rang từ các thông tin đã chọn?',
      variant: NoticeVariant.confirm,
      secondaryAction: NoticeDialogAction(
        label: 'Hủy',
        onPressed: context.navigator.pop,
      ),
      primaryAction: NoticeDialogAction(
        label: 'Xác nhận',
        onPressed: () async {
          context.navigator.pop(); // đóng dialog confirm
          await _cubit.createRoastingSlip(
            weight: weightValue.toDouble(),
            variantId: _roastedBean!.id,
            variantGreenBeanId: greenBean?.id ?? _greenBean?.id ?? '',
            warehouseImportId: _importWarehouse!.id,
            warehouseId: _exportWarehouse!.id,
          );
        },
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        duration: const Duration(seconds: 2),
        content: RowWidget(
          gap: 8.w,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.scarlet.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(Icons.close, size: 16.sp, color: AppColors.scarlet),
            ),
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: .ellipsis,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.scarlet,
                  height: 14 / 12,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Đóng',
          backgroundColor: AppColors.greyFx,
          textColor: AppColors.black5,
          onPressed: () => messenger.clearSnackBars(),
        ),
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    showNoticeDialog(
      context: context,
      title: 'Rời trang?',
      message: 'Thông tin tạo phiếu rang sẽ mất, xác nhận để rời trang.',
      variant: NoticeVariant.confirm,
      secondaryAction: NoticeDialogAction(
        label: 'Hủy',
        onPressed: context.navigator.pop,
      ),
      primaryAction: NoticeDialogAction(
        label: 'Xác nhận',
        onPressed: () => context.navigator
          ..pop()
          ..pop(),
        isDestructive: true,
      ),
    );
  }

  void _handleWarehouseSelected(Warehouse? warehouse) {
    if (warehouse == null) return;
    setState(() => _importWarehouse = warehouse);
    if (_roastedBean != null) {
      _cubit.getInventoryOfVariantByBranch(_roastedBean!.id, warehouse.id).then(
        (value) {
          if (value != null) {
            setState(
              () => _roastedBean = _roastedBean!.copyWith(
                slotBuy: value.toString(),
              ),
            );
          }
        },
      );
    }
  }
}
