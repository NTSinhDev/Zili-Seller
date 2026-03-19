part of 'green_beans_screen.dart';

class _GreenBeanList extends StatefulWidget {
  final int crTab;
  final String? keyword;
  final DateTime? startDate;
  final DateTime? endDate;
  const _GreenBeanList(this.crTab, this.keyword, this.startDate, this.endDate);

  static const int tagOwner = 0;

  static final WarehouseCubit cubit = di<WarehouseCubit>();

  @override
  State<_GreenBeanList> createState() => _GreenBeanListState();
}

class _GreenBeanListState extends State<_GreenBeanList> {
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    if (_visible) {
      final list = _warehouseRepository.greenBeans;
      if (list.isEmpty) {
        _fetchDataScreen();
      }
    }
  }

  @override
  void didUpdateWidget(covariant _GreenBeanList oldWidget) {
    if (_visible) {
      final list = _warehouseRepository.greenBeans;
      if (widget.keyword != oldWidget.keyword ||
          widget.startDate != oldWidget.startDate ||
          widget.endDate != oldWidget.endDate) {
        _fetchDataScreen(BaseEvent.search);
      } else if (list.isEmpty) {
        _fetchDataScreen();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _fetchDataScreen([BaseEvent? event]) async {
    await _GreenBeanList.cubit.filterGreenBeans(
      limit: 20,
      offset: 0,
      keyword: widget.keyword,
      isLoadMore: false,
      createdAtFrom: widget.startDate,
      createdAtTo: widget.endDate,
      event: event,
    );
  }

  bool get _visible => widget.crTab == _GreenBeanList.tagOwner;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !_visible,
      child: ColumnWidget(
        mainAxisSize: .min,
        children: [
          BlocBuilder<WarehouseCubit, WarehouseState>(
            bloc: _GreenBeanList.cubit,
            builder: (context, state) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child:
                    state is WarehouseLoading && state.event == BaseEvent.search
                    ? const ShimmerView(
                        type: ShimmerType.onlyLoadingIndicator,
                        key: ValueKey('loading'),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<ProductVariant>>(
              stream: _warehouseRepository.greenBeansStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == .waiting) {
                  return const ShimmerView(type: .loadingIndicatorAtHead);
                }

                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const EmptyViewState(
                    message: 'Không tìm thấy phiên bản nhân xanh',
                  );
                }

                return CommonLoadMoreRefreshWrapper(
                  onRefresh: _onRefresh,
                  onLoadMore: _onLoadMore,
                  minusMaxScrollValue: 100.h,
                  child: Scrollbar(
                    controller: _scrollController,
                    radius: .circular(4.r),
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: items.length + 2,
                      separatorBuilder: (_, _) =>
                          Container(height: 12.h, color: AppColors.white),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            padding: .symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            color: AppColors.background,
                            child: Align(
                              alignment: .centerLeft,
                              child: Text(
                                '${_warehouseRepository.totalGreenBeans} phiên bản nhân xanh',
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
                          final total = _warehouseRepository.totalGreenBeans;
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
                                'Đã hiển thị tất cả nhân xanh',
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
                            extraRows: extraRows,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await _GreenBeanList.cubit.filterGreenBeans(
      limit: 20,
      offset: 0,
      keyword: widget.keyword,
      isLoadMore: false,
      createdAtFrom: widget.startDate,
      createdAtTo: widget.endDate,
    );
    await Future.delayed(Durations.medium4);
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final current = _warehouseRepository.greenBeans;
    final total = _warehouseRepository.totalGreenBeans;
    if (current.length >= total) return true;
    _isLoadMore = true;
    final future = _GreenBeanList.cubit.filterGreenBeans(
      limit: 20,
      offset: current.length,
      keyword: widget.keyword,
      isLoadMore: true,
      createdAtFrom: widget.startDate,
      createdAtTo: widget.endDate,
    );
    future.whenComplete(() {
      _isLoadMore = false;
    });
    return true;
  }
}
