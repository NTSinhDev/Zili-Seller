import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/base_cubit.dart';
import '../../../bloc/product/product_cubit.dart';
import '../../../data/models/product/company_product.dart';
import '../../../data/models/product/product.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/base_filter_view.dart';
import '../../common/company_product_card.dart';
import '../../common/list_screen_template.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductRepository _productRepository = di<ProductRepository>();
  final ProductCubit _productCubit = di<ProductCubit>();

  final int _selectedTab = 0; // 0: Tất cả, 1: Đang giao dịch
  String? _currentKeyword;
  String? _statusString;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOption? _timeOption;

  @override
  void initState() {
    super.initState();
    _fetchDataScreen();
  }

  Future<void> _fetchDataScreen() async {
    await _productCubit.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      bloc: _productCubit,
      builder: (context, state) {
        return ListScreenTemplate<CompanyProduct>(
          useScaffold: false,
          appBarTitle: 'Quản lý sản phẩm',
          searchHint: 'Tìm kiếm theo tên, mã, barcode...',
          initialTabIndex: _selectedTab,
          dataStream: _productRepository.companyProductsStream,
          totalCount: _productRepository.totalCompanyProducts,
          emptyMessage: 'Không tìm thấy sản phẩm nào',
          separatorBuilder: (context, index) =>
              index == 0 ? const SizedBox.shrink() : SizedBox(height: 4.h),
          itemBuilder: (context, item, index) => CompanyProductCard(data: item),
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
              _productCubit.getProducts(
                keyword: _currentKeyword,
                event: BaseEvent.search.name,
                status: _statusString,
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
            _productCubit.getProducts(
              keyword: _currentKeyword,
              event: BaseEvent.search.name,
            );
          },
          onRefresh: () async {
            _productCubit.getProducts(
              keyword: _currentKeyword,
              event: BaseEvent.search.name,
            );
          },
          loadMoreFunc: () {
            final products =
                _productRepository.productsByCompanySubject.valueOrNull ?? [];
            if (products.isNotEmpty) {
              final records = products.length;
              final maxRecords = _productRepository.totalCompanyProducts;
              if (maxRecords == records) return null;

              return _productCubit.loadMoreProducts(
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
