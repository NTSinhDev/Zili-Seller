
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zili_coffee/bloc/customer/customer_cubit.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:easy_debounce/easy_debounce.dart';

import '../../../app/app_wireframe.dart';
import '../../../data/dto/customer/filter_customers_input.dart';
import '../../../data/models/user/customer.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../common/action_app_bar.dart';
import '../../common/common_search_bar.dart';

part 'components/customer_list_item.dart';

class SelectCustomersScreen extends StatefulWidget {
  final Customer? currentSelected;
  const SelectCustomersScreen({super.key, this.currentSelected});

  static String keyName = '/select-customers';

  @override
  State<SelectCustomersScreen> createState() => _SelectCustomersScreenState();
}

class _SelectCustomersScreenState extends State<SelectCustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  final CustomerCubit _customerCubit = di<CustomerCubit>();

  bool _isLoadMore = false;
  final FilterCustomersInput _filterCustomersInput = FilterCustomersInput();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filterCustomersInput.keyword = _searchController.text.trim();
    // Initial load - show loading
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
            type: CustomSnackBarType.error,
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
                child: BlocBuilder<CustomerCubit, CustomerState>(
                  bloc: _customerCubit,
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
                          return _buildCustomerShimmer();
                        }

                        // Search loading state - show inline loading indicator
                        if (isSearching &&
                            snapshot.hasData &&
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LoadingAnimationWidget.flickr(
                                  leftDotColor: const Color(0xFF005C9D),
                                  rightDotColor: const Color(0xFFE54925),
                                  size: 48.w,
                                ),
                                height(height: 16),
                                Text(
                                  'Đang tìm kiếm...',
                                  style: AppStyles.text.medium(
                                    fSize: 14.sp,
                                    color: AppColors.grey84,
                                  ),
                                ),
                              ],
                            ),
                          );
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
                                  return Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Center(
                                      child: LoadingAnimationWidget.flickr(
                                        leftDotColor: const Color(0xFF005C9D),
                                        rightDotColor: const Color(0xFFE54925),
                                        size: 36.w,
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.all(20.w),
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
                                margin: EdgeInsets.only(bottom: 12.w),
                                child: _CustomerListItem(
                                  customer: customers[index],
                                  isSelected:
                                      widget.currentSelected?.id ==
                                      customers[index].id,
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

  Widget _buildCustomerShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 56.h,
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(8.r),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return ColumnWidget(
      mainAxisAlignment: MainAxisAlignment.center,
      margin: EdgeInsets.only(bottom: 0.2.sh),
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
