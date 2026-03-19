import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/auth/authentication/login/login_screen.dart';
import 'package:zili_coffee/views/auth/authentication/register/register_screen.dart';
part 'components/checkout_success.dart';
part 'components/checkout_failed.dart';
part 'components/unauthentication.dart';
part 'components/common.dart';
part 'components/background.dart';

class UINotificationProvider {
  static Widget checkoutFailed(BuildContext context) {
    return const _CheckoutFailed();
  }

  static Widget checkoutSuccess(BuildContext context) {
    return const _CheckoutSuccess();
  }

  static Widget blockedIfNotAuthentication(
    BuildContext context, {
    required String notificationContent,
    required Object passArgsToAuthScreen,
  }) {
    return _Unauthentication(
      content: notificationContent,
      passArgsToAuthScreen: passArgsToAuthScreen,
    );
  }

  static Widget custom({required Widget child}) {
    return _Common(child: child);
  }

  static Widget common(
    BuildContext context, {
    required String title,
    required String content,
    required String leftButton,
    required String rightButton,
    required Function() onTap,
  }) {
    return _Common(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(height: 20.h),
          Text(
            title,
            style: AppStyles.text.semiBold(
              fSize: 16.sp,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.start,
          ),
          height(height: 14.h),
          Text(
            content,
            style: AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.primary,
              height: 1.3,
            ),
            textAlign: TextAlign.start,
          ),
          height(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButtonWidget(
                onTap: () => context.navigator.pop(),
                radius: 48.r,
                color: AppColors.white,
                width: 120.w,
                height: 40.h,
                boxShadows: const [],
                child: Center(
                  child: Text(
                    leftButton,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              width(width: 12),
              CustomButtonWidget(
                onTap: () {
                  onTap();
                  context.navigator.pop();
                },
                radius: 48.r,
                width: 120.w,
                height: 40.h,
                borderColor: AppColors.primary,
                color: AppColors.primary,
                boxShadows: const [],
                child: Center(
                  child: Text(
                    rightButton,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
