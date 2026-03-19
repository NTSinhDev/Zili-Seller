part of 'green_beans_screen.dart';

class _RoastingSlipList extends StatefulWidget {
  final int crTab;
  final String? keyword;
  final DateTime? startDate;
  final DateTime? endDate;
  const _RoastingSlipList(
    this.crTab,
    this.keyword,
    this.startDate,
    this.endDate,
  );

  static const int tagOwner = 1;

  @override
  State<_RoastingSlipList> createState() => _RoastingSlipListState();
}

class _RoastingSlipListState extends State<_RoastingSlipList> {
  bool get _visible => widget.crTab == _RoastingSlipList.tagOwner;
  RoastingSlipStatus _crStatus = .newRequest;

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
                _RoastingSlipTabs(
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
                  _crStatus == .roasting,
                  .roasting,
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
  final RoastingSlipStatus status;
  final String? keyword;
  final DateTime? startDate;
  final DateTime? endDate;
  const _SlipListView(
    this.visible,
    this.status,
    this.keyword,
    this.startDate,
    this.endDate,
  );

  @override
  State<_SlipListView> createState() => _SlipListViewState();
}

class _SlipListViewState extends State<_SlipListView> {
  late Stream<List<RoastingSlip>> _streamingData;
  late List<RoastingSlip> _currentList;
  late int _totalCount;
  // ------------------------------------------------------------------------
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();
  final WarehouseCubit _cubit = di<WarehouseCubit>();
  bool _isLoadMore = false;
  StreamSubscription<RemoteMessage>? _fcmSubscription;
  final ScrollController _scrollController = ScrollController();

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
      final status = roastingSlipStatusByFCMType(fcmType);
      if (status == null) return;
      if (status == widget.status) {
        _onRefresh();
      } else {
        _cubit.filterRoastingSlips(
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
    _scrollController.dispose();
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
            .filterRoastingSlips(
              limit: 20,
              offset: 0,
              keyword: widget.keyword,
              isLoadMore: false,
              status: widget.status,
              event: BaseEvent.search,
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
          .filterRoastingSlips(
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
  }

  Stream<List<RoastingSlip>> getStreamingData() {
    switch (widget.status) {
      case RoastingSlipStatus.newRequest:
        return _warehouseRepository.newRoastingSlipsStream;
      case RoastingSlipStatus.roasting:
        return _warehouseRepository.roastingSlipsStream;
      case RoastingSlipStatus.completed:
        return _warehouseRepository.completeRoastingSlipsStream;
      default:
        return const Stream.empty();
    }
  }

  List<RoastingSlip> getCurrentList() {
    switch (widget.status) {
      case RoastingSlipStatus.newRequest:
        return _warehouseRepository.newRoastingSlips;
      case RoastingSlipStatus.roasting:
        return _warehouseRepository.roastingSlips;
      case RoastingSlipStatus.completed:
        return _warehouseRepository.completeRoastingSlips;
      default:
        return [];
    }
  }

  int getTotalCount() {
    switch (widget.status) {
      case RoastingSlipStatus.newRequest:
        return _warehouseRepository.totalNewRoastingSlips;
      case RoastingSlipStatus.roasting:
        return _warehouseRepository.totalRoastingSlips;
      case RoastingSlipStatus.completed:
        return _warehouseRepository.totalCompeteRoastingSlips;
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
            child: StreamBuilder<List<RoastingSlip>>(
              stream: _streamingData,
              initialData: _currentList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == .waiting) {
                  return const ShimmerView(type: .loadingIndicatorAtHead);
                }

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có dữ liệu phiếu rang',
                      style: AppStyles.text.medium(
                        fSize: 14.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  );
                }

                final items = snapshot.data ?? [];

                return Container(
                  color: Colors.white,
                  child: CommonLoadMoreRefreshWrapper(
                    onRefresh: _onRefresh,
                    onLoadMore: _onLoadMore,
                    minusMaxScrollValue: 100.h,
                    child: Scrollbar(
                      controller: _scrollController,
                      radius: .circular(4.r),
                      child: ListView.separated(
                        controller: _scrollController,
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
                                  'Đã hiển thị tất cả phiếu rang',
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
                              ..statusLabel = roastingSlipStatusLabel(
                                slip.statusEnum,
                              )
                              ..statusLabelColor = roastingSlipStatusColor(
                                slip.statusEnum,
                              )
                              ..cardColor = roastingSlipStatusColor(
                                slip.statusEnum,
                              )
                              ..infoRows = slip.infoRows,
                            onTap: () => context.navigator.pushNamed(
                              RoastingSlipDetailScreen.routeName,
                              arguments: slip.code,
                            ),
                          );
                        },
                      ),
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
    await _cubit.filterRoastingSlips(
      limit: 20,
      offset: 0,
      keyword: widget.keyword,
      isLoadMore: false,
      status: widget.status,
      createdAtFrom: widget.startDate,
      createdAtTo: widget.endDate,
    );
    if (widget.status == .newRequest) {
      await _cubit.getTotalOfNewRequestSlip();
    }
    await Future.delayed(Durations.medium4);
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final current = getCurrentList();
    final total = getTotalCount();
    if (current.length >= total) return true;
    _isLoadMore = true;
    final future = _cubit.filterRoastingSlips(
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
