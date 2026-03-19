import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class DiscountCode extends StatelessWidget {
  const DiscountCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomInputFieldWidget(
            hint: '',
            label: 'NHẬP MÃ GIẢM GIÁ',
            customStyleInput: AppStyles.text.semiBold(
              fSize: 18.sp,
              color: AppColors.primary,
            ),
            customStyleLabel: AppStyles.text.semiBold(
              fSize: 18.sp,
              color: AppColors.primary,
            ),
            height: 46.h,
            radius: 4.r,
          ),
        ),
        width(width: 14),
        CustomButtonWidget(
          onTap: () {},
          width: 56.w,
          radius: 5.r,
          padding: EdgeInsets.all(15.w),
          child: Center(
            child: Text(
              'Áp Dụng',
              style: AppStyles.text
                  .semiBold(fSize: 14.sp, color: AppColors.white)
                  .copyWith(letterSpacing: -0.2),
            ),
          ),
        )
      ],
    );
  }
}