import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';

class AllDataHasBeenShow extends StatelessWidget {
  final String? label;
  const AllDataHasBeenShow({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Center(
        child: Text(
          label ?? 'Đã hiển thị tất cả dữ liệu',
          style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84),
        ),
      ),
    );
  }
}
