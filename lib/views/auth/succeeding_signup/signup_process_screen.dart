import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';

class SucceedingSignupScreen extends StatelessWidget {
  const SucceedingSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppConstant.svgs.icSucceedingRegister),
            height(height: 38),
            Text(
              'Cảm ơn!',
              style:
                  AppStyles.text.bold(fSize: 23.sp, color: AppColors.primary),
            ),
            height(height: 11),
            Text(
              'Tài khoản của bạn đã được tạo',
              style:
                  AppStyles.text.medium(fSize: 16.sp, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
