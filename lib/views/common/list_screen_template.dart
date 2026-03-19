import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';
import '../../utils/extension/extension.dart';
import '../../utils/widgets/widgets.dart';
import 'common_search_bar.dart';
import 'empty_view_state.dart';
import 'shimmer_view.dart';

/// Configuration cho một tab
class TabConfig {
  final String label;
  final dynamic value;
  final Stream<int>? badgeStream; // Stream cho badge counter (optional)
  final bool Function()? hasPermission; // Permission check (optional)

  const TabConfig({
    required this.label,
    this.value,
    this.badgeStream,
    this.hasPermission,
  });
}

typedef OnFilterApplied = void Function(dynamic value);

/// Configuration cho filter bottom sheet
class FilterConfig {
  final Widget Function(BuildContext context, Function(dynamic) onApply)
  builder;
  final OnFilterApplied? onFilterApplied;

  const FilterConfig({required this.builder, this.onFilterApplied});
}

/// Reusable List Screen Template theo pattern UI/UX chung
///
/// Xử lý tất cả UI/UX chung: AppBar, Search, Tabs, List với refresh/load more
/// Các phần cần trigger cụ thể được truyền vào qua callbacks
class ListScreenTemplate<T> extends StatefulWidget {
  /// AppBar configuration
  final String appBarTitle;
  final List<Widget>? appBarActions;

  /// Search configuration
  final String searchHint;
  final int searchDebounceMs; // Default: 400ms

  /// Tabs configuration (optional - nếu null thì không hiển thị tabs)
  final List<TabConfig>? tabs;
  final int initialTabIndex;
  final Function(int tabIndex, dynamic value)? onTabChanged;

  /// Filter configuration (optional)
  final FilterConfig? filterConfig;
  final bool showFilterButton; // Show filter button trong tabs

  /// List configuration
  final Stream<List<T>> dataStream;
  final int totalCount; // Total count để check load more
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? emptyWidget;
  final String emptyMessage;
  final Widget? headerWidget; // Optional header (ví dụ: total count)
  final Widget? footerWidget; // Optional footer (custom footer thay vì default)
  final Widget Function(BuildContext context, int index)?
  separatorBuilder; // Optional separator builder

  /// Loading state checker
  final bool Function()? isSearchLoading; // Check nếu đang search loading
  final bool Function()? isInitialLoading; // Check nếu đang initial loading

  /// Callbacks
  /// Callback khi search (keyword null nếu empty)
  final Function(String? keyword)? onSearch;
  final Future<void> Function() onRefresh;
  final Future<dynamic>? Function()?
  loadMoreFunc; // Return true nếu đang load hoặc đã load hết

  /// Search result label (optional)
  final bool showSearchResultLabel; // Show "Kết quả tìm kiếm:" label

  /// Scroll configuration
  final double minusMaxScrollValue; // Default: 100.h

  /// Scaffold configuration
  final bool useScaffold; // Default: true - wrap với Scaffold và AppBar
  final PreferredSizeWidget?
  customAppBar; // Optional AppBar nếu useScaffold = false

  const ListScreenTemplate({
    super.key,
    this.appBarTitle = '',
    this.appBarActions,
    required this.searchHint,
    this.searchDebounceMs = 450,
    this.tabs,
    this.initialTabIndex = 0,
    this.onTabChanged,
    this.filterConfig,
    this.showFilterButton = false,
    required this.dataStream,
    required this.totalCount,
    required this.itemBuilder,
    required this.emptyMessage,
    this.emptyWidget,
    this.headerWidget,
    this.footerWidget,
    this.separatorBuilder,
    this.isSearchLoading,
    this.isInitialLoading,
    this.onSearch,
    required this.onRefresh,
    this.loadMoreFunc,
    this.showSearchResultLabel = true,
    this.minusMaxScrollValue = 100,
    this.useScaffold = true,
    this.customAppBar,
  });

  @override
  State<ListScreenTemplate<T>> createState() => _ListScreenTemplateState<T>();
}

