import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/warehouse/warehouse_cubit.dart';
import 'package:zili_coffee/views/common/input_form_field.dart';

import '../../bloc/packing_slip/packing_slip_state.dart';
import '../../data/models/warehouse/packing_slip_item.dart';
import '../../di/dependency_injection.dart';
import '../../res/res.dart';
import '../../utils/extension/extension.dart';
import '../../utils/functions/warehouse_functions.dart';
import '../../utils/helpers/permission_helper.dart';
import '../../utils/widgets/widgets.dart';
import '../warehouse/packing_slip/packing_slip_details/components/complete_packing_bottom_sheet.dart';
import '../warehouse/packing_slip/export_package_for_slip_item/export_package_for_slip_item_screen.dart';
import '../warehouse/packing_slip/export_warehouse_for_slip_item/export_warehouse_for_slip_item_screen.dart';
import '../warehouse/packing_slip/packing_slip_item_details/packing_slip_item_details_screen.dart';
import 'status_badge.dart';

class PackingSlipItemCard extends StatelessWidget {
  final PackingSlipDetailItem item;
  final VoidCallback? onRefresh;
  final bool isShowActions;
  const PackingSlipItemCard({
    super.key,
    required this.item,
    this.onRefresh,
    this.isShowActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isShowActions
          ? () => context.navigator
                .pushNamed(
                  PackingSlipItemDetailsScreen.routeName,
                  arguments: item,
                )
                .then((isUpdateSlipData) {
                  if (isUpdateSlipData == true) {
                    onRefresh?.call();
                  }
                })
          : null,
      child: Container(
        width: .infinity,
        padding: .all(12.w),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: .circular(12.r),
        ),
        child: ColumnWidget(
          crossAxisAlignment: .start,
          gap: 8.h,
          children: [
            RowWidget(
              mainAxisAlignment: .start,
              gap: 12.w,
              children: [
                Text(
                  item.code,
                  style: AppStyles.text.bold(
                    fSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
                if (item.statusEnum != null)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        if (packingSlipStatusColor(item.statusEnum) != null)
                          StatusBadge(
                            label: packingSlipStatusLabel(item.statusEnum!),
                            color: packingSlipStatusColor(item.statusEnum)!,
                          ),
                        // if (isShowActions) _packingSlipItemActions(context),
                      ],
                    ),
                  ),
              ],
            ),
            Divider(height: 8.h, color: AppColors.greyC0, thickness: 1.sp),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  item.isWeightBased ? 'Khối lượng thực tế' : 'Số lượng',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black3,
                  ),
                ),
                Text(
                  item.totalWeightMix > 0
                      ? '${item.totalWeightMix.toUSD}${item.isWeightBased ? " (kg)" : ""}'
                      : AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Tổng sản phẩm',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black3,
                  ),
                ),
                Text(
                  item.statusEnum == .completed
                      ? '${item.actualQuantity} ${item.measureUnit}'
                      : AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
            if (item.note != null && item.note!.isNotEmpty)
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Ghi chú',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black3,
                    ),
                  ),
                  Text(
                    item.note ?? "",
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
            Divider(height: 8.h, color: AppColors.greyC0, thickness: 1.sp),
            _buildPackingProduct(),
            if (isShowActions) _packingSlipItemActions(context),
          ],
        ),
      ),
    );
  }

  Widget _packingSlipItemActions(BuildContext context) {
    if (!PermissionHelper.edit(AbilitySubject.packagingManagement)) {
      return const SizedBox.shrink();
    }
    List<String> actions = [];
    // Xuất kho nguyên liệu
    if (item.statusEnum == .newRequest) {
      actions.addAll(["Hủy", "Xuất nguyên liệu"]);
    }
    // Xuất kho nguyên liệu
    else if (item.statusEnum == .packing) {
      actions.addAll(["Hủy", "Xuất bao bì"]);
    } else if (item.statusEnum == .confirmed) {
      actions.addAll(["Hủy", "Xác nhận"]);
    }
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return RowWidget(
      margin: .only(top: 8.h),
      padding: .only(top: 8.h),
      border: Border(
        top: BorderSide(color: AppColors.greyC0, width: 1.sp),
      ),
      gap: 12.w,
      children: [
        Expanded(
          child: actions.length > 1
              ? OutlinedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: .vertical(top: .circular(20.r)),
                      ),
                      isScrollControlled: true,
                      builder: (_) => CancelPackingView(item.id),
                    ).then((value) {
                      if (context.mounted && value != null && value is bool?) {
                        if (value!) onRefresh?.call();
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.scarlet),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                  ),
                  child: Text(
                    actions[0],
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.scarlet,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              if (item.statusEnum == .newRequest) {
                context.navigator
                    .pushNamed(
                      ExportWarehouseForSlipItemScreen.routeName,
                      arguments: item,
                    )
                    .then((value) {
                      if (value == PackingSlipAction.exportWarehouse) {
                        onRefresh?.call();
                      }
                    });
              } else if (item.statusEnum == .packing) {
                context.navigator
                    .pushNamed(
                      ExportPackageForSlipItemScreen.routeName,
                      arguments: item,
                    )
                    .then((value) {
                      if (value == PackingSlipAction.exportPackage) {
                        onRefresh?.call();
                      }
                    });
              } else if (item.statusEnum == .confirmed) {
                _showCompletePackingBottomSheet(context);
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.warning),
              shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
            ),
            child: Text(
              actions.length > 1 ? actions[1] : actions[0],
              style: AppStyles.text.semiBold(
                fSize: 14.sp,
                color: AppColors.warning,
              ),
            ),
          ),
        ),
      ],
    );
    // Nút xuất kh kho nguyên liệu
    if (item.statusEnum == .newRequest) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.navigator
                .pushNamed(
                  ExportWarehouseForSlipItemScreen.routeName,
                  arguments: item,
                )
                .then((value) {
                  if (value == PackingSlipAction.exportWarehouse) {
                    onRefresh?.call();
                  }
                });
          },
          borderRadius: .circular(1000),
          child: Container(
            padding: .all(4.w),
            decoration: BoxDecoration(
              color: AppColors.greyC0.withValues(alpha: 0.28),
              shape: .circle,
            ),
            child: SvgPicture.asset(
              AssetIcons.iExportWarehouseSvg,
              width: 20.w,
              height: 20.w,
              colorFilter: const .mode(AppColors.primary, .srcIn),
              fit: .contain,
            ),
          ),
        ),
      );
    }

    if (item.statusEnum == .packing) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.navigator
                .pushNamed(
                  ExportPackageForSlipItemScreen.routeName,
                  arguments: item,
                )
                .then((value) {
                  if (value == PackingSlipAction.exportPackage) {
                    onRefresh?.call();
                  }
                });
          },
          borderRadius: .circular(1000),
          child: Container(
            padding: .all(4.w),
            decoration: BoxDecoration(
              color: AppColors.greyC0.withValues(alpha: 0.28),
              shape: .circle,
            ),
            child: SvgPicture.asset(
              AssetIcons.iExportPackingSvg,
              width: 20.w,
              height: 20.w,
              colorFilter: const .mode(AppColors.primary, .srcIn),
              fit: .contain,
            ),
          ),
        ),
      );
    }

    if (item.statusEnum == .confirmed) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showCompletePackingBottomSheet(context);
          },
          borderRadius: .circular(1000),
          child: Container(
            padding: .all(4.w),
            decoration: BoxDecoration(
              color: AppColors.greyC0.withValues(alpha: 0.28),
              shape: .circle,
            ),
            child: Icon(
              Icons.playlist_add_check_outlined,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showCompletePackingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: .only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: CompletePackingBottomSheet(
            item: item,
            onRefresh: () {
              CustomSnackBarWidget(
                context,
                type: CustomSnackBarType.success,
                message: "Phiếu đóng gói đã được hoàn thành.",
              ).show();
              onRefresh?.call();
            },
          ),
        );
      },
    );
  }

  Widget _buildPackingProduct() {
    return ColumnWidget(
      crossAxisAlignment: .start,
      gap: 8.h,
      children: [
        Text(
          'Sản phẩm',
          style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
        ),
        Container(
          width: .infinity,
          padding: .all(12.w),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            border: Border.all(
              color: AppColors.green.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: .circular(8.r),
          ),
          child: RowWidget(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 8.h,
                  children: [
                    Text(
                      item.productNameVi.trim(),
                      style: AppStyles.text.semiBold(
                        fSize: 12.sp,
                        color: AppColors.black5,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    if (item.options.isNotEmpty)
                      Text(
                        item.options.map((e) => e.value).join(' - '),
                        style: AppStyles.text.medium(
                          fSize: 10.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                  ],
                ),
              ),
              ColumnWidget(
                crossAxisAlignment: .end,
                gap: 8.h,
                children: [
                  Text(
                    item.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Khối lượng: ${item.totalWeight.toUSD} (kg)',
                    style: AppStyles.text.medium(fSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CancelPackingView extends StatefulWidget {
  final String id;
  const CancelPackingView(this.id, {super.key});

  @override
  State<CancelPackingView> createState() => _CancelPackingViewState();
}

class _CancelPackingViewState extends State<CancelPackingView> {
  final _textController = TextEditingController();
  final _fieldKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColumnWidget(
        mainAxisSize: MainAxisSize.min,
        padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
        children: [
          BottomSheetHeader(
            title: 'Hủy phiếu đóng gói',
            onClose: context.navigator.maybePop,
          ),
          const SizedBox(height: 16),
          ColumnWidget(
            padding: .symmetric(horizontal: 20.w),
            mainAxisSize: .min,
            children: [
              InputFormField(
                controller: _textController,
                formFieldKey: _fieldKey,
                label: 'Lý do (*)',
                hint: 'Nhập lý do (*)',
                textInputAction: .done,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              RowWidget(
                gap: 12.w,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: context.navigator.pop,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.black3),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Thoát",
                        style: AppStyles.text.semiBold(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_textController.text.trim().isEmpty) return;
                        context.showLoading();
                        di<WarehouseCubit>()
                            .cancelMixPacking(
                              widget.id,
                              _textController.text.trim(),
                            )
                            .then((r) {
                              if (context.mounted) {
                                context.hideLoading();
                                context.navigator.pop(r);
                                CustomSnackBarWidget(
                                  context,
                                  type: r ? .success : .error,
                                  message: r
                                      ? "Hủy phiếu đóng gói thành công"
                                      : "Hủy phiếu đóng gói thất bại!",
                                ).show();
                              }
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Xác nhận",
                        style: AppStyles.text.semiBold(
                          fSize: 14.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
