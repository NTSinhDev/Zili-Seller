import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/views/notification/notification_screen.dart';

class AppBarWidget {
  static AppBar greenAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      systemOverlayStyle: ThemeApp.systemDark.copyWith(
        systemNavigationBarColor: Platform.isAndroid ? AppColors.white : null,
      ),
      elevation: 0,
      toolbarHeight: 72.h,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Container(
        margin: .symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .center,
          children: [
            Image.asset(AssetLogos.logoPng, height: 50.h, fit: .fitWidth),
            InkWell(
              onTap: () =>
                  context.navigator.pushNamed(NotificationScreen.keyName),
              borderRadius: .circular(100.r),
              child: StreamBuilder(
                stream: const Stream.empty(),
                builder: (context, asyncSnapshot) {
                  return Badge(
                    isLabelVisible: asyncSnapshot.hasData,
                    backgroundColor: AppColors.scarlet,
                    child: SvgPicture.asset(
                      AssetIcons.iBellFillSvg,
                      fit: .fitWidth,
                      colorFilter: const .mode(AppColors.beige, .srcIn),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static AppBar lightAppBar(
    BuildContext context, {
    required String label,
    List<Widget>? actions,
    double? elevation,
    Widget? bottom,
    Color? backgroundColor,
    Color? foregroundColor,
    Function()? onBack,
    Color? shadowColor,
  }) {
    return AppBar(
      leading: onBack != null
          ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack)
          : null,
      backgroundColor: backgroundColor ?? AppColors.white,
      systemOverlayStyle: ThemeApp.systemLight.copyWith(
        statusBarColor: backgroundColor,
      ),
      toolbarHeight: 60.h,
      elevation: elevation ?? 1.5,
      shadowColor: shadowColor ?? AppColors.black,
      foregroundColor: AppColors.black,
      titleSpacing: 0,
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: Text(
        label.toUpperCase(),
        style: AppStyles.text.bold(fSize: 16.sp),
      ),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(preferredSize: Size.fromHeight(32.h), child: bottom)
          : null,
    );
  }

  static AppBar darkAppBar(
    BuildContext context, {
    required String label,
    Widget? title,
    List<Widget>? actions,
    double? elevation,
    Widget? bottom,
    Color? backgroundColor,
    Color? foregroundColor,
    bool titleAligLeft = false,
    double? bottomPreferredHeight,
    Function()? onBack,
  }) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.white,
      systemOverlayStyle: ThemeApp.systemDark.copyWith(
        statusBarColor: backgroundColor,
      ),
      toolbarHeight: 60.h,
      elevation: elevation ?? 1.5,
      foregroundColor: foregroundColor ?? AppColors.white,
      titleSpacing: 0,
      centerTitle: !titleAligLeft,
      automaticallyImplyLeading: true,
      title:
          title ??
          Text(
            label.toUpperCase(),
            style: AppStyles.text.bold(
              fSize: 16.sp,
              color: foregroundColor ?? AppColors.white,
            ),
          ),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomPreferredHeight ?? 32.h),
              child: bottom,
            )
          : null,
    );
  }
}
