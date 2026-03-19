import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zili_coffee/views/common/shimmer_view.dart';

import '../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../data/models/product/product_variant.dart';
import '../../../data/repositories/warehouse_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../services/common_service.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/action_app_bar.dart';
import '../../common/common_search_bar.dart';
import '../../common/warehouse_product_card.dart';
import '../../loading/loading_screen.dart';
import '../roasting_slip/roasting_slip_create/roasting_slip_create_screen.dart';
import '../roasting_slip/roasting_slips_of_roasted_bean/roasting_slips_of_roasted_bean_screen.dart';

part 'components/filter_tabs.dart';
part 'components/roasting_slip_creation_button.dart';

class RoastedBeansScreen extends StatefulWidget {
  const RoastedBeansScreen({super.key});

  static const String routeName = '/roasted-beans';

  @override
  State<RoastedBeansScreen> createState() => _RoastedBeansScreenState();
}

class _RoastedBeansScreenState extends State<RoastedBeansScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WarehouseCubit _warehouseCubit = di<WarehouseCubit>();
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();
  bool _isLoadMore = false;
  String? _keyword;
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitial();
  }

  void _onSearchChanged() {
    EasyDebounce.debounce(
      'greenBeanSearch',
      const Duration(milliseconds: 400),
      () {
        _keyword = _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim();
        _loadInitial();
      },
    );
  }

  Future<void> _loadInitial() async {
    await _warehouseCubit.filterRoastedBeans(
      limit: 20,
      offset: 0,
      keyword: _keyword,
      isLoadMore: false,
    );
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await _loadInitial();
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final current = _warehouseRepository.roastedBeans;
    final total = _warehouseRepository.totalRoastedBeans;
    if (current.length >= total) return true;
    _isLoadMore = true;
    final future = _warehouseCubit.filterRoastedBeans(
      limit: 20,
      offset: current.length,
      keyword: _keyword,
      isLoadMore: _isLoadMore,
    );
    future.whenComplete(() {
      _isLoadMore = false;
    });
    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Hạt rang',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          CommonSearchBar(
            padding: .fromLTRB(20.w, 16.h, 20.w, 16.h),
            controller: _searchController,
            focusNode: _searchFocusNode,
            hintSearch: 'Tìm kiếm theo tên, mã sku,...',
          ),
          Expanded(
            child: StreamBuilder<List<ProductVariant>>(
              stream: _warehouseRepository.roastedBeansStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == .waiting) {
                  return const ShimmerView(
                    type: ShimmerType.loadingIndicatorAtHead,
                  );
                }

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có dữ liệu hạt rang',
                      style: AppStyles.text.medium(
                        fSize: 14.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  );
                }

                final items =
                    snapshot.data ?? _warehouseRepository.roastedBeans;
                return CommonLoadMoreRefreshWrapper(
                  onRefresh: _onRefresh,
                  onLoadMore: _onLoadMore,
                  minusMaxScrollValue: 100.h,
                  child: ListView.separated(
                    itemCount: items.length + 2,
                    separatorBuilder: (_, _) =>
                        Container(height: 12.h, color: AppColors.white),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                          color: AppColors.background,
                          child: Align(
                            alignment: .centerLeft,
                            child: Text(
                              '${_warehouseRepository.totalRoastedBeans} phiên bản hạt rang',
                              style: AppStyles.text.medium(
                                fSize: 14.sp,
                                color: AppColors.grey84,
                              ),
                            ),
                          ),
                        );
                      }

                      // Footer: loading more or end text
                      if (index == items.length + 1) {
                        final total = _warehouseRepository.totalRoastedBeans;
                        if (items.length < total) {
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
                              'Đã hiển thị tất cả hạt rang',
                              style: AppStyles.text.medium(
                                fSize: 14.sp,
                                color: AppColors.grey84,
                              ),
                            ),
                          ),
                        );
                      }

                      final variant = items[index - 1];
                      final delivered =
                          double.tryParse(variant.deliveryCount) ?? 0;
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
                        padding: .symmetric(horizontal: 16.w),
                        color: AppColors.white,
                        child: WarehouseProductCard(
                          variant: variant,
                          onTap: () => context.navigator.pushNamed(
                            RoastingSlipsOfRoastedBeanScreen.routeName,
                            arguments: variant,
                          ),
                          extraRows: extraRows,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
