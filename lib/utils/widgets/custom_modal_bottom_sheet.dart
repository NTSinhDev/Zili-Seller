import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

/// This class provide layouts to create UI scaffold for Modal-Bottom-Sheet
class LayoutModalBottomSheet {
  static Widget basic({
    required List<Widget> children,
    double? height,
    EdgeInsets? padding,
    MainAxisAlignment? verticalAxis,
  }) {
    return Container(
      height: height ?? 139.h,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisAlignment: verticalAxis ?? MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  static void advanceTransparentScaffold(BuildContext context,
      {required Widget child, double? height}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (childContext) {
        return Container(
          height: height ?? 139.h,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          ),
          child: child,
        );
      },
    );
  }

  static void transparentScafolld(BuildContext context, {required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (childContext) => child,
    );
  }
}
