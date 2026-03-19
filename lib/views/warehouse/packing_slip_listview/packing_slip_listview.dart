import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/base_cubit.dart';
import '../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../bloc/warehouse/warehouse_state.dart';
import '../../../data/models/warehouse/packing_slip.dart';
import '../../../data/repositories/warehouse_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/warehouse_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/warehouse_functions.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/base_filter_view.dart';
import '../../common/list_screen_template.dart';
import '../../common/slip_card.dart';
import '../packing_slip/packing_slip_details/packing_slip_details_screen.dart';

class PackingSlipListView extends StatefulWidget {
  const PackingSlipListView({super.key});

  @override
  State<PackingSlipListView> createState() => _PackingSlipListViewState();
}

class _PackingSlipListViewState extends State<PackingSlipListView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);
  final WarehouseCubit _cubit = di<WarehouseCubit>();
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();

  int _selectedTab = 0;
  PackingSlipStatus? _status;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOption? _timeOption;
  String? _currentKeyword;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchDataScreen();
  }

  void _onSearchChanged() {
    EasyDebounce.debounce(
      'packingSlipSearch',
      const Duration(milliseconds: 400),
      () {
        final text = _searchController.text.trim();
        if ((_currentKeyword ?? '') == text) return;
        _currentKeyword = text.isEmpty ? null : text;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchDataScreen([BaseEvent? event]) async {
    await _cubit.getPackingSlips(
      keyword: _currentKeyword,
      event: event,
      status: _status,
      createdAtFrom: _startDate?.startOfDate(),
      createdAtTo: _endDate?.endOfDate(),
    );
  }

  Stream<List<PackingSlip>> getStreamingData() =>
      _warehouseRepository.packingSlipSubject.stream;

  List<PackingSlip> getCurrentList() =>
      _warehouseRepository.packingSlipSubject.valueOrNull ?? [];

  int getTotalCount() => _warehouseRepository.totalPSRecord;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseCubit, WarehouseState>(
      bloc: _cubit,
      builder: (context, state) {
        return ListScreenTemplate<PackingSlip>(
          useScaffold: false,
          searchHint: 'Tìm kiếm theo mã phiếu, tên phiên bản,...',
          dataStream: getStreamingData(),
          totalCount: getTotalCount(),
          emptyMessage: 'Không tìm thấy phiếu đóng gói nào',
          tabs: [
            TabConfig(label: 'Tất cả', value: null),
            TabConfig(
              label: packingSlipStatusLabel(PackingSlipStatus.newRequest),
              value: PackingSlipStatus.newRequest,
            ),
            TabConfig(
              label: packingSlipStatusLabel(PackingSlipStatus.processing),
              value: PackingSlipStatus.processing,
            ),
            TabConfig(
              label: packingSlipStatusLabel(PackingSlipStatus.completed),
              value: PackingSlipStatus.completed,
            ),
          ],
          initialTabIndex: _selectedTab,
          onTabChanged: (index, value) async {
            if (_selectedTab == index) return;
            _selectedTab = index;
            _status = value;
            await _fetchDataScreen();
          },
          showFilterButton: true,
          filterConfig: FilterConfig(
            builder: (filterCtx, onApply) {
              final bottomPadding = MediaQuery.of(filterCtx).viewPadding.bottom;
              final keyboardHeight = MediaQuery.of(filterCtx).viewInsets.bottom;
              return Padding(
                padding: .only(bottom: bottomPadding + keyboardHeight),
                child: ColumnWidget(
                  mainAxisSize: .min,
                  children: [
                    BottomSheetHeader(
                      title: "Bộ lọc tìm kiếm",
                      onClose: filterCtx.navigator.pop,
                    ),
                    BaseFilterView(
                      startDate: _startDate,
                      endDate: _endDate,
                      selectedTimeOption: _timeOption,
                      onFilterApplied: (startDate, endDate, timeOption) {
                        setState(() {
                          _startDate = startDate;
                          _endDate = endDate;
                          _timeOption = timeOption;
                        });
                        final start = startDate?.startOfDate();
                        final end = endDate?.endOfDate();
                        return onApply((start, end));
                      },
                    ),
                  ],
                ),
              );
            },
            onFilterApplied: (value) {
              _cubit.getPackingSlips(
                keyword: _currentKeyword,
                status: _status,
                createdAtFrom: value.$1,
                createdAtTo: value.$2,
              );
            },
          ),
          separatorBuilder: (context, index) =>
              index == 0 ? const SizedBox.shrink() : SizedBox(height: 16.h),
          itemBuilder: (_, slip, _) {
            return SlipCard(
              slip: slip
                ..statusLabel = packingSlipStatusLabel(slip.statusEnum)
                ..statusLabelColor = packingSlipStatusColor(slip.statusEnum)
                ..cardColor = packingSlipStatusColor(slip.statusEnum)
                ..infoRows = slip.infoRows,
              onTap: () => context.navigator
                  .pushNamed(
                    PackingSlipDetailsScreen.routeName,
                    arguments: slip.code,
                  )
                  .then((isUpdateSlipData) {
                    if (context.mounted) {
                      context.focus.unfocus();
                    }
                    if (isUpdateSlipData == true) {
                      _fetchDataScreen();
                    }
                  }),
            );
          },
          headerWidget: Container(
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.background,
            child: Align(
              alignment: .centerLeft,
              child: Text(
                '${getTotalCount()} phiếu đóng gói',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.grey84,
                ),
              ),
            ),
          ),
          // Loading states
          isInitialLoading: () =>
              state is WarehouseLoading && (state.event == null),
          isSearchLoading: () =>
              state is WarehouseLoading && state.event == BaseEvent.search,
          // Callbacks
          onSearch: (keyword) async {
            if (_currentKeyword == keyword) return;
            _currentKeyword = keyword;
            await _fetchDataScreen(BaseEvent.search);
          },
          onRefresh: () async => await _fetchDataScreen(BaseEvent.refresh),
          loadMoreFunc: () {
            final list = getCurrentList();
            if (list.isNotEmpty) {
              final records = list.length;
              final maxRecords = getTotalCount();
              if (maxRecords == records) return null;

              return _cubit.loadMorePackingSlips(
                offset: list.length,
                keyword: _currentKeyword,
                status: _status,
                createdAtFrom: _startDate?.startOfDate(),
                createdAtTo: _endDate?.endOfDate(),
              );
            } else {
              return null;
            }
          },
          showSearchResultLabel: true,
          minusMaxScrollValue: 100,
        );
      },
    );
  }
}
