import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/warehouse/warehouse_cubit.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums/warehouse_enum.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/common/empty_view_state.dart';

import '../../../../data/models/warehouse/packing_slip_item.dart';
import '../../../../data/models/warehouse/roasting_slip.dart';
import '../../../../data/repositories/warehouse_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../services/common_service.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/warehouse_functions.dart';
import '../../../../utils/helpers/permission_helper.dart';
import '../../../common/packing_slip_item_card.dart';
import '../../../common/shimmer_view.dart';
import '../../../common/slip_card.dart';
import '../../roasting_slip/export.dart';

part 'components/status_statistic.dart';
part 'components/filter_tabs.dart';

class ExportedWarehouseScreen extends StatefulWidget {
  final Function(int, RoastingSlipStatus status) changePageCallback;
  const ExportedWarehouseScreen({super.key, required this.changePageCallback});

  @override
  State<ExportedWarehouseScreen> createState() =>
      _ExportedWarehouseScreenState();
}

class _ExportedWarehouseScreenState extends State<ExportedWarehouseScreen> {
  final WarehouseCubit _warehouseCubit = di<WarehouseCubit>();
  final WarehouseRepository _warehouseRepo = di<WarehouseRepository>();
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchDataScreen();
  }

  Future<void> _fetchDataScreen() async {
    if (_tabIndex == 0) {
      _warehouseCubit.getTotalRoastingSlips();
      _warehouseCubit.getNewestRoastingSlips();
      _warehouseCubit.getProcessingRoastingSlips();
    } else {
      _warehouseCubit.getTotalPackingSlips();
      _warehouseCubit.getAwaitPackingSlipItems();
    }
  }

  List<StatusStatisticItem> _getListStatistic(List<int> data) {
    if (_tabIndex == 0) {
      return [
        .new(
          roastingSlipStatusColor(RoastingSlipStatus.newRequest)!,
          roastingSlipStatusLabel(RoastingSlipStatus.newRequest),
          data[0],
        ),
        .new(
          roastingSlipStatusColor(RoastingSlipStatus.roasting)!,
          roastingSlipStatusLabel(RoastingSlipStatus.roasting),
          data[1],
        ),
        .new(
          roastingSlipStatusColor(RoastingSlipStatus.completed)!,
          roastingSlipStatusLabel(RoastingSlipStatus.completed),
          data[2],
        ),
      ];
    } else {
      return [
        .new(
          packingSlipStatusColor(PackingSlipStatus.newRequest)!,
          packingSlipStatusLabel(PackingSlipStatus.newRequest),
          data[0],
        ),
        .new(
          packingSlipStatusColor(PackingSlipStatus.processing)!,
          packingSlipStatusLabel(PackingSlipStatus.processing),
          data[1],
        ),
        .new(
          packingSlipStatusColor(PackingSlipStatus.completed)!,
          packingSlipStatusLabel(PackingSlipStatus.completed),
          data[2],
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLoadMoreRefreshWrapper.refresh(
      context,
      onRefresh: _fetchDataScreen,
      child: ColumnWidget(
        mainAxisSize: .min,
        children: [
          StreamBuilder<List<int>>(
            stream: _warehouseRepo.technicalRoleStatistic.stream,
            builder: (context, asyncSnapshot) {
              final state = asyncSnapshot.data ?? [];

              return StatusStatistic(
                list: _getListStatistic(state.isNotEmpty ? state : [0, 0, 0]),
                isLoadedState: state.isNotEmpty,
              );
            },
          ),
          _FilterTabs(
            selectedTab: _tabIndex,
            onTabChanged: (index) {
              context.focus.unfocus();
              setState(() => _tabIndex = index);
              _fetchDataScreen();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height(height: 8),
                  if (_tabIndex == 0)
                    ..._buildRoastingSlipView(context)
                  else
                    ..._buildPackingSlipItemsView(context),
                  height(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPackingSlipItemsView(BuildContext context) {
    return [
      StreamBuilder<List<PackingSlipDetailItem>>(
        stream: _warehouseRepo.awaitPackingSlip.stream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          return ColumnWidget(
            mainAxisSize: .min,
            backgroundColor: Colors.white,
            padding: .symmetric(horizontal: 20.w, vertical: 16.h),
            gap: 8.h,
            children: [
              RowWidget(
                children: [
                  Expanded(
                    child: Text(
                      "Chờ xuất kho",
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              if (snapshot.connectionState == .waiting)
                Column(
                  children: [
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                  ],
                )
              else if (snapshot.hasData && snapshot.data!.isEmpty)
                EmptyViewState(message: "Không có phiếu đóng gói cần xuất kho")
              else
                ...List.generate(items.length, (index) {
                  final slip = items[index];
                  return PackingSlipItemCard(
                    item: slip,
                    onRefresh: _fetchDataScreen,
                  );
                }),
            ],
          );
        },
      ),
    ];
  }

  List<Widget> _buildRoastingSlipView(BuildContext context) {
    return [
      StreamBuilder<List<RoastingSlip>>(
        stream: _warehouseRepo.newestRoastingSlip.stream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          return ColumnWidget(
            // crossAxisAlignment: .start,
            mainAxisSize: .min,
            backgroundColor: Colors.white,
            padding: .symmetric(vertical: 10.h),
            gap: 8.h,
            children: [
              RowWidget(
                padding: .symmetric(horizontal: 20.w),
                children: [
                  Expanded(
                    child: Text(
                      "Chờ xử lý",
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        widget.changePageCallback(
                          1,
                          RoastingSlipStatus.newRequest,
                        );
                      },
                      child: RowWidget(
                        gap: 5.w,
                        children: [
                          Text(
                            "Xem thêm",
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primary,
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (snapshot.connectionState == .waiting)
                Column(
                  children: [
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                  ],
                )
              else if (snapshot.hasData && snapshot.data!.isEmpty)
                EmptyViewState(message: "Không có phiếu rang mới")
              else
                ...List.generate(items.length, (index) {
                  final slip = items[index];
                  return SlipCard(
                    slip: slip
                      ..statusLabel = roastingSlipStatusLabel(slip.statusEnum)
                      ..statusLabelColor = roastingSlipStatusColor(
                        slip.statusEnum,
                      )
                      ..cardColor = roastingSlipStatusColor(slip.statusEnum)
                      ..infoRows = slip.infoRows,
                    onTap: () => context.navigator.pushNamed(
                      RoastingSlipDetailScreen.routeName,
                      arguments: slip.code,
                    ),
                  );
                }),
              if (items.isNotEmpty)
                Container(
                  margin: .symmetric(vertical: 4.h),
                  child: TextButton(
                    onPressed: () {
                      di<CommonService>().loadWarehousesData();

                      context.navigator.pushNamed(
                        RoastingSlipCreateScreen.routeName,
                      );
                    },
                    child: RowWidget(
                      mainAxisSize: .min,
                      mainAxisAlignment: .center,
                      gap: 8.w,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        Text(
                          "Tạo phiếu rang",
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      height(height: 24),
      StreamBuilder<List<RoastingSlip>>(
        stream: _warehouseRepo.processingRoastingSlip.stream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          return ColumnWidget(
            crossAxisAlignment: .start,
            backgroundColor: Colors.white,
            padding: .symmetric(vertical: 10.h),
            mainAxisSize: .min,
            gap: 8.h,
            children: [
              RowWidget(
                padding: .symmetric(horizontal: 20.w),
                children: [
                  Expanded(
                    child: Text(
                      "Đang xử lý",
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        widget.changePageCallback(
                          1,
                          RoastingSlipStatus.roasting,
                        );
                      },
                      child: RowWidget(
                        gap: 5.w,
                        children: [
                          Text(
                            "Xem thêm",
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primary,
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (snapshot.connectionState == .waiting)
                Column(
                  children: [
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                    Container(
                      margin: .symmetric(horizontal: 20.w),
                      child: const ShimmerView(type: .card),
                    ),
                  ],
                )
              else if (snapshot.hasData && snapshot.data!.isEmpty)
                EmptyViewState(message: "Không có phiếu rang đang xử lý")
              else
                ...List.generate(items.length, (index) {
                  final slip = items[index];
                  return SlipCard(
                    slip: slip
                      ..statusLabel = roastingSlipStatusLabel(slip.statusEnum)
                      ..statusLabelColor = roastingSlipStatusColor(
                        slip.statusEnum,
                      )
                      ..cardColor = roastingSlipStatusColor(slip.statusEnum)
                      ..infoRows = slip.infoRows,
                    onTap: () => context.navigator.pushNamed(
                      RoastingSlipDetailScreen.routeName,
                      arguments: slip.code,
                    ),
                  );
                }),
            ],
          );
        },
      ),
    ];
  }
}
