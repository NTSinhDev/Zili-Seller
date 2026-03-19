import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';

class CustomRadioBtnWidget extends StatelessWidget {
  final bool isActive;
  const CustomRadioBtnWidget({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return !isActive
        ? Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black),
              shape: BoxShape.circle,
            ),
          )
        : SvgPicture.asset(
            AppConstant.svgs.icCheckRadio,
            width: 20.w,
            height: 20.w,
          );
  }
}
