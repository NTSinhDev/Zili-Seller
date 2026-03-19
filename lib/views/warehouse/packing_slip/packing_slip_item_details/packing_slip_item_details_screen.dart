import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/warehouse/warehouse_cubit.dart';

import '../../../../bloc/packing_slip/packing_slip_state.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/warehouse/packing_slip_item.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums/warehouse_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/warehouse_functions.dart';
import '../../../../utils/helpers/permission_helper.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/packing_slip_item_card.dart';
import '../../../common/status_badge.dart';
import '../../../common/warehouse_product_card.dart';
import '../export_package_for_slip_item/export_package_for_slip_item_screen.dart';
import '../export_warehouse_for_slip_item/export_warehouse_for_slip_item_screen.dart';
import '../packing_slip_details/components/complete_packing_bottom_sheet.dart';

part 'components/info_section.dart';
part 'components/ingredient_card.dart';
part 'components/packaging_card.dart';
part 'components/note_section.dart';

class PackingSlipItemDetailsScreen extends StatefulWidget {
  static const routeName = '/packing-slip-item-details';
  final PackingSlipDetailItem item;
  const PackingSlipItemDetailsScreen({super.key, required this.item});

  @override
  State<PackingSlipItemDetailsScreen> createState() =>
      _PackingSlipItemDetailsScreenState();
}

