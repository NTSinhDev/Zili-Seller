part of 'brands_screen.dart';

class _PackingSlipList extends StatefulWidget {
  final int crTab;
  final String? keyword;
  final DateTime? startDate;
  final DateTime? endDate;
  const _PackingSlipList(this.crTab, this.keyword, this.startDate, this.endDate);

  static const int tagOwner = 1;

  @override
  State<_PackingSlipList> createState() => _PackingSlipListState();
}

class _PackingSlipListState extends State<_PackingSlipList> {
  bool get _visible => widget.crTab == _PackingSlipList.tagOwner;
  PackingSlipStatus _crStatus = .newRequest;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !_visible,
      child: ColumnWidget(
        backgroundColor: AppColors.white,
        margin: .only(top: 16.h),
        mainAxisSize: .min,
        children: [
          Container(
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Danh sách phiếu',
                  style: AppStyles.text.bold(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
                SizedBox(height: 10.h),
                _PackingStatusTabs(
                  current: _crStatus,
                  onChanged: (status) => setState(() => _crStatus = status),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              fit: .expand,
              children: [
                _SlipListView(
                  _crStatus == .newRequest,
                  .newRequest,
                  widget.keyword,
                  widget.startDate,
                  widget.endDate,
                ),
                _SlipListView(
                  _crStatus == .processing,
                  .processing,
                  widget.keyword,
                  widget.startDate,
                  widget.endDate,
                ),
                _SlipListView(
                  _crStatus == .completed,
                  .completed,
                  widget.keyword,
                  widget.startDate,
                  widget.endDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlipListView extends StatefulWidget {
  final bool visible;
  final PackingSlipStatus status;
  final String? keyword;
  final DateTime? startDate;
  final DateTime? endDate;
  const _SlipListView(this.visible, this.status, this.keyword, this.startDate, this.endDate);

  @override
  State<_SlipListView> createState() => _SlipListViewState();
}

class _SlipListViewState extends State<_SlipListView> {
  late Stream<List<PackingSlip>> _streamingData;
  late List<PackingSlip> _currentList;
  late int _totalCount;
  // ------------------------------------------------------------------------
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();
  final WarehouseCubit _cubit = di<WarehouseCubit>();
  bool _isLoadMore = false;
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      _streamingData = getStreamingData();
      _currentList = getCurrentList();
      _totalCount = getTotalCount();
      _fetchDataScreen();
      _setupFCMListener();
    } else {
      _streamingData = const Stream.empty();
      _currentList = [];
      _totalCount = 0;
    }
  }

  /// Thiết lập listener cho FCM notifications
  ///
  /// tự động refresh data từ API nếu status hiện tại là `newRequest`
  void _setupFCMListener() {
    _fcmSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      final fcmType = message.data["type"] != null
          ? FirebaseMessagingType.tryParse(message.data["type"] as String?)
          : null;
      final status = packingSlipStatusByFCMType(fcmType);
      if (status == null) return;
      if (status == widget.status) {
        _onRefresh();
      } else {
        _cubit.filterPackings(
          limit: 20,
          offset: 0,
          isLoadMore: false,
          status: status,
          createdAtFrom: widget.startDate,
          createdAtTo: widget.endDate,
        );
      }
    });
  }

  @override
  void dispose() {
    _fcmSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _SlipListView oldWidget) {
    if (widget.visible) {
      _streamingData = getStreamingData();
      _currentList = getCurrentList();
      _totalCount = getTotalCount();
      if (oldWidget.keyword != widget.keyword ||
          oldWidget.startDate != widget.startDate ||
          oldWidget.endDate != widget.endDate) {
        _cubit
            .filterPackings(
              event: BaseEvent.search,
              limit: 20,
              offset: 0,
              keyword: widget.keyword,
              isLoadMore: false,
              status: widget.status,
              createdAtFrom: widget.startDate,
              createdAtTo: widget.endDate,
            )
            .then((value) {
              _totalCount = getTotalCount();
              _currentList = getCurrentList();
            });
      } else {
        _fetchDataScreen();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _fetchDataScreen() async {
    if (_currentList.isEmpty) {
      await _cubit
          .filterPackings(
            limit: 20,
            offset: 0,
            keyword: widget.keyword,
            isLoadMore: false,
            status: widget.status,
            event: BaseEvent.fetch,
            createdAtFrom: widget.startDate,
            createdAtTo: widget.endDate,
          )
          .then((value) {
            _totalCount = getTotalCount();
            _currentList = getCurrentList();
          });
    }
  }

  Stream<List<PackingSlip>> getStreamingData() {
    switch (widget.status) {
      case .newRequest:
        return _warehouseRepository.newPackingsStream;
      case .processing:
        return _warehouseRepository.processingPackingsStream;
      case .completed:
        return _warehouseRepository.completedPackingsStream;
      default:
        return const Stream.empty();
    }
  }

  List<PackingSlip> getCurrentList() {
    switch (widget.status) {
      case .newRequest:
        return _warehouseRepository.newPackings;
      case .processing:
        return _warehouseRepository.processingPackings;
      case .completed:
        return _warehouseRepository.completedPackings;
      default:
        return [];
    }
  }

  int getTotalCount() {
    switch (widget.status) {
      case .newRequest:
        return _warehouseRepository.totalNewPackings;
      case .processing:
        return _warehouseRepository.totalProcessingPackings;
      case .completed:
        return _warehouseRepository.totalCompletedPackings;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !widget.visible,
      child: Column(
        children: [
          BlocBuilder<WarehouseCubit, WarehouseState>(
            bloc: _cubit,
            builder: (context, state) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child:
                    state is WarehouseLoading && state.event == BaseEvent.search
                    ? const ShimmerView(
                        backgroundColor: AppColors.white,
                        type: ShimmerType.onlyLoadingIndicator,
                        key: ValueKey('loading'),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<PackingSlip>>(
              stream: _streamingData,
              initialData: _currentList,
              builder: (context, snapshot) {
                // Loading view
                if (snapshot.connectionState == .waiting) {
                  return const ShimmerView(type: .loadingIndicatorAtHead);
                }

                // Empty view
                if (snapshot.hasData && (snapshot.data ?? []).isEmpty) {
                  return const EmptyViewState(
                    message: 'Không tìm thấy phiếu đóng gói',
                  );
                }

                final items = snapshot.data ?? [];
                return Container(
                  color: Colors.white,
                  child: CommonLoadMoreRefreshWrapper(
                    onRefresh: _onRefresh,
                    onLoadMore: _onLoadMore,
                    minusMaxScrollValue: 100.h,
                    child: ListView.separated(
                      padding: .only(top: 8.h),
                      itemCount: items.length + 1,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          if (items.length < _totalCount) {
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
                                'Đã hiển thị tất cả phiếu đóng gói',
                                style: AppStyles.text.medium(
                                  fSize: 14.sp,
                                  color: AppColors.grey84,
                                ),
                              ),
                            ),
                          );
                        }

                        final slip = items[index];
                        return SlipCard(
                          slip: slip
                            ..statusLabel = packingSlipStatusLabel(
                              slip.statusEnum,
                            )
                            ..statusLabelColor = packingSlipStatusColor(
                              slip.statusEnum,
                            )
                            ..cardColor = packingSlipStatusColor(
                              slip.statusEnum,
                            )
                            ..infoRows = slip.infoRows,
                          onTap: () => context.navigator
                              .pushNamed(
                                PackingSlipDetailsScreen.routeName,
                                arguments: slip.code,
                              )
                              .then((isUpdateSlipData) {
                                if (context.mounted) {
                                  context.focus.unfocus();
                                }
                                if (isUpdateSlipData == true) {
                                  _cubit
                                      .filterPackings(
                                        event: BaseEvent.search,
                                        limit: 20,
                                        offset: 0,
                                        keyword: widget.keyword,
                                        isLoadMore: false,
                                        status: widget.status,
                                        createdAtFrom: widget.startDate,
                                        createdAtTo: widget.endDate,
                                      )
                                      .then((value) {
                                        _totalCount = getTotalCount();
                                        _currentList = getCurrentList();
                                      });
                                }
                              }),
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
    await _cubit.filterPackings(
      limit: 20,
      offset: 0,
      keyword: widget.keyword,
      isLoadMore: false,
      status: widget.status,
      createdAtFrom: widget.startDate,
      createdAtTo: widget.endDate,
    );
    await Future.delayed(Durations.medium4);
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final current = getCurrentList();
    final total = getTotalCount();
    if (current.length >= total) return true;
    _isLoadMore = true;
    final future = _cubit.filterPackings(
      limit: 20,
      offset: current.length,
      keyword: widget.keyword,
      isLoadMore: true,
      status: widget.status,
      createdAtFrom: widget.startDate,
      createdAtTo: widget.endDate,
    );
    future.whenComplete(() {
      _isLoadMore = false;
    });
    return true;
  }
}

class _PackingStatusTabs extends StatelessWidget {
  final PackingSlipStatus current;
  final ValueChanged<PackingSlipStatus> onChanged;
  const _PackingStatusTabs({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final labels = <PackingSlipStatus>[.newRequest, .processing, .completed];
    return StreamBuilder<int>(
      stream: di<WarehouseRepository>().newPackingSlipsCounter.stream,
      builder: (context, asyncSnapshot) {
        final count = asyncSnapshot.data ?? 0;
        return RowWidget(
          mainAxisAlignment: .start,
          gap: 16.w,
          children: List.generate(labels.length, (index) {
            final isSelected = current == labels[index];
            final Color color = isSelected
                ? AppColors.primary
                : AppColors.black3;
            return InkWell(
              onTap: () => onChanged(labels[index]),
              child: Container(
                padding: .symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2.w,
                    ),
                  ),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: packingSlipStatusLabel(labels[index]),
                        style: AppStyles.text
                            .medium(fSize: 12.sp, color: color)
                            .copyWith(fontWeight: isSelected ? .w600 : .w500),
                      ),
                      if (labels[index] == .newRequest && count > 0)
                        TextSpan(
                          text: ' (${count < 100 ? count : '99+'})',
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.scarlet,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
