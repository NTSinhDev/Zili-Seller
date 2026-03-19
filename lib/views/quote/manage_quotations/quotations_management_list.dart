import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/base_cubit.dart';
import '../../../bloc/order/order_cubit.dart';
import '../../../data/models/quotation/quotation.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/order_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/order_function.dart';
import '../../common/list_screen_template.dart';
import '../../common/order_card.dart';
import '../details/quotation_details_screen.dart';

class QuotationsManagementView extends StatefulWidget {
  const QuotationsManagementView({super.key});

  @override
  State<QuotationsManagementView> createState() =>
      _QuotationsManagementViewState();
}

class _QuotationsManagementViewState extends State<QuotationsManagementView> {
  final OrderRepository _orderRepository = di<OrderRepository>();
  final OrderCubit _orderCubit = di<OrderCubit>();

  int _selectedTab = 0; // 0: Tất cả, 1:
  String? _currentKeyword;
  String? _statusString;

  @override
  void initState() {
    super.initState();
    _fetchDataScreen();
  }

  Future<void> _fetchDataScreen([BaseEvent? event]) async {
    await _orderCubit.getQuotations(
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
        return ListScreenTemplate<Quotation>(
          useScaffold: false,
          appBarTitle: 'Quản lý phiếu báo giá',
          searchHint: 'Tìm kiếm theo mã, tên, sđt người nhận/khách hàng',
          tabs: [
            TabConfig(label: 'Tất cả', value: null),
            TabConfig(
              label: renderQuoteStatus(QuoteStatus.pending)!,
              value: QuoteStatus.pending.toConstant,
            ),
            TabConfig(
              label: renderQuoteStatus(QuoteStatus.approved)!,
              value: QuoteStatus.approved.toConstant,
            ),
          ],
          initialTabIndex: _selectedTab,
          onTabChanged: (index, value) async {
            if (_selectedTab == index) return;
            _selectedTab = index;
            _statusString = value;
            await _fetchDataScreen(BaseEvent.search);
          },
          showFilterButton: false,
          filterConfig: FilterConfig(
            builder: (context, onApply) {
              // TODO: Implement filter UI nếu cần
              return const SizedBox.shrink();
            },
            onFilterApplied: (a) {
              // TODO: Apply filter logic
            },
          ),
          dataStream: _orderRepository.quotationsStream,
          totalCount: _orderRepository.totalQuotations,
          emptyMessage: 'Không tìm thấy phiếu báo giá nào',
          separatorBuilder: (context, index) =>
              index == 0 ? const SizedBox.shrink() : SizedBox(height: 4.h),
          itemBuilder: (_, item, _) {
            return QuotationCard(
              onTap: () {
                if (item.code.isNotNull) {
                  context.navigator.push(
                    MaterialPageRoute(
                      builder: (context) => QuotationDetailsScreen(
                        code: item.code!,
                        currentKeyword: _currentKeyword,
                        statusString: _statusString,
                      ),
                    ),
                  );
                }
              },
              quotation: item,
            );
          },
          headerWidget: Container(
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.background,
            child: Align(
              alignment: .centerLeft,
              child: Text(
                '${_orderRepository.totalQuotations} phiếu báo giá',
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
            final quotations = _orderRepository.quotations.valueOrNull ?? [];
            if (quotations.isNotEmpty) {
              final records = quotations.length;
              final maxRecords = _orderRepository.totalQuotations;
              if (maxRecords == records) return null;

              return _orderCubit.loadMoreQuotations(
                keyword: _currentKeyword,
                offset: records,
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
