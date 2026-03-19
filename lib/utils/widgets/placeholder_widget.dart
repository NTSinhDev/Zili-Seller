import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zili_coffee/res/res.dart';

enum PlaceholderOptions { text16, text14, text12 }

class PlaceholderOptionsWidget extends StatelessWidget {
  final Widget child;
  final PlaceholderOptions options;
  final double width;
  final bool condition;
  final BorderRadiusGeometry? rounded;

  const PlaceholderOptionsWidget({
    super.key,
    required this.width,
    required this.options,
    required this.child,
    this.condition = false,
    this.rounded,
  });

  double get _height {
    switch (options) {
      case PlaceholderOptions.text16:
        return 18;
      case PlaceholderOptions.text14:
        return 16;
      case PlaceholderOptions.text12:
        return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderWidget(
      width: width,
      height: _height,
      rounded: rounded ?? BorderRadius.circular(4),
      condition: condition,
      child: child,
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final Color? highlightColor;
  final bool borderRadius;
  final bool condition;
  final bool shapeCircle;
  final Widget? child;
  const PlaceholderWidget({
    super.key,
    required this.width,
    required this.height,
    this.color,
    this.highlightColor,
    this.child,
    this.condition = false,
    this.borderRadius = true,
    this.shapeCircle = false,
    this.rounded,
    this.alphaValue,
  });
  final BorderRadiusGeometry? rounded;
  final double? alphaValue;

  BorderRadiusGeometry get getRounded =>
      rounded ?? (borderRadius ? BorderRadius.circular(10) : BorderRadius.zero);

  @override
  Widget build(BuildContext context) {
    return condition && child != null
        ? child!
        : Container(
            width: width.w,
            height: height.h,
            decoration: BoxDecoration(
              borderRadius: getRounded,
              color: AppColors.white,
            ),
            child: ClipRRect(
              borderRadius: shapeCircle
                  ? BorderRadius.circular(10000.r)
                  : getRounded,
              child: Shimmer.fromColors(
                baseColor: (color ?? AppColors.grayEA).withValues(alpha: alphaValue ?? 0.7),
                highlightColor: (highlightColor ?? AppColors.lightGrey)
                    .withValues(alpha: 0.8),
                period: const Duration(milliseconds: 1500),
                child: Container(
                  width: 155.w,
                  height: 262.h,
                  color: AppColors.white,
                ),
              ),
            ),
          );
  }
}