class _ListScreenTemplateState<T> extends State<ListScreenTemplate<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);
  late int _tabIndex;
  String? _currentKeyword;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant ListScreenTemplate<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTabIndex != _tabIndex) {
      _tabIndex = widget.initialTabIndex;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    EasyDebounce.debounce(
      'listScreenSearch',
      Duration(milliseconds: widget.searchDebounceMs),
      () {
        final text = _searchController.text.trim();
        if (text == _currentKeyword) return;
        _currentKeyword = text.isEmpty ? null : text;
        widget.onSearch?.call(_currentKeyword);
      },
    );
  }

  void _onTabChanged(int index, dynamic value) {
    context.focus.unfocus();
    setState(() {
      _tabIndex = index;
    });
    widget.onTabChanged?.call(index, value);
  }

  void _showFilterBottomSheet() {
    if (widget.filterConfig == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (childContext) {
        final bottomPadding = MediaQuery.of(childContext).viewPadding.bottom;
        final keyboardHeight = MediaQuery.of(childContext).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + keyboardHeight),
          child: widget.filterConfig!.builder(childContext, (dynamic value) {
            childContext.navigator.maybePop();
            widget.filterConfig?.onFilterApplied?.call(value);
          }),
        );
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Top
        if (widget.onSearch != null)
          RowWidget(
            padding: .fromLTRB(
              20.w,
              16.h,
              widget.showFilterButton && (widget.tabs ?? []).isEmpty
                  ? 8.w
                  : 20.w,
              widget.showFilterButton && (widget.tabs ?? []).isEmpty ? 20.h : 0,
            ),
            backgroundColor: Colors.white,
            gap: 8.w,
            children: [
              Expanded(
                child: CommonSearchBar(
                  padding: .zero,
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  hintSearch: widget.searchHint,
                ),
              ),
              if (widget.showFilterButton && (widget.tabs ?? []).isEmpty)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showFilterBottomSheet,
                    borderRadius: .circular(1000),
                    child: Padding(
                      padding: .all(8.h),
                      child: const Icon(
                        Icons.filter_list,
                        color: AppColors.black3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        if (widget.tabs != null)
          BaseFilterTabs(
            tabs: widget.tabs ?? [],
            selectedTab: _tabIndex,
            onTabChanged: _onTabChanged,
            showFilterButton: widget.showFilterButton,
            onFilterPressed: _showFilterBottomSheet,
          ),
        if (widget.showSearchResultLabel &&
            (_currentKeyword?.trim().isNotEmpty ?? false))
          Container(
            width: .infinity,
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              "Kết quả tìm kiếm:",
              textAlign: .start,
              style: AppStyles.text.bold(fSize: 14.sp, color: AppColors.black),
            ),
          ),
        Expanded(
          child: _ListContent<T>(
            dataStream: widget.dataStream,
            totalCount: widget.totalCount,
            itemBuilder: widget.itemBuilder,
            emptyMessage: widget.emptyMessage,
            emptyWidget: widget.emptyWidget,
            headerWidget: widget.headerWidget,
            footerWidget: widget.footerWidget,
            separatorBuilder: widget.separatorBuilder,
            isSearchLoading: widget.isSearchLoading,
            isInitialLoading: widget.isInitialLoading,
            onRefresh: widget.onRefresh,
            loadMoreFunc: widget.loadMoreFunc,
            minusMaxScrollValue: widget.minusMaxScrollValue,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildBody();

    // Nếu không dùng Scaffold
    if (!widget.useScaffold) {
      // Nếu có customAppBar, wrap với Column
      if (widget.customAppBar != null) {
        return SizedBox(
          width: .infinity,
          child: ColumnWidget(
            backgroundColor: AppColors.background,
            mainAxisSize: .min,
            children: [
              widget.customAppBar!,
              Expanded(child: body),
            ],
          ),
        );
      }
      // Nếu không có customAppBar, trả về body trực tiếp (có thể wrap với SafeArea nếu cần)
      return body;
    }

    // Default: wrap với Scaffold và AppBar
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: widget.appBarTitle,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        actions: widget.appBarActions,
      ),
      resizeToAvoidBottomInset: true,
      body: body,
    );
  }
}

/// Filter Tabs Component
class BaseFilterTabs extends StatelessWidget {
  final List<TabConfig> tabs;
  final int selectedTab;
  final Function(int, dynamic value) onTabChanged;
  final bool showFilterButton;
  final VoidCallback? onFilterPressed;

  const BaseFilterTabs({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
    required this.showFilterButton,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.background, width: 1.sp),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: .horizontal,
              child: RowWidget(
                mainAxisSize: .min,
                gap: 20.w,
                children: tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;

                  // Check permission nếu có
                  if (tab.hasPermission != null && !tab.hasPermission!()) {
                    return const SizedBox.shrink();
                  }

                  // Build tab với badge nếu có stream
                  if (tab.badgeStream != null) {
                    return StreamBuilder<int>(
                      stream: tab.badgeStream,
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return _buildTab(
                          tab.label,
                          isSelected: selectedTab == index,
                          onTap: () => onTabChanged(index, tab.value),
                          count: count > 0 ? count : null,
                        );
                      },
                    );
                  }

                  return _buildTab(
                    tab.label,
                    isSelected: selectedTab == index,
                    onTap: () => onTabChanged(index, tab.value),
                  );
                }).toList(),
              ),
            ),
          ),
          if (showFilterButton)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFilterPressed,
                borderRadius: .circular(1000),
                child: Padding(
                  padding: .all(8.h),
                  child: const Icon(Icons.filter_list, color: AppColors.black3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTab(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
    int? count,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: .symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: AppStyles.text
                    .medium(
                      fSize: 14.sp,
                      color: isSelected ? AppColors.primary : AppColors.black3,
                    )
                    .copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
              ),
              if (count != null && count > 0)
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
  }
}

