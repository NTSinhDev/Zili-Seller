import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zili_coffee/app/app_wireframe.dart';
import 'package:zili_coffee/bloc/order/order_cubit.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/views/order/create_order/components/product_search_bar.dart';
import 'package:easy_debounce/easy_debounce.dart';

import '../../../utils/functions/order_function.dart';

part 'components/order_list_item.dart';
part 'components/order_filter_tabs.dart';
part 'components/order_empty_state.dart';

class OrderListScreen extends StatefulWidget {
  final bool hideFAB;
  const OrderListScreen({super.key, this.hideFAB = false});

  static String keyName = '/order-list';

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final OrderRepository _orderRepository = di<OrderRepository>();
  final OrderCubit _orderCubit = di<OrderCubit>();

  int _selectedTab = 0; // 0: Tất cả, 1: Đang giao dịch
  String? _currentKeyword;
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    _orderCubit.getSellerOrders(keyword: null, event: "");
  }

  void _onSearchChanged() {
    EasyDebounce.cancel('orderSearch');
    EasyDebounce.debounce('orderSearch', const Duration(milliseconds: 500), () {
      final keyword = _searchController.text.trim();
      if (keyword != _currentKeyword) {
        setState(() {
          _currentKeyword = keyword.isEmpty ? null : keyword;
        });
        _orderCubit.getSellerOrders(
          keyword: keyword.isEmpty ? null : keyword,
          event: "search",
        );
      }
    });
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await _orderCubit.getSellerOrders(
      keyword: _currentKeyword,
      event: "refresh",
    );
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final orders = _orderRepository.sellerOrders.valueOrNull;
    if (orders != null) {
      final records = orders.length;
      final maxRecords = _orderRepository.totalSellerOrders;
      if (maxRecords == records) return true;
    }
    _isLoadMore = true;
    if (mounted) setState(() {});
    _orderCubit.loadMoreSellerOrders(keyword: _currentKeyword).then((_) {
      _isLoadMore = false;
      if (mounted) setState(() {});
    });
    return true;
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTab = index;
    });
    // Reload với filter theo tab
    _orderCubit.getSellerOrders(keyword: _currentKeyword, event: "");
  }

  void _showFilterOptions() {
    // TODO: Show filter bottom sheet
    log('Show filter options');
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 80.h,
          margin: .only(bottom: 12.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: .circular(12.r),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      bloc: _orderCubit,
      listener: (context, state) {
        if (state is OrderErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error?.toString() ?? 'Có lỗi xảy ra'),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Đơn hàng',
          elevation: 1,
          shadowColor: AppColors.black.withOpacity(0.5),
          actions: [
            IconButton(
              icon: Icon(Icons.grid_view, color: AppColors.black3),
              onPressed: () {
                // TODO: Toggle grid/list view
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: AppColors.black3),
              onPressed: () {
                // TODO: Show menu
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            CommonSearchBar(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              controller: _searchController,
              hintSearch: 'Nhập tên, số điện thoại, mã',
              onScanBarcode: () {
                // TODO: Open QR scanner
              },
            ),
            // Filter Tabs
            _OrderFilterTabs(
              selectedTab: _selectedTab,
              onTabChanged: _onTabChanged,
              onFilterPressed: _showFilterOptions,
              totalOrders: _orderRepository.totalSellerOrders,
            ),
            // Order List
            Expanded(
              child: Container(
                color: AppColors.white,
                child: StreamBuilder<List<Order>>(
                  stream: _orderRepository.sellerOrdersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmer();
                    }

                    if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.flickr(
                              leftDotColor: const Color(0xFF005C9D),
                              rightDotColor: const Color(0xFFE54925),
                              size: 48.w,
                            ),
                            SizedBox(height: 16.h),
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

                    final orders = snapshot.data ?? [];
                    // Empty state
                    if (orders.isEmpty) {
                      return _OrderEmptyState(
                        onCreateOrder: () => AppWireFrame.navigateToOrderCreation(context),
                      );
                    }

                    // Order list
                    return CommonLoadMoreRefreshWrapper(
                      onRefresh: _onRefresh,
                      onLoadMore: _onLoadMore,
                      minusMaxScrollValue: 100.h,
                      child: ListView.separated(
                        itemCount: orders.length + 2,
                        separatorBuilder: (context, index) =>
                            index == orders.length + 1 || index == 0
                            ? const SizedBox.shrink()
                            : Divider(color: AppColors.greyC0, height: 1.h),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              color: AppColors.background,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${_orderRepository.totalSellerOrders} đơn hàng',
                                  style: AppStyles.text.medium(
                                    fSize: 14.sp,
                                    color: AppColors.grey84,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (index == orders.length + 1) {
                            if (index < _orderRepository.totalSellerOrders) {
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
                                  'Đã hiển thị tất cả đơn hàng',
                                  style: AppStyles.text.medium(
                                    fSize: 14.sp,
                                    color: AppColors.grey84,
                                  ),
                                ),
                              ),
                            );
                          }
                          final order = orders[index - 1];
                          return _OrderListItem(order: order);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: widget.hideFAB
            ? null
            : FloatingActionButton(
                onPressed: () => AppWireFrame.navigateToOrderCreation(context),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: AppColors.white),
              ),
      ),
    );
  }
}
