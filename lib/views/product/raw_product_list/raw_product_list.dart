import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/app/app_wireframe.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';

import '../../../bloc/base_cubit.dart';
import '../../../bloc/product/product_cubit.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/base_filter_view.dart';
import '../../common/list_screen_template.dart';
import '../../common/warehouse_product_card.dart';

class RawProductList extends StatefulWidget {
  const RawProductList({super.key});

  @override
  State<RawProductList> createState() => _RawProductListState();
}

class _RawProductListState extends State<RawProductList> {
  final ProductRepository _productRepository = di<ProductRepository>();
  final ProductCubit _productCubit = di<ProductCubit>();

  int _selectedTab = 0;
  String? _currentKeyword;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOption? _timeOption;

  @override
  void initState() {
    super.initState();
    _fetchDataScreen();
  }

  Future<void> _fetchDataScreen([BaseEvent? event]) async {
    await _productCubit.getRawProducts(
      type: _selectedTab,
      event: event?.name,
      keyword: _currentKeyword,
      createdAtFrom: _startDate?.startOfDate(),
      createdAtTo: _endDate?.endOfDate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      bloc: _productCubit,
      builder: (context, state) {
        return ListScreenTemplate<ProductVariant>(
          useScaffold: false,
          searchHint: 'Tìm kiếm theo tên, mã, barcode...',
          dataStream: _productRepository.productsSubject,
          totalCount: _productRepository.totalProducts,
          emptyMessage: 'Không tìm thấy sản phẩm nào',
          initialTabIndex: _selectedTab,
          tabs: [
            TabConfig(label: "Nhân xanh", value: 0),
            TabConfig(label: "Hạt rang", value: 1),
            TabConfig(label: "Thương hiệu", value: 2),
          ],
          onTabChanged: (index, value) async {
            if (_selectedTab == index) return;
            _selectedTab = index;
            await _fetchDataScreen();
          },
          separatorBuilder: (context, index) =>
              index == 0 ? const SizedBox.shrink() : SizedBox(height: 12.h),
          itemBuilder: (context, variant, index) {
            final delivered = double.tryParse(variant.deliveryCount) ?? 0;
            final total = variant.inventory;
            final remaining =
                double.tryParse(variant.availableQuantity) ??
                (variant.inventory - delivered);
            final List<MapEntry<String, String>> extraRows = [
              MapEntry('Tổng:', total.toUSD),
              MapEntry('Xuất:', delivered.toUSD),
              MapEntry('Còn lại:', remaining.toUSD),
            ];
            return Container(
              padding: .symmetric(horizontal: 12.w),
              child: WarehouseProductCard(
                variant: variant,
                backgroundColor: AppColors.white,
                extraRows: extraRows,
                onTap: () {
                  if (variant.productId == null) return;
                  AppWireFrame.navigateToCompanyProductDetails(
                    context,
                    productId: variant.productId!,
                  );
                },
              ),
            );
          },
          headerWidget: Container(
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.background,
            child: Align(
              alignment: .centerLeft,
              child: Text(
                '${_productRepository.totalCompanyProducts} sản phẩm',
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
              _productCubit.getRawProducts(
                type: _selectedTab,
                keyword: _currentKeyword,
                event: BaseEvent.search.name,
                createdAtFrom: value.$1,
                createdAtTo: value.$2,
              );
            },
          ),
          // Loading states
          isInitialLoading: () =>
              state is ProductLoadingState &&
              (state.event == null || state.event == ""),
          isSearchLoading: () =>
              state is ProductLoadingState && state.event == "search",
          // Callbacks
          onSearch: (keyword) async {
            if (_currentKeyword == keyword) return;
            _currentKeyword = keyword;
            _fetchDataScreen(BaseEvent.search);
          },
          onRefresh: () async {
            _fetchDataScreen();
          },
          loadMoreFunc: () {
            final products =
                _productRepository.productsSubject.valueOrNull ?? [];
            if (products.isNotEmpty) {
              final records = products.length;
              final maxRecords = _productRepository.totalProducts;
              if (maxRecords == records) return null;

              return _productCubit.loadMoreRawProducts(
                type: _selectedTab,
                createdAtFrom: _startDate?.startOfDate(),
                createdAtTo: _endDate?.endOfDate(),
                offset: records,
                keyword: _currentKeyword,
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
