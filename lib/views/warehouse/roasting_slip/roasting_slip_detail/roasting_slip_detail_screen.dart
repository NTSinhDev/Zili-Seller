import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zili_coffee/utils/formatters/input_field.dart';

import '../../../../bloc/base_cubit.dart';
import '../../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../../bloc/warehouse/warehouse_state.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/warehouse/roasting_slip_detail.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums/warehouse_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/warehouse_functions.dart';
import '../../../../utils/helpers/permission_helper.dart';
import '../../../../utils/functions/product_variant_functions.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/input_form_field.dart';
import '../../../common/note_input_field.dart';
import '../../../common/status_badge.dart';

part 'components/bottom_actions.dart';
part 'components/info_section.dart';
part 'components/card.dart';
part 'components/not_found_view.dart';
part 'components/dispatch_bottom_sheet.dart';
part 'components/cancel_bottom_sheet.dart';
part 'components/complete_bottom_sheet.dart';

class RoastingSlipDetailScreen extends StatefulWidget {
  static const routeName = '/roasting-slip-detail';
  final String code;
  const RoastingSlipDetailScreen({super.key, required this.code});

  @override
  State<RoastingSlipDetailScreen> createState() =>
      _RoastingSlipDetailScreenState();
}

class _RoastingSlipDetailScreenState extends State<RoastingSlipDetailScreen> {
  final WarehouseCubit _cubit = di<WarehouseCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getRoastingSlipDetail(widget.code);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _exportWeightByStatus(RoastingSlipDetail detail) {
    switch (detail.statusEnum) {
      case RoastingSlipStatus.newRequest:
      case RoastingSlipStatus.cancelled:
        return AppConstant.strings.DEFAULT_EMPTY_VALUE;
      case RoastingSlipStatus.completed:
      case RoastingSlipStatus.roasting:
      default:
        return '${detail.pickedWeight.toUSD} kg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: widget.code,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        onBack: () {
          final messenger = ScaffoldMessenger.of(context);
          messenger.clearSnackBars();
          context.navigator.pop();
        },
      ),
      body: BlocConsumer<WarehouseCubit, WarehouseState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is WarehouseLoading && state.event == BaseEvent.post) {
            context.showLoading();
          } else if (state is WarehouseSucceed) {
            context.hideLoading();
            context.navigator.pop();
            String message = '';
            if (state is ExportWarehouseSucceed) {
              message = 'Xuất kho nhân xanh thành công';
            } else if (state is CancelWarehouseSucceed) {
              message = 'Hủy phiếu rang thành công';
            } else if (state is CompleteWarehouseSucceed) {
              message = 'Hoàn thành phiếu rang thành công';
            }
            CustomSnackBarWidget(
              context,
              type: CustomSnackBarType.success,
              message: message,
            ).show(duration: const Duration(seconds: 2));
          } else if (state is WarehouseFailed) {
            context.hideLoading();
            context.navigator.pop();
            String message = '';
            if (state is ExportWarehouseFailed) {
              message = 'Xuất kho nhân xanh thất bại!';
            } else if (state is CancelWarehouseFailed) {
              message = 'Hủy phiếu rang thất bại!';
            } else if (state is CompleteWarehouseFailed) {
              message = 'Hoàn thành phiếu rang thất bại!';
            }
            CustomSnackBarWidget(
              context,
              type: CustomSnackBarType.error,
              message: message,
            ).show(duration: const Duration(seconds: 2));
          }
        },
        buildWhen: (WarehouseState previous, WarehouseState current) {
          return current is WarehouseInitial ||
              current is WarehouseError ||
              current is WarehouseLoaded;
        },
        builder: (context, state) {
          if ((state is WarehouseLoading && state.event != BaseEvent.refresh) ||
              state is WarehouseInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WarehouseError) return const _NotFoundView();
          final detail =
              (state as WarehouseLoaded).items?.firstOrNull
                  as RoastingSlipDetail?;
          if (detail == null) return const _NotFoundView();

          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: () => _cubit.getRoastingSlipDetail(
              widget.code,
              event: BaseEvent.refresh,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ColumnWidget(
                gap: 16.h,
                margin: .only(top: 16.h),
                padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                backgroundColor: AppColors.white,
                children: [
                  _InfoSection(
                    title: 'Thông tin phiếu',
                    status: detail.statusEnum,
                    rows: _generateSlipInfoRows(detail),
                  ),
                  _CardProductSection(
                    title: 'Thông tin xuất kho',
                    variant: detail.greenVariant,
                    branch: detail.exportWarehouseName ?? detail.warehouseName,
                    exportWeight: _exportWeightByStatus(detail),
                  ),
                  _CardProductSection(
                    title: 'Thông tin hạt rang thành phẩm',
                    variant: detail.roastedVariant,
                    branch: detail.warehouseName,
                    expectedWeight: '${detail.roastedEstimateWeight.toUSD} kg',
                    extraRows: _extraRowsOfRoastedBean(detail),
                  ),
                  if (_generateAdditionalRows(detail).isNotEmpty)
                    _InfoSection(
                      title: 'Thông tin bổ sung',
                      rows: _generateAdditionalRows(detail),
                    )
                  else
                    SizedBox(
                      width: .infinity,
                      child: ColumnWidget(
                        crossAxisAlignment: .start,
                        gap: 8.h,
                        children: [
                          Text(
                            'Thông tin bổ sung',
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
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          PermissionHelper.edit(AbilitySubject.roastingSlipManagement)
          ? BlocBuilder<WarehouseCubit, WarehouseState>(
              bloc: _cubit,
              buildWhen: (WarehouseState previous, WarehouseState current) {
                return current is WarehouseInitial ||
                    current is WarehouseError ||
                    current is WarehouseLoaded;
              },
              builder: (context, state) {
                if (state is WarehouseLoading ||
                    state is WarehouseInitial ||
                    state is WarehouseError) {
                  return const SizedBox.shrink();
                }
                RoastingSlipDetail? detail;
                if (state is WarehouseLoaded) {
                  detail = state.items?.firstOrNull as RoastingSlipDetail?;
                }
                if (detail == null) return const SizedBox.shrink();

                final canEdit = _hasEditPermission(detail);
                if (detail.statusEnum == RoastingSlipStatus.newRequest) {
                  return _BottomActions(
                    canEdit: canEdit,
                    onCancel: () => _showCancelRoastingSlip(context, detail!),
                    onExport: () =>
                        _showDispatchWarehouseView(context, detail!),
                  );
                } else if (detail.statusEnum == RoastingSlipStatus.roasting) {
                  return _BottomActions(
                    canEdit: canEdit,
                    onComplete: () =>
                        _showCompleteRoastingSlip(context, detail!),
                  );
                }

                return const SizedBox.shrink();
              },
            )
          : null,
    );
  }

  bool _hasEditPermission(RoastingSlipDetail detail) {
    return PermissionHelper.manage(AbilitySubject.roastingSlipManagement) ||
        PermissionHelper.edit(AbilitySubject.roastingSlipManagement);
  }

  void _showCancelRoastingSlip(
    BuildContext context,
    RoastingSlipDetail detail,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final bottom = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: .only(bottom: bottom),
          child: _CancelBottomSheet(
            onSubmit: (note) => _cubit.cancelRoastingSlip(
              roastingSlipId: detail.code,
              note: note,
            ),
          ),
        );
      },
    );
  }

  void _showDispatchWarehouseView(
    BuildContext context,
    RoastingSlipDetail detail,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) => Padding(
        padding: .only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
        child: _DispatchBottomSheet(
          detail: detail,
          onSubmit: (w, id, txt) => _cubit.exportRoastingSlipGreenBean(
            roastingSlipId: id,
            weight: w,
            note: txt,
          ),
        ),
      ),
    );
  }

  void _showCompleteRoastingSlip(
    BuildContext context,
    RoastingSlipDetail detail,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) => Padding(
        padding: .only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
        child: _CompleteBottomSheet(
          detail: detail,
          onSubmit: (w, id, txt) => _cubit.completeRoastingSlip(
            roastingSlipId: id,
            weight: w,
            note: txt,
          ),
        ),
      ),
    );
  }

  List<MapEntry<String, String>> _extraRowsOfRoastedBean(
    RoastingSlipDetail detail,
  ) {
    if (detail.statusEnum == RoastingSlipStatus.completed) {
      return [
        _entry('Khối lượng thực tế', '${detail.roastedWeight.toUSD} kg'),
        _entry(
          'Hao hụt',
          '${detail.lossWeight.toUSD} kg (${detail.lossPercent.toUSD}%)',
        ),
      ];
    }
    return [];
  }

  List<MapEntry<String, String>> _generateSlipInfoRows(
    RoastingSlipDetail detail,
  ) {
    final initRows = [
      _entry('Mã phiếu:', detail.code),
      _entry('Ngày tạo:', _fmtDate(detail.createdAt)),
      _entry('Người tạo:', detail.creatorName),
    ];
    if (detail.cancelledAt != null) {
      initRows.add(_entry('Ngày hủy:', _fmtDate(detail.cancelledAt)));
    } else {
      initRows.add(_entry('Ngày xuất kho:', _fmtDate(detail.confirmExportAt)));
      initRows.add(_entry('Ngày hoàn thành:', _fmtDate(detail.completedAt)));
      if (detail.verifiedName != null) {
        initRows.add(
          _entry(
            'Xác nhận hoàn thành:',
            detail.verifiedName ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
          ),
        );
      }
    }
    return initRows;
  }

  List<MapEntry<String, String>> _generateAdditionalRows(
    RoastingSlipDetail detail,
  ) {
    final initRows = <MapEntry<String, String>>[];
    if (detail.cancelledReason != null) {
      initRows.add(
        _entry(
          'Lý do hủy:',
          detail.cancelledReason ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
      );
    }
    if (detail.exportedNote != null) {
      initRows.add(
        _entry(
          'Ghi chú xuất kho:',
          detail.exportedNote ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
      );
    }
    if (detail.completedNote != null) {
      initRows.add(
        _entry(
          'Ghi chú hoàn thành:',
          detail.completedNote ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
      );
    }

    return initRows;
  }

  MapEntry<String, String> _entry(String k, String v) => MapEntry(k, v);

  String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) {
      return AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('HH:mm dd/MM/yyyy').format(dt);
    } catch (_) {
      return AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }
  }
}
