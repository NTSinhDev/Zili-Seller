import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/app_wireframe.dart';
import '../../../bloc/base_cubit.dart';
import '../../../bloc/order/order_cubit.dart';
import '../../../data/models/order/order.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/order_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/base_filter_view.dart';
import '../../common/list_screen_template.dart';
import '../../common/order_card.dart';

class OrdersManagementScreen extends StatefulWidget {
  const OrdersManagementScreen({super.key});

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  final OrderRepository _orderRepository = di<OrderRepository>();
  final OrderCubit _orderCubit = di<OrderCubit>();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOption? _timeOption;
  int _selectedTab = 0; // 0: Tất cả, 1: Đang giao dịch
  String? _currentKeyword;
  String? _statusString;

  @override
  void initState() {
    super.initState();
    _fetchDataScreen();
  }

  Future<void> _fetchDataScreen([BaseEvent? event]) async {
    await _orderCubit.getSellerOrders(
      keyword: _currentKeyword,
      event: event?.name ?? "",
      status: _statusString,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      bloc: _orderCubit,
      builder: (context, state) {
        return ListScreenTemplate<Order>(
          useScaffold: false,
          appBarTitle: 'Quản lý đơn hàng',
          searchHint: 'Tìm kiếm theo mã đơn, tên, sđt người nhận/khách hàng',
          tabs: [
            TabConfig(label: 'Tất cả', value: null),
            TabConfig(
              label: 'Đang giao dịch',
              value: OrderStatus.processing.toConstant,
            ),
          ],
          initialTabIndex: _selectedTab,
          onTabChanged: (index, value) async {
            _selectedTab = index;
            _statusString = value;
            await _fetchDataScreen(BaseEvent.search);
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
                        final start = startDate
                            ?.startOfDate()
                            .toIso8601StringWithTimezone();
                        final end = endDate
                            ?.endOfDate()
                            .toIso8601StringWithTimezone();
                        return onApply((start, end));
                      },
                    ),
                  ],
                ),
              );
            },
            onFilterApplied: (value) {
              _orderCubit.getSellerOrders(
                keyword: _currentKeyword,
                event: BaseEvent.search.name,
                status: _statusString,
                createdAtFrom: value.$1,
                createdAtTo: value.$2,
              );
            },
          ),
          dataStream: _orderRepository.sellerOrdersStream,
          totalCount: _orderRepository.totalSellerOrders,
          emptyMessage: 'Không tìm thấy đơn hàng nào',
          separatorBuilder: (context, index) =>
              index == 0 ? const SizedBox.shrink() : SizedBox(height: 4.h),
          itemBuilder: (_, item, _) => OrderCard(
            order: item,
            onTap: () {
              AppWireFrame.navigateToOrderDetails(
                context,
                code:
                    item.code ??
                    item.orderCode ??
                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
              );
            },
          ),
          headerWidget: Container(
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.background,
            child: Align(
              alignment: .centerLeft,
              child: Text(
                '${_orderRepository.totalSellerOrders} đơn hàng',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.grey84,
                ),
              ),
            ),
          ),
          // Loading states
          isInitialLoading: () =>
              state is OrderLoadingState &&
              (state.event == null || state.event == ""),
          isSearchLoading: () =>
              state is OrderLoadingState && state.event == "search",
          // Callbacks
          onSearch: (keyword) async {
            if (_currentKeyword == keyword) return;
            _currentKeyword = keyword;
            await _fetchDataScreen(BaseEvent.search);
          },
          onRefresh: () async => await _fetchDataScreen(BaseEvent.refresh),
          loadMoreFunc: () {
            final orders = _orderRepository.sellerOrders.valueOrNull ?? [];
            if (orders.isNotEmpty) {
              final records = orders.length;
              final maxRecords = _orderRepository.totalSellerOrders;
              if (maxRecords == records) return null;

              return _orderCubit.loadMoreSellerOrders(
                keyword: _currentKeyword,
                offset: records,
                createdAtFrom: _startDate
                    ?.startOfDate()
                    .toIso8601StringWithTimezone(),
                createdAtTo: _endDate
                    ?.endOfDate()
                    .toIso8601StringWithTimezone(),
              );
            } else {
              return null;
            }
          },
          // Other options
          showSearchResultLabel: true,
          minusMaxScrollValue: 100,
        );
      },
    );
  }
}
