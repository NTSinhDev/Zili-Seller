import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';

import '../../../bloc/order/order_cubit.dart';
import '../../../bloc/product/product_cubit.dart';
import '../../../data/models/product/purchase_order_product.dart';
import '../../../data/models/product/product_variant.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/functions/order_function.dart';
import '../../../utils/extension/extension.dart';

import '../../../utils/widgets/widgets.dart';
import '../../common/common_search_bar.dart';

part 'components/product_list_item.dart';

class SelectMaterialsScreen extends StatefulWidget {
  static String routeName = '/select-materials';
  const SelectMaterialsScreen({super.key});

  @override
  State<SelectMaterialsScreen> createState() => _SelectMaterialsScreenState();
}

class _SelectMaterialsScreenState extends State<SelectMaterialsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductRepository _prodRepository = di<ProductRepository>();
  final ProductCubit _prodCubit = di<ProductCubit>();
  bool _isLoadMore = false;
  String? _currentKeyword;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  void _loadInitialData() {
    _prodCubit.filterMaterialVariants();
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
          _prodCubit.filterMaterialVariants(
            keyword: keyword.isEmpty ? null : keyword,
          );
        }
      },
    );
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    // Refresh - không phải initial load, nhưng cũng không phải search
    // Có thể show loading khi refresh vì user đã pull down
    await _prodCubit.filterMaterialVariants(keyword: _currentKeyword);
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final variants =
        _prodRepository.purchaseOrderProductSubject.valueOrNull?.items ?? [];
    if (_prodRepository.purchaseOrderProductSubject.hasValue) {
      final records = variants.length;
      final maxRecords =
          _prodRepository.purchaseOrderProductSubject.valueOrNull?.total ?? 0;
      if (maxRecords == records) return true;
    }
    _isLoadMore = true;
    if (mounted) setState(() {});
    _prodCubit
        .loadMoreMaterialVariants(
          keyword: _currentKeyword,
          offset: variants.length,
        )
        .then((_) {
          _isLoadMore = false;
          if (mounted) setState(() {});
        });
    return true;
  }

  Widget _pageListener(BuildContext context, {required Widget child}) {
    return BlocListener<ProductCubit, ProductState>(
      bloc: _prodCubit,
      listener: (context, state) {
        // // Initial load: show modal loading (user chưa nhập)
        // // Search: không show modal loading, dùng inline indicator (không ẩn keyboard)
        // if (state is OrderLoadingState &&
        //     state.event != "loadMore" &&
        //     state.event != "search") {
        //   context.showLoading();
        // } else if (state is OrderLoadedState) {
        //   context.hideLoading();
        // } else if (state is OrderErrorState) {
        //   context.hideLoading();
        //   context.showNotificationDialog(
        //     message: "Lỗi khi tải danh sách sản phẩm",
        //     action: 'Đóng',
        //   );
        // }
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
          label: 'Chọn nguyên liệu',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
        ),
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            CommonSearchBar(
              leadingWrapper: (context, child, loadingState) {
                return BlocBuilder<ProductCubit, ProductState>(
                  bloc: _prodCubit,
                  builder: (context, state) {
                    final isSearching =
                        state
                            is OrderLoadingState /* && state.event == "search" */;
                    return isSearching ? loadingState : child;
                  },
                );
              },
              controller: _searchController,
              hintSearch: 'Tìm sản phẩm theo tên, mã SKU,...',
            ),
            Expanded(
              child: CommonLoadMoreRefreshWrapper(
                onRefresh: _onRefresh,
                onLoadMore: _onLoadMore,
                minusMaxScrollValue: 100.h,
                child: BlocBuilder<ProductCubit, ProductState>(
                  bloc: _prodCubit,
                  builder: (context, cubitState) {
                    final isSearching =
                        cubitState
                            is OrderLoadingState /* &&
                        cubitState.event == "search" */;

                    return StreamBuilder<PurchaseOrderProductsResult>(
                      stream:
                          _prodRepository.purchaseOrderProductSubject.stream,
                      builder: (context, snapshot) {
                        // Initial load state - show shimmer
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !isSearching) {
                          return _buildProductShimmer();
                        }

                        // Search loading state - show inline loading indicator
                        if (isSearching &&
                            snapshot.hasData &&
                            snapshot.data!.items.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: .center,
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
                          final purchaseOrderProductsResult = snapshot.data!;
                          final totalResults =
                              _prodRepository
                                  .purchaseOrderProductSubject
                                  .valueOrNull
                                  ?.total ??
                              0;

                          if (purchaseOrderProductsResult.items.isEmpty) {
                            return _buildEmptyState();
                          }

                          return ListView.builder(
                            padding: .symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            itemCount:
                                purchaseOrderProductsResult.items.length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  purchaseOrderProductsResult.items.length) {
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
                              return _ProductListItem(
                                purchaseOrderProductsResult.items[index],
                                _prodRepository,
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
        bottomNavigationBar: Container(
          padding: .symmetric(horizontal: 20.w, vertical: 12.h),
          color: Colors.white,
          child: RowWidget(
            gap: 20.w,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final selectedProductVariant =
                        _prodRepository.materialVariants.valueOrNull ?? [];
                    context.navigator.pop(selectedProductVariant);
                  },
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
      ),
    );
  }

  Widget _buildProductShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 100.h,
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