class _PackingSlipItemDetailsScreenState
    extends State<PackingSlipItemDetailsScreen> {
  late PackingSlipDetailItem _slipDetailItem;
  bool _isUpdateSlipData = false;

  @override
  void initState() {
    super.initState();
    _slipDetailItem = widget.item;
  }

  Future<void> _onRefresh() async {
    final newData = await di<WarehouseCubit>().getPackingSlipItemDetail(
      widget.item.code,
    );
    if (newData != null) {
      setState(() {
        _slipDetailItem = newData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (!didPop) {
          context.navigator.pop<bool>(_isUpdateSlipData);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Chi tiết phiếu ${_slipDetailItem.code}',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
          // onBack: () {
          //   ScaffoldMessenger.of(context).clearSnackBars();
          //   context.navigator.pop<bool>(_isUpdateSlipData);
          // },
        ),
        body: CommonLoadMoreRefreshWrapper.refresh(
          context,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ColumnWidget(
              gap: 16.h,
              margin: .only(top: 16.h),
              children: [
                _InfoSection(item: _slipDetailItem),
                if (_slipDetailItem.itemMixes.isNotEmpty)
                  ColumnWidget(
                    crossAxisAlignment: .start,
                    padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                    backgroundColor: Colors.white,
                    gap: 12.h,
                    children: [
                      Text(
                        'Danh sách nguyên liệu đã xuất',
                        style: AppStyles.text.bold(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                      ..._slipDetailItem.itemMixes.map(
                        (mix) => _IngredientCard(item: mix),
                      ),
                      if (_slipDetailItem.mixNote != null &&
                          _slipDetailItem.mixNote!.isNotEmpty) ...[
                        Divider(
                          color: AppColors.greyC0,
                          height: 1.h,
                          thickness: 1.sp,
                        ),
                        SizedBox(
                          width: .infinity,
                          child: ColumnWidget(
                            crossAxisAlignment: .start,
                            gap: 8.h,
                            children: [
                              Text(
                                'Ghi chú',
                                style: AppStyles.text.bold(
                                  fSize: 14.sp,
                                  color: AppColors.black3,
                                ),
                              ),
                              Container(
                                width: .infinity,
                                constraints: BoxConstraints(minHeight: 60.h),
                                padding: .all(12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: .circular(12.r),
                                ),
                                child: Text(
                                  _slipDetailItem.mixNote ??
                                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                  style: AppStyles.text.medium(
                                    fSize: 12.sp,
                                    color: AppColors.black3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                if (_slipDetailItem.itemPackaging.isNotEmpty)
                  ColumnWidget(
                    crossAxisAlignment: .start,
                    padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                    backgroundColor: Colors.white,
                    gap: 12.h,
                    children: [
                      Text(
                        'Bao bì đóng gói',
                        style: AppStyles.text.bold(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                      ..._slipDetailItem.itemPackaging.map(
                        (packaging) => _PackagingCard(item: packaging),
                      ),
                      if (_slipDetailItem.packagingNote != null &&
                          _slipDetailItem.packagingNote!.isNotEmpty) ...[
                        Divider(
                          color: AppColors.greyC0,
                          height: 1.h,
                          thickness: 1.sp,
                        ),
                        SizedBox(
                          width: .infinity,
                          child: ColumnWidget(
                            crossAxisAlignment: .start,
                            gap: 8.h,
                            children: [
                              Text(
                                'Ghi chú',
                                style: AppStyles.text.bold(
                                  fSize: 14.sp,
                                  color: AppColors.black3,
                                ),
                              ),
                              Container(
                                width: .infinity,
                                constraints: BoxConstraints(minHeight: 60.h),
                                padding: .all(12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: .circular(12.r),
                                ),
                                child: Text(
                                  _slipDetailItem.packagingNote ??
                                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                  style: AppStyles.text.medium(
                                    fSize: 12.sp,
                                    color: AppColors.black3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
            PermissionHelper.edit(AbilitySubject.packagingManagement)
            ? _BottomActions(
                onCancel:
                    <PackingSlipStatus>[
                      .newRequest,
                      .packing,
                      .confirmed,
                    ].contains(_slipDetailItem.statusEnum)
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: .vertical(top: .circular(20.r)),
                          ),
                          isScrollControlled: true,
                          builder: (_) => CancelPackingView(_slipDetailItem.id),
                        ).then((value) {
                          if (context.mounted &&
                              value != null &&
                              value is bool?) {
                            _isUpdateSlipData = true;
                            if (value!) _onRefresh();
                          }
                        });
                      }
                    : null,
                onExportWarehouse: _slipDetailItem.statusEnum == .newRequest
                    ? () {
                        context.navigator
                            .pushNamed(
                              ExportWarehouseForSlipItemScreen.routeName,
                              arguments: _slipDetailItem,
                            )
                            .then((value) {
                              if (value == PackingSlipAction.exportWarehouse) {
                                _isUpdateSlipData = true;
                                bool showLoading = false;
                                if (context.mounted) {
                                  showLoading = true;
                                  context.showLoading();
                                }
                                _onRefresh().then((_) {
                                  if (showLoading && context.mounted) {
                                    context.hideLoading();
                                  }
                                });
                              }
                            });
                      }
                    : null,
                onExportPacking: _slipDetailItem.statusEnum == .packing
                    ? () {
                        context.navigator
                            .pushNamed(
                              ExportPackageForSlipItemScreen.routeName,
                              arguments: _slipDetailItem,
                            )
                            .then((value) {
                              if (value == PackingSlipAction.exportPackage) {
                                _isUpdateSlipData = true;
                                bool showLoading = false;
                                if (context.mounted) {
                                  showLoading = true;
                                  context.showLoading();
                                }
                                _onRefresh().then((_) {
                                  if (showLoading && context.mounted) {
                                    context.hideLoading();
                                  }
                                });
                              }
                            });
                      }
                    : null,
                onComplete: _slipDetailItem.statusEnum == .confirmed
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (bottomSheetContext) {
                            return Padding(
                              padding: .only(
                                bottom: MediaQuery.of(
                                  bottomSheetContext,
                                ).viewInsets.bottom,
                              ),
                              child: CompletePackingBottomSheet(
                                item: _slipDetailItem,
                                onRefresh: () {
                                  _isUpdateSlipData = true;
                                  CustomSnackBarWidget(
                                    context,
                                    type: CustomSnackBarType.success,
                                    message:
                                        "Phiếu đóng gói đã được hoàn thành.",
                                  ).show();
                                  bool showLoading = false;
                                  if (context.mounted) {
                                    showLoading = true;
                                    context.showLoading();
                                  }
                                  _onRefresh().then((_) {
                                    if (showLoading && context.mounted) {
                                      context.hideLoading();
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        );
                      }
                    : null,
              )
            : null,
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final VoidCallback? onExportWarehouse;
  final VoidCallback? onExportPacking;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;
  const _BottomActions({
    this.onExportWarehouse,
    this.onExportPacking,
    this.onComplete,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: .symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.grayEA)),
        ),
        child: RowWidget(
          gap: 20.w,
          children: [
            if (onCancel.isNotNull)
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.scarlet),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                  ),
                  child: Text(
                    "Hủy phiếu",
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.scarlet,
                    ),
                  ),
                ),
              ),
            if (onExportPacking.isNotNull)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  onPressed: onExportPacking,
                  child: Text(
                    'Xuất bao bì',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            if (onExportWarehouse.isNotNull)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  onPressed: onExportWarehouse,
                  child: Text(
                    'Xuất nguyên liệu',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            if (onComplete.isNotNull)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  onPressed: onComplete,
                  child: Text(
                    'Hoàn thành',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
