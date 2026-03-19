import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.scarlet.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.scarlet),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.scarlet,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