/// List Content Component
class _ListContent<T> extends StatefulWidget {
  final Stream<List<T>> dataStream;
  final int totalCount;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;
  final Widget? emptyWidget;
  final Widget? headerWidget;
  final Widget? footerWidget;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final bool Function()? isSearchLoading;
  final bool Function()? isInitialLoading;
  final Future<void> Function() onRefresh;
  final Future<dynamic>? Function()? loadMoreFunc;
  final double minusMaxScrollValue;

  const _ListContent({
    required this.dataStream,
    required this.totalCount,
    required this.itemBuilder,
    required this.emptyMessage,
    this.emptyWidget,
    this.headerWidget,
    this.footerWidget,
    this.separatorBuilder,
    required this.isSearchLoading,
    required this.isInitialLoading,
    required this.onRefresh,
    required this.loadMoreFunc,
    required this.minusMaxScrollValue,
  });

  @override
  State<_ListContent<T>> createState() => _ListContentState<T>();
}

class _ListContentState<T> extends State<_ListContent<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadMore = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await widget.onRefresh();
    await Future.delayed(Durations.medium4);
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    if (widget.loadMoreFunc == null) return true;

    _isLoadMore = true;
    widget.loadMoreFunc?.call()?.then((_) {
      _isLoadMore = false;
      if (mounted) setState(() {});
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search loading indicator (animated)
        if (widget.isSearchLoading != null)
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: widget.isSearchLoading!()
                ? const ShimmerView(
                    type: .onlyLoadingIndicator,
                    key: ValueKey('search-loading'),
                  )
                : const SizedBox.shrink(),
          ),
        Expanded(
          child: StreamBuilder<List<T>>(
            stream: widget.dataStream,
            builder: (context, snapshot) {
              // Initial loading state
              if (snapshot.connectionState == .waiting ||
                  (widget.isInitialLoading != null &&
                      widget.isInitialLoading!())) {
                return const ShimmerView(type: .loadingIndicatorAtHead);
              }

              final items = snapshot.data ?? [];

              // Empty state
              if (items.isEmpty) {
                return widget.emptyWidget ??
                    EmptyViewState(message: widget.emptyMessage);
              }

              // List view
              return CommonLoadMoreRefreshWrapper(
                onRefresh: _onRefresh,
                onLoadMore: _onLoadMore,
                minusMaxScrollValue: widget.minusMaxScrollValue.h,
                child: Scrollbar(
                  controller: _scrollController,
                  radius: .circular(4.r),
                  child: ListView.separated(
                    controller: _scrollController,
                    // padding: .only(top: 8.h),
                    itemCount:
                        items.length +
                        (widget.headerWidget != null ? 1 : 0) +
                        1,
                    separatorBuilder:
                        widget.separatorBuilder ??
                        (_, _) => const SizedBox.shrink(),
                    itemBuilder: (context, index) {
                      // Header
                      if (widget.headerWidget != null && index == 0) {
                        return widget.headerWidget!;
                      }

                      if (index == items.length + 1) {
                        if (items.length < widget.totalCount) {
                          return widget.footerWidget ??
                              ShimmerView(type: .onlyLoadingIndicator);
                        }
                        return Padding(
                          padding: .all(20.w),
                          child: Center(
                            child: Text(
                              'Đã hiển thị tất cả',
                              style: AppStyles.text.medium(
                                fSize: 14.sp,
                                color: AppColors.grey84,
                              ),
                            ),
                          ),
                        );
                      }

                      // Item
                      final actualIndex = widget.headerWidget != null
                          ? index - 1
                          : index;
                      final item = items[actualIndex];
                      return widget.itemBuilder(context, item, actualIndex);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
