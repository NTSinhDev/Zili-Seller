import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

extension ThemeApp on ThemeData {
  static SystemUiOverlayStyle get systemDefault => systemLight;

  static SystemUiOverlayStyle get systemLight => SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Platform.isAndroid
        ? Brightness.dark
        : Brightness.light,
    statusBarBrightness: Platform.isIOS ? Brightness.light : null,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,

    /// [SystemUiOverlayStyle.systemNavigationBarContrastEnforced] only for android
    /// Xử lý cho trường hợp Background app sáng và Icon navigation bar cũng sáng (hầu hết Brightness.dark thì set là true)
    /// 👉 Tự động phủ 1 lớp scrim mờ (translucent overlay) phía sau navigation bar
    /// 👉 Mục đích: đảm bảo icon navigation bar luôn đủ tương phản
    systemNavigationBarContrastEnforced: true,
  );
  static SystemUiOverlayStyle get systemDark => SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Platform.isAndroid
        ? Brightness.light
        : Brightness.dark,
    statusBarBrightness: Platform.isIOS ? Brightness.dark : null,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,

    /// [SystemUiOverlayStyle.systemNavigationBarContrastEnforced] only for android
    /// Xử lý cho trường hợp Background app sáng và Icon navigation bar cũng sáng (hầu hết Brightness.dark thì set là true)
    /// 👉 Tự động phủ 1 lớp scrim mờ (translucent overlay) phía sau navigation bar
    /// 👉 Mục đích: đảm bảo icon navigation bar luôn đủ tương phản
    systemNavigationBarContrastEnforced: true,
  );

  static ThemeData get theme {
    final defaultTheme = ThemeData.light();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: defaultTheme.appBarTheme.copyWith(
        titleTextStyle: AppStyles.text.bold(fSize: 16.sp),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        scrolledUnderElevation: 1,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        systemOverlayStyle: ThemeApp.systemLight,
      ),
      colorScheme: defaultTheme.colorScheme.copyWith(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        error: SystemColors.tertiaryRed50,
        onError: SystemColors.secondaryPurple50,
        secondary: AppColors.background,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        tertiary: Colors.red,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        dayBackgroundColor: .resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
        rangeSelectionBackgroundColor: AppColors.primary.withValues(
          alpha: 0.15,
        ),
      ),
      materialTapTargetSize: .shrinkWrap,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: .resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary.withValues(alpha: 0.8);
            }
            return AppColors.primary;
          }),
          foregroundColor: .resolveWith<Color?>((states) {
            return AppColors.white;
          }),
          textStyle: .resolveWith<TextStyle?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppStyles.text.medium(fSize: 14.sp, color: Colors.white);
            }
            return AppStyles.text.medium(fSize: 16.sp, color: Colors.white);
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: .all(AppColors.primary),
          textStyle: .all(
            AppStyles.text.medium(fSize: 16.sp, color: AppColors.primary),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: .all(AppColors.primary),
          side: .all(const BorderSide(color: AppColors.primary)),
          textStyle: .all(
            AppStyles.text.medium(fSize: 16.sp, color: AppColors.primary),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3),
      ),
      highlightColor: AppColors.primary.withValues(alpha: 0.08),
      splashColor: AppColors.primary.withValues(alpha: 0.12),
      hoverColor: AppColors.primary.withValues(alpha: 0.04),
      textTheme: defaultTheme.textTheme.copyWith(
        // Config title text style
        titleMedium: AppStyles.text.bold(fSize: 16.sp, color: AppColors.black3),
        titleSmall: AppStyles.text.semiBold(
          fSize: 14.sp,
          color: AppColors.black3,
        ),
        // Config body text style
        bodyLarge: AppStyles.text.medium(fSize: 16.sp, color: AppColors.black3),
        bodyMedium: AppStyles.text.medium(
          fSize: 14.sp,
          color: AppColors.black3,
        ),
        bodySmall: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
        // config label text style
        labelMedium: AppStyles.text.medium(
          fSize: 14.sp,
          color: AppColors.black3,
        ),
        labelSmall: AppStyles.text.medium(
          fSize: 12.sp,
          color: AppColors.black3,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: .vertical(top: .circular(16.r)),
        ),
      ),
    );
  }
}
