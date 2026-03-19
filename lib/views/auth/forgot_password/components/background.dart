part of '../forgot_password_screen.dart';

class _Background{
  static List<Widget> build() {
    return [
      Positioned(
        bottom: 30.h,
        left: 0,
        child: SvgPicture.asset(AppConstant.svgs.bgBottomLeftMount),
      ),
      Positioned(
        bottom: 0.h,
        right: 0,
        child: SvgPicture.asset(AppConstant.svgs.bgBottomRightMount),
      ),
      Positioned(
        bottom: 119.h,
        right: 0,
        child: SvgPicture.asset(AppConstant.svgs.bgRightMount),
      ),
    ];
  }
}