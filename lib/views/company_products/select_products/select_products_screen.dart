import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:easy_debounce/easy_debounce.dart';

import '../../../bloc/order/order_cubit.dart';
import '../../../utils/enums/product_enum.dart';
import '../../../utils/functions/order_function.dart';
import '../../../utils/functions/warehouse_functions.dart';
import '../../common/common_search_bar.dart';
import '../../common/list_screen_template.dart';
import '../../common/shimmer_view.dart';

part 'components/item_view.dart';

class SelectProductsScreen extends StatefulWidget {
  final String? branchId;
  const SelectProductsScreen({super.key, this.branchId});

  static String keyName = '/select-products';

  @override
  State<SelectProductsScreen> createState() => _SelectProductsScreenState();
}

class _SelectProductsScreenState extends State<SelectProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final OrderRepository _orderRepository = di<OrderRepository>();
  final OrderCubit _orderCubit = di<OrderCubit>();
  ProductVariantCategoryCode _selectedTab = ProductVariantCategoryCode.all;
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);
  List<ProductVariant> _temps = [];

  bool _isLoadMore = false;
  String? _currentKeyword;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  void _loadInitialData() {
    _orderCubit.getProductVariants(
      keyword: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      branchId: widget.branchId,
      categoryCode: _selectedTab,
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
    EasyDebounce.cancel('productSearch');
    EasyDebounce.debounce(
      'productSearch',
      const Duration(milliseconds: 500),
      () {
        final keyword = _searchController.text.trim();
        if (keyword != _currentKeyword) {
          setState(() {
            _currentKeyword = keyword.isEmpty ? null : keyword;
          });
          // Search - không show loading để tránh ẩn keyboard
          _orderCubit.getProductVariants(
            keyword: keyword.isEmpty ? null : keyword,
            branchId: widget.branchId,
            categoryCode: _selectedTab,
            isInitialLoad: false, // Search không phải initial load
          );
        }
      },
    );
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    // Refresh - không phải initial load, nhưng cũng không phải search
    // Có thể show loading khi refresh vì user đã pull down
    await _orderCubit.getProductVariants(
      keyword: _currentKeyword,
      branchId: widget.branchId,
      categoryCode: _selectedTab,
      isInitialLoad: true, // Refresh không phải initial load
    );
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final variants = _orderRepository.productVariants.value;
    if (_orderRepository.productVariants.hasValue) {
      final records = variants.length;
      final maxRecords = _orderRepository.productVariantsTotal;
      if (maxRecords == records) return true;
    }
    _isLoadMore = true;
    if (mounted) setState(() {});
    _orderCubit
        .loadMoreProductVariants(
          keyword: _currentKeyword,
          branchId: widget.branchId,
          offset: variants.length,
          categoryCode: _selectedTab,
        )
        .then((_) {
          _isLoadMore = false;
          if (mounted) setState(() {});
        });
    return true;
  }

  Widget _pageListener(BuildContext context, {required Widget child}) {
    return BlocListener<OrderCubit, OrderState>(
      bloc: _orderCubit,
      listener: (context, state) {
        // Initial load: show modal loading (user chưa nhập)
        // Search: không show modal loading, dùng inline indicator (không ẩn keyboard)
        if (state is OrderLoadingState &&
            state.event != "loadMore" &&
            state.event != "search") {
          context.showLoading();
        } else if (state is OrderLoadedState) {
          context.hideLoading();
        } else if (state is OrderErrorState) {
          context.hideLoading();
          final snackNotification = CustomSnackBarWidget(
            context,
            type: .error,
            message: "Lỗi khi tải danh sách sản phẩm",
          );
          snackNotification.show();
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
          label: 'Chọn sản phẩm',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
          bottom: BaseFilterTabs(
            tabs: ProductVariantCategoryCode.values
                .map((e) {
                  final label = renderProductVariantCategoryCode(e);
                  if (label.isNotNull) {
                    return TabConfig(label: label!, value: e);
                  }
                  return null;
                })
                .nonNulls
                .toList(),
            selectedTab: _selectedTab.index,
            onTabChanged: (index, value) {
              if (value != _selectedTab &&
                  value is ProductVariantCategoryCode) {
                _orderCubit.getProductVariants(
                  keyword: _searchController.text.trim().isEmpty
                      ? null
                      : _searchController.text.trim(),
                  branchId: widget.branchId,
                  categoryCode: value,
                  isInitialLoad: true,
                );
                setState(() {
                  _selectedTab = value;
                });
              }
            },
            showFilterButton: false,
          ),
        ),
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            CommonSearchBar(
              leadingWrapper: (context, child, loadingState) {
                return BlocBuilder<OrderCubit, OrderState>(
                  bloc: _orderCubit,
                  builder: (context, state) {
                    final isSearching =
                        state is OrderLoadingState && state.event == "search";
                    return isSearching ? loadingState : child;
                  },
                );
              },
              focusNode: _searchFocusNode,
              controller: _searchController,
              hintSearch: 'Tìm sản phẩm theo tên, mã SKU,...',
            ),
            StreamBuilder<List<ProductVariant>>(
              initialData: _orderRepository.selectedProductVariants.valueOrNull,
              stream: _orderRepository.selectedProductVariants.stream,
              builder: (context, snapshot) {
                final selectedProductVariants = snapshot.data ?? [];
                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: selectedProductVariants.isEmpty
                      ? const SizedBox.shrink()
                      : ClipRect(
                          child: Container(
                            key: ValueKey(selectedProductVariants.length),
                            padding: .symmetric(horizontal: 20.w),
                            color: AppColors.background,
                            child: RowWidget(
                              gap: 8.w,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 18.sp,
                                ),
                                Expanded(
                                  child: Text(
                                    'Đã chọn ${selectedProductVariants.length} sản phẩm',
                                    style: AppStyles.text.semiBold(
                                      fSize: 12.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _orderRepository
                                      .selectedProductVariants
                                      .sink
                                      .add([]),
                                  child: Text(
                                    'Bỏ tất cả',
                                    style: AppStyles.text.semiBold(
                                      fSize: 13.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                );
              },
            ),
            Expanded(
              child: CommonLoadMoreRefreshWrapper(
                onRefresh: _onRefresh,
                onLoadMore: _onLoadMore,
                minusMaxScrollValue: 100.h,
                child: BlocBuilder<OrderCubit, OrderState>(
                  bloc: _orderCubit,
                  builder: (context, cubitState) {
                    final isSearching =
                        cubitState is OrderLoadingState &&
                        cubitState.event == "search";

                    return StreamBuilder<List<ProductVariant>>(
                      stream: _orderRepository.productVariantsStream,
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
                          return Center(
                            child: ColumnWidget(
                              mainAxisAlignment: .center,
                              gap: 16.h,
                              children: [
                                LoadingAnimationWidget.flickr(
                                  leftDotColor: const Color(0xFF005C9D),
                                  rightDotColor: const Color(0xFFE54925),
                                  size: 48.w,
                                ),
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
                          final variants = snapshot.data!;
                          final totalResults =
                              _orderRepository.productVariantsTotal;

                          if (variants.isEmpty) return _buildEmptyState();

                          return ListView.builder(
                            padding: .symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            itemCount: variants.length + 1,
                            itemBuilder: (context, index) {
                              if (index == variants.length) {
                                if (index < (totalResults - 1)) {
                                  return Padding(
                                    padding: .all(20.w),
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
                                  padding: .all(20.w),
                                  child: Center(
                                    child: Text(
                                      'Đã hiển thị tất cả sản phẩm',
                                      style: AppStyles.text.medium(
                                        fSize: 14.sp,
                                        color: AppColors.grey84,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return _ItemView(
                                variants[index],
                                temps: _temps,
                                setTemps: (temps) {
                                  setState(() {
                                    _temps = temps;
                                  });
                                },
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
        bottomNavigationBar: StreamBuilder<List<ProductVariant>>(
          stream: _orderRepository.selectedProductVariants.stream,
          builder: (context, snapshot) {
            final selectedProductVariants = snapshot.data ?? [];
            if (selectedProductVariants.isEmpty) return const SizedBox.shrink();
            return Container(
              padding: .symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.grayEA)),
              ),
              child: SafeArea(
                child: RowWidget(
                  gap: 20.w,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.grayEA),
                          padding: .symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          selectedProductVariants.removeWhere(
                            (element) =>
                                _temps.any((temp) => temp.id == element.id),
                          );
                          _orderRepository.selectedProductVariants.sink.add(
                            selectedProductVariants,
                          );
                          context.navigator.pop(selectedProductVariants);
                        },
                        child: Text(
                          'Hủy',
                          style: AppStyles.text.semiBold(
                            fSize: 14.sp,
                            color: AppColors.black3,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: .symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            context.navigator.pop(selectedProductVariants),
                        child: Text(
                          'Xác nhận',
                          style: AppStyles.text.semiBold(
                            fSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ColumnWidget(
      mainAxisAlignment: .center,
      gap: 16.h,
      children: [
        Icon(Icons.shopping_bag_outlined, size: 64.sp, color: AppColors.grey84),
        Text(
          _currentKeyword != null
              ? 'Không tìm thấy sản phẩm nào'
              : 'Chưa có sản phẩm nào được chọn',
          style: AppStyles.text.medium(fSize: 16.sp, color: AppColors.grey84),
        ),
        Text(
          _currentKeyword != null
              ? 'Thử tìm kiếm với từ khóa khác'
              : 'Tìm kiếm và chọn sản phẩm để thêm vào đơn hàng',
          style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey97),
          textAlign: .center,
        ),
      ],
    );
  }
}
