import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_debounce/easy_debounce.dart';

import '../../../../app/app_wireframe.dart';
import '../../../../bloc/customer/customer_cubit.dart';
import '../../../../data/dto/customer/filter_customers_input.dart';
import '../../../../data/models/user/customer.dart';
import '../../../../data/repositories/customer_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../common/action_app_bar.dart';
import '../../common/common_search_bar.dart';
import '../../common/shimmer_view.dart';
import '../../module_common/avatar.dart';

class SelectCustomersScreen extends StatefulWidget {
  final Customer? currentSelected;
  const SelectCustomersScreen({super.key, this.currentSelected});

  static String keyName = '/select-customers';

  @override
  State<SelectCustomersScreen> createState() => _SelectCustomersScreenState();
}

class _SelectCustomersScreenState extends State<SelectCustomersScreen> {
  // ** Managers - controllers.
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  final FilterCustomersInput _filterCustomersInput = FilterCustomersInput();
  // ** State variables.
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filterCustomersInput.keyword = _searchController.text.trim();
    _customerCubit.filterCustomers(
      input: _filterCustomersInput,
      isInitialLoad: true,
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    EasyDebounce.cancel('customerSearch');
    EasyDebounce.debounce(
      'customerSearch',
      const Duration(milliseconds: 500),
      () async {
        final keyword = _searchController.text.trim();
        if (keyword != _filterCustomersInput.keyword) {
          _filterCustomersInput
            ..keyword = keyword.isEmpty ? null : keyword
            ..offset = 0;
          await _customerCubit.filterCustomers(
            input: _filterCustomersInput,
            isInitialLoad: false,
          );
        }
      },
    );
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await _customerCubit.filterCustomers(
      input: _filterCustomersInput..offset = 0,
      event: "refresh",
    );
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final customers = _customerRepository.customersFilter.valueOrNull;
    if (customers != null) {
      final records = customers.length;
      final maxRecords = _customerRepository.totalCustomers;
      if (maxRecords == records) return true;
    }
    _isLoadMore = true;
    if (mounted) setState(() {});
    _filterCustomersInput.offset = customers?.length ?? 0;
    _customerCubit.loadMoreCustomers(_filterCustomersInput).then((_) {
      _isLoadMore = false;
      if (mounted) setState(() {});
    });
    return true;
  }

