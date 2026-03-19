import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class RoundedBackBtn extends StatelessWidget {
  final String label;
  final Function()? onBack;
  const RoundedBackBtn({super.key, required this.label, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButtonWidget(
          onTap: onBack ?? () {},
          radius: 48.r,
          color: AppColors.white,
          height: 44.h,
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppConstant.svgs.icArrowLeftCircle),
              width(width: 5),
              Text(
                label,
                style: AppStyles.text.semiBold(
                  fSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
              width(width: 20),
            ],
          ),
        ),
        height(height: 26),
      ],
    );
  }
}
