import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';
import '../../utils/widgets/widgets.dart';

class EmptyViewState extends StatelessWidget {
  final String message;
  final Widget? iconWidget;
  final String? label;
  final String? labelButton;
  final String? description;
  final VoidCallback? onTap;
  const EmptyViewState({
    super.key,
    required this.message,
    this.iconWidget,
    this.label,
    this.labelButton,
    this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (labelButton != null && onTap != null) {
      return Center(
        child: SizedBox(
          width: 0.72.sw,
          child: Column(
            mainAxisAlignment: .center,
            children: [
              if (iconWidget != null) ...[iconWidget!, SizedBox(height: 16.h)],
              if (label != null && description != null) ...[
                Text(
                  label!,
                  style: AppStyles.text.semiBold(
                    fSize: 16.sp,
                    color: AppColors.black3,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description!,
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.grey84,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
              ],
              SizedBox(
                width: .infinity,
                child: ElevatedButton(
                  autofocus: false,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  onPressed: onTap,
                  child: Text(
                    labelButton!,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      width: .infinity,
      height: 180.h,
      child: ColumnWidget(
        gap: 16.h,
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: [
          Image.asset(AssetImages.emptyBoxPng, width: 80, fit: .fitWidth),
          Text(
            message,
            style: AppStyles.text.medium(
              fSize: 14.sp,
              color: SystemColors.secondaryPurple10,
            ),
          ),
        ],
      ),
    );
  }
}
