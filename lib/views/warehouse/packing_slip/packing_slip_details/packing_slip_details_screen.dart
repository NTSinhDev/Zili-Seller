import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/base_cubit.dart';
import '../../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../../bloc/warehouse/warehouse_state.dart';
import '../../../../data/models/warehouse/packing_slip_detail.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums/warehouse_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/warehouse_functions.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/packing_slip_item_card.dart';
import '../../../common/status_badge.dart';

part 'components/info_section.dart';
part 'components/not_found_view.dart';
part 'components/note_section.dart';

class PackingSlipDetailsScreen extends StatefulWidget {
  static const routeName = '/packing-slip-details';
  final String code;
  const PackingSlipDetailsScreen({super.key, required this.code});

  @override
  State<PackingSlipDetailsScreen> createState() =>
      _PackingSlipDetailsScreenState();
}

class _PackingSlipDetailsScreenState extends State<PackingSlipDetailsScreen> {
  final WarehouseCubit _cubit = di<WarehouseCubit>();
  bool _isUpdateSlipData = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _cubit.getPackingSlipDetail(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.navigator.pop<bool>(_isUpdateSlipData);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Chi tiết phiếu đóng gói',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
        ),
        body: BlocBuilder<WarehouseCubit, WarehouseState>(
          bloc: _cubit,
          buildWhen: (WarehouseState previous, WarehouseState current) {
            return current is WarehouseError || current is WarehouseLoaded;
          },
          builder: (context, state) {
            if ((state is WarehouseLoading &&
                    state.event != BaseEvent.refresh) ||
                state is WarehouseInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WarehouseError) return const _NotFoundView();

            final detail =
                (state as WarehouseLoaded).items?.firstOrNull
                    as PackingSlipDetail?;
            if (detail == null) return const _NotFoundView();

            return CommonLoadMoreRefreshWrapper.refresh(
              context,
              onRefresh: () async => await _cubit.getPackingSlipDetail(
                widget.code,
                event: BaseEvent.refresh,
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: .symmetric(vertical: 16.h),
                children: [
                  _InfoSection(
                    title: 'Thông tin phiếu đóng gói',
                    rows: _generateSlipInfoRows(detail),
                    belowBottomRows: _belowSlipInfoRows(detail),
                    status: detail.statusEnum,
                  ),
                  SizedBox(height: 16.h),
                  if (detail.items.isNotEmpty)
                    ColumnWidget(
                      crossAxisAlignment: .start,
                      padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                      backgroundColor: Colors.white,
                      gap: 16.h,
                      children: [
                        Text(
                          'Danh sách phiếu',
                          style: AppStyles.text.bold(
                            fSize: 14.sp,
                            color: AppColors.black3,
                          ),
                        ),
                        ...detail.items.map(
                          (item) => PackingSlipItemCard(
                            item: item,
                            onRefresh: () {
                              _isUpdateSlipData = true;
                              _fetchData();
                            },
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16.h),
                  _NoteSection(
                    note: (detail.note?.isNotEmpty ?? false)
                        ? detail.note!
                        : "Chưa có ghi chú",
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<MapEntry<String, String>> _generateSlipInfoRows(
    PackingSlipDetail detail,
  ) {
    return [
      _entry('Mã phiếu:', detail.code),
      _entry(
        'Ngày tạo:',
        DateTime.tryParse(detail.createdAt).formatWithTimezone(),
      ),
      _entry(
        'Ngày ghi nhận:',
        detail.recordedDate?.formatByString(string: 'HH:mm dd/MM/yyyy') ??
            AppConstant.strings.DEFAULT_EMPTY_VALUE,
      ),
      _entry(
        'Chi nhánh:',
        detail.warehouseName ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      ),
      _entry(
        'Người tạo:',
        detail.referencePerson?.fullName ??
            AppConstant.strings.DEFAULT_EMPTY_VALUE,
      ),
    ];
  }

  List<MapEntry<String, String>> _belowSlipInfoRows(PackingSlipDetail detail) {
    return [
      _entry('Tổng số lượng:', detail.totalWeight.toUSD),
      _entry('Số lượng thực tế:', detail.totalWeightMix.toUSD),
      _entry('Số lượng phiếu đóng gói:', '${detail.packingSlipCount}'),
    ];
  }

  MapEntry<String, String> _entry(String k, String v) => MapEntry(k, v);
}