  Widget _pageListener(BuildContext context, {required Widget child}) {
    return BlocListener<CustomerCubit, CustomerState>(
      bloc: _customerCubit,
      listener: (context, state) {
        if (state is LoadingCustomerState &&
            state.event != "loadMore" &&
            state.event != "search" &&
            state.event != "refresh") {
          context.showLoading();
        } else if (state is LoadedCustomerState) {
          context.hideLoading();
        } else if (state is ErrorCustomerState) {
          context.hideLoading();
          CustomSnackBarWidget(
            context,
            type: .error,
            message: "Lỗi khi tải danh sách khách hàng",
          ).show();
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pageListener(
      context,
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Chọn khách hàng',
          actions: AppBarActions.build([
            AppBarActionModel(
              icon: Icons.add,
              color: AppColors.black,
              onTap: () => AppWireFrame.navigateToAddCustomer(context),
              circleFrame: true,
            ),
          ]),
        ),
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            CommonSearchBar(
              leadingWrapper: (context, child, loadingState) {
                return BlocBuilder<CustomerCubit, CustomerState>(
                  bloc: _customerCubit,
                  builder: (context, state) {
                    final isSearching =
                        state is LoadingCustomerState &&
                        state.event == "search";

                    return isSearching ? loadingState : child;
                  },
                );
              },
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintSearch: 'Tìm khách hàng theo tên, email, số điện thoại,...',
            ),
            Expanded(
              child: CommonLoadMoreRefreshWrapper(
                onRefresh: _onRefresh,
                onLoadMore: _onLoadMore,
                minusMaxScrollValue: 100.h,
                child: BlocConsumer<CustomerCubit, CustomerState>(
                  bloc: _customerCubit,
                  listener: (context, state) {
                    if (state is LoadingCustomerState &&
                        state.event == "getDefaultCustomerAddressV1") {
                      context.showLoading();
                    } else if (state is LoadedCustomerState<Customer>) {
                      context.hideLoading();
                      context.navigator.pop(state.data);
                    } else {
                      context.hideLoading();
                    }
                  },
                  builder: (context, cubitState) {
                    final isSearching =
                        cubitState is LoadingCustomerState &&
                        cubitState.event == "search";

                    return StreamBuilder<List<Customer>>(
                      stream: _customerRepository.customersFilter.stream,
                      builder: (context, snapshot) {
                        // Initial load state - show shimmer
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !isSearching) {
                          return ShimmerView(type: .loadingIndicatorAtHead);
                        }

                        // Search loading state - show inline loading indicator
                        if (isSearching &&
                            snapshot.hasData &&
                            snapshot.data!.isEmpty) {
                          return ShimmerView(type: .onlyLoadingIndicator);
                        }

                        if (snapshot.hasData) {
                          final customers = snapshot.data!;
                          final totalResults =
                              _customerRepository.totalCustomers;

                          if (customers.isEmpty) {
                            return _buildEmptyState();
                          }

                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ).copyWith(top: 4.h),
                            itemCount: customers.length + 1,
                            itemBuilder: (context, index) {
                              if (index == customers.length) {
                                if (index < (totalResults - 1)) {
                                  return ShimmerView(
                                    type: .onlyLoadingIndicator,
                                  );
                                }
                                return Padding(
                                  padding: .all(20.w),
                                  child: Center(
                                    child: Text(
                                      'Đã hiển thị tất cả khách hàng',
                                      style: AppStyles.text.medium(
                                        fSize: 14.sp,
                                        color: AppColors.grey84,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                margin: .only(bottom: 12.w),
                                child: _CustomerListItem(
                                  customer: customers[index],
                                  isSelected:
                                      widget.currentSelected?.id ==
                                      customers[index].id,
                                  onSelected: _customerCubit
                                      .getDefaultCustomerAddressV1,
                                ),
                              );
                            },
                          );
                        }

                        return _buildEmptyState();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ColumnWidget(
      mainAxisAlignment: .center,
      margin: .only(bottom: 0.2.sh),
      gap: 16.h,
      children: [
        Icon(Icons.shopping_bag_outlined, size: 64.sp, color: AppColors.grey84),
        Text(
          _filterCustomersInput.keyword != null
              ? 'Không tìm thấy khách hàng nào'
              : 'Chưa có sản phẩm nào được chọn',
          style: AppStyles.text.medium(fSize: 16.sp, color: AppColors.grey84),
        ),
        Text(
          _filterCustomersInput.keyword != null
              ? 'Thử tìm kiếm với từ khóa khác'
              : 'Tìm kiếm và chọn khách hàng để thêm vào đơn hàng',
          style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey97),
          textAlign: .center,
        ),
      ],
    );
  }
}

class _CustomerListItem extends StatelessWidget {
  final Customer customer;
  final bool isSelected;
  final Function(Customer) onSelected;
  const _CustomerListItem({
    required this.customer,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(customer),
      borderRadius: .circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: .circular(12.r),
        ),
        child: Stack(
          children: [
            Container(
              padding: .all(12.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: .circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.greyC0,
                  width: 1.sp,
                ),
              ),
              child: RowWidget(
                mainAxisAlignment: .start,
                crossAxisAlignment: .stretch,
                maxHeight: 32.h,
                gap: 12.w,
                children: [
                  Avatar(avatar: customer.avatar, size: 28.w),
                  Expanded(
                    child: ColumnWidget(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .center,
                      gap: 4.h,
                      children: [
                        Text(
                          customer.displayName,
                          style: AppStyles.text.semiBold(
                            fSize: 15.sp,
                            color: AppColors.black3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (customer.phone != null &&
                            customer.phone!.isNotEmpty)
                          Text(
                            customer.phone!,
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ColumnWidget(
                    crossAxisAlignment: .end,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '${customer.totalOrder.removeTrailingZero} đơn',
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          color: AppColors.black3,
                        ),
                      ),
                      Text(
                        customer.totalSpending.toUSD,
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
