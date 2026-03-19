import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../res/res.dart';
import 'widgets.dart';

class CustomSnackBarWidget {
  final BuildContext context;
  final CustomSnackBarType type;
  final String message;
  final Color? forceColor;
  final Color? backgroundColor;

  CustomSnackBarWidget(
    this.context, {
    required this.type,
    required this.message,
    this.forceColor,
    this.backgroundColor,
  });

  void show({Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        duration: duration ?? const Duration(seconds: 3),
        padding: .zero,
        content: CustomSnackBarView(
          type: type,
          message: message,
          forceColor: forceColor,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}

enum CustomSnackBarType { success, error, warning, info }

class CustomSnackBarView extends StatelessWidget {
  const CustomSnackBarView({
    super.key,
    required this.type,
    required this.message,
    this.forceColor,
    this.backgroundColor,
  });
  final CustomSnackBarType type;
  final String message;
  final Color? forceColor;
  final Color? backgroundColor;

  Color? get _colorByStt {
    if (forceColor.isNotNull) return forceColor!;
    switch (type) {
      case CustomSnackBarType.success:
        return AppColors.green;
      case CustomSnackBarType.error:
        return AppColors.cancel;
      case CustomSnackBarType.warning:
        return AppColors.warning;
      case CustomSnackBarType.info:
        return AppColors.info;
    }
  }

  IconData get _iconByStt {
    switch (type) {
      case CustomSnackBarType.success:
        return Icons.check_circle;
      case CustomSnackBarType.error:
        return Icons.error;
      case CustomSnackBarType.warning:
        return Icons.warning;
      case CustomSnackBarType.info:
        return Icons.info;
    }
  }

  Color? get _iconColorByStt {
    switch (type) {
      case CustomSnackBarType.success:
        return AppColors.green;
      case CustomSnackBarType.error:
        return AppColors.cancel;
      case CustomSnackBarType.warning:
        return AppColors.warning;
      case CustomSnackBarType.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RowWidget(
      padding: .symmetric(horizontal: 20.w, vertical: 12.h),
      backgroundColor: backgroundColor ?? _colorByStt?.withValues(alpha: 0.1),
      gap: 8.w,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: _iconColorByStt?.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Icon(_iconByStt, size: 16.sp, color: _iconColorByStt),
        ),
        Expanded(
          child: Text(
            message,
            style: AppStyles.text.medium(
              fSize: 12.sp,
              color: AppColors.black5,
              height: 14 / 12,
            ),
            maxLines: 2,
            overflow: .ellipsis,
          ),
        ),
        const SizedBox.shrink(),
        InkWell(
          onTap: () => ScaffoldMessenger.of(context).clearSnackBars(),
          child: Container(
            padding: .symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.greyFx,
              borderRadius: .circular(8.r),
            ),
            child: Text(
              'Đóng',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.black5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
