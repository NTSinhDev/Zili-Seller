import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';

class LoadMoreRefreshWrapper extends StatelessWidget {
  final Widget child;
  final bool Function() onLoadMore;
  final double? minusMaxScrollValue;
  final Future<void> Function() onRefresh;
  final double? edgeOffset;
  const LoadMoreRefreshWrapper({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.onRefresh,
    this.minusMaxScrollValue,
    this.edgeOffset,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        final ScrollMetrics metrics = scrollNotification.metrics;
        if (metrics.axisDirection == AxisDirection.down ||
            metrics.axisDirection == AxisDirection.up) {
          final maxScrollExtent =
              metrics.maxScrollExtent - (minusMaxScrollValue ?? 0);
          if (metrics.pixels > maxScrollExtent) {
            return onLoadMore();
          }
        }

        return true;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        edgeOffset: edgeOffset ?? 0.0,
        color: AppColors.primary,
        backgroundColor: AppColors.background,
        displacement: 30.h,
        strokeWidth: 2,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: child,
      ),
    );
  }
}
