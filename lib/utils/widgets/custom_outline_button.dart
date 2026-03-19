import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

class CustomOutlineBtnWidget extends StatelessWidget {
  final String label;
  final Function() onTap;
  const CustomOutlineBtnWidget({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            color: AppColors.black,
          ),
        ),
        child: Text(
          label,
          style: AppStyles.text.semiBold(fSize: 12.sp),
        ),
      ),
    );
  }
}
