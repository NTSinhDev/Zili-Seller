import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../res/res.dart';

enum ShimmerType { onlyLoadingIndicator, loadingIndicatorAtHead, normal, card }

class ShimmerView extends StatelessWidget {
  final ShimmerType type;
  final Color? backgroundColor;
  const ShimmerView({super.key, required this.type, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ShimmerType.onlyLoadingIndicator:
        return Container(
          padding: .all(20.w),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.background,
            borderRadius: .circular(10.r),
          ),
          child: Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: AppColors.loadingIndicatorLeftDot,
              rightDotColor: AppColors.loadingIndicatorRightDot,
              size: 36.w,
            ),
          ),
        );
      case ShimmerType.loadingIndicatorAtHead:
        return Container(
          margin: .only(top: 16.h),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: .all(20.w),
                child: Center(
                  child: LoadingAnimationWidget.flickr(
                    leftDotColor: AppColors.loadingIndicatorLeftDot,
                    rightDotColor: AppColors.loadingIndicatorRightDot,
                    size: 36.w,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ).copyWith(top: 0),
                  itemCount: 6,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _buildLoadingItem(),
                ),
              ),
            ],
          ),
        );
      case ShimmerType.normal:
        return Container(
          width: .infinity,
          margin: .only(top: 16.h),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: .start,
            children: List.generate(6, (index) => _buildLoadingItem()),
          ),
        );
      case ShimmerType.card:
        return _buildLoadingItem();
    }
  }

  Widget _buildLoadingItem() {
    return Container(
      margin: .only(bottom: 12.h),
      padding: .all(10.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(10.r),
      ),
      height: 80.h,
    );
  }
}
