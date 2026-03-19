import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/customer/customer_cubit.dart';
import 'package:zili_coffee/data/models/user/customer.dart';
import 'package:zili_coffee/data/repositories/customer_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/customer/details/customer_details_screen.dart';

import '../../app/app_wireframe.dart';
import '../../bloc/base_cubit.dart';
import '../../data/dto/customer/filter_customers_input.dart';
import '../../utils/enums.dart';
import '../../utils/enums/customer_enum.dart';
import '../../utils/functions/customer_functions.dart';
import '../common/base_filter_view.dart';
import '../common/empty_view_state.dart';
import '../common/list_screen_template.dart';
import '../common/status_badge.dart';

part 'components/customer_list_item.dart';
part 'components/customer_filter_tabs.dart';
part 'components/customer_sort_bottom_sheet.dart';
part 'components/customer_filter_bottom_sheet.dart';

class CustomerScreen extends StatefulWidget {
  final String? initialKeyword;
  const CustomerScreen({super.key, this.initialKeyword});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  int _selectedTab = 0;
  TimeOption? _timeOption;
  final FilterCustomersInput _filterCustomersInput = FilterCustomersInput();
  @override
  void initState() {
    super.initState();
    _customerCubit.filterCustomers(
      input: _filterCustomersInput,
      isInitialLoad: true,
    );
  }

  Future<void> _onRefresh() async {
    _filterCustomersInput.offset = 0;
    await _customerCubit.filterCustomers(
      input: _filterCustomersInput,
      event: "refresh",
    );
  }

  void _navigateToCustomerDetail(Customer customer) {
    context.navigator.pushNamed(
      CustomerDetailsScreen.routeName,
      arguments: customer.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCubit, CustomerState>(
      bloc: _customerCubit,
      listener: (context, state) {
        if (state is FailedCustomerState) {
          CustomSnackBarWidget(
            context,
            type: .error,
            message: state.error.errorMessage,
          ).show();
        }
      },
      builder: (context, state) {
        return ListScreenTemplate<Customer>(
          useScaffold: false,
          appBarTitle: 'Quản lý khách hàng',
          searchHint: 'Nhập tên, số điện thoại, mã',
          tabs: [
            TabConfig(label: 'Tất cả', value: null),
            TabConfig(label: 'Đang giao dịch', value: CustomerStatus.active),
          ],
          initialTabIndex: _selectedTab,
          onTabChanged: (index, value) async {
            _selectedTab = index;
            _filterCustomersInput.statuses = value != null ? [value!] : null;
            await _customerCubit.filterCustomers(input: _filterCustomersInput);
          },
          dataStream: _customerRepository.customersFilter.stream,
          totalCount: _customerRepository.totalCustomers,
          emptyMessage: 'Không tìm thấy khách hàng nào',
          emptyWidget: EmptyViewState(
            onTap: () => AppWireFrame.navigateToAddCustomer(context),
            iconWidget: Icon(
              Icons.person_add_alt_1_rounded,
              size: 64.sp,
              color: AppColors.grey97,
            ),
            labelButton: 'Thêm khách hàng',
            label: 'Chưa có khách hàng',
            description: 'Nhấn nút thêm để thêm khách hàng mới!',
            message: 'Không tìm thấy khách hàng nào',
          ),
          separatorBuilder: (context, index) =>
              index == 0 ? const SizedBox.shrink() : SizedBox(height: 4.h),
          itemBuilder: (context, item, index) {
            return _CustomerListItem(
              customer: item,
              onTap: () => _navigateToCustomerDetail(item),
            );
          },
          headerWidget: Container(
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.background,
            child: Align(
              alignment: .centerLeft,
              child: Text(
                '${_customerRepository.totalCustomers} khách hàng',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.grey84,
                ),
              ),
            ),
          ),
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
                      startDate: _filterCustomersInput.createdAtFrom,
                      endDate: _filterCustomersInput.createdAtTo,
                      selectedTimeOption: _timeOption,
                      onFilterApplied: (startDate, endDate, timeOption) {
                        _filterCustomersInput.createdAtFrom = startDate;
                        _filterCustomersInput.createdAtTo = endDate;
                        _timeOption = timeOption;
                        return onApply(_filterCustomersInput);
                      },
                    ),
                  ],
                ),
              );
            },
            onFilterApplied: (value) {
              _customerCubit.filterCustomers(
                input: _filterCustomersInput,
                event: BaseEvent.search.name,
              );
            },
          ),
          isInitialLoading: () =>
              state is LoadingCustomerState && (state.event == ""),
          isSearchLoading: () =>
              state is LoadingCustomerState && state.event == "search",
          onSearch: (keyword) async {
            if (_filterCustomersInput.keyword == keyword) return;
            _filterCustomersInput.keyword = keyword;
            await _customerCubit.filterCustomers(input: _filterCustomersInput);
          },
          onRefresh: _onRefresh,
          loadMoreFunc: () {
            final customers =
                _customerRepository.customersFilter.valueOrNull ?? [];
            if (customers.isNotEmpty) {
              final records = customers.length;
              final maxRecords = _customerRepository.totalCustomers;
              if (maxRecords == records) return null;

              return _customerCubit.loadMoreCustomers(
                _filterCustomersInput.loadMore(offset: records),
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
