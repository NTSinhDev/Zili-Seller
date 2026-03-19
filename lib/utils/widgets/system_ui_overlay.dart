import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:wolcg/res/res.dart';

class SystemUIOverlayWidget extends StatelessWidget {
  final Widget child;
  final bool? isLight;
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;
  final Brightness? navIconBrightness;
  final Color? systemNavigationBarColor;
  final Color? systemNavigationBarDividerColor;
  const SystemUIOverlayWidget({
    super.key,
    required this.child,
    this.isLight,
    this.statusBarColor,
    this.statusBarIconBrightness,
    this.navIconBrightness,
    this.systemNavigationBarColor,
    this.systemNavigationBarDividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUi ??
          SystemUiOverlayStyle(
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarIconBrightness,
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
            systemNavigationBarContrastEnforced: true,
            systemNavigationBarIconBrightness: navIconBrightness,
            systemStatusBarContrastEnforced: false,
            statusBarBrightness: Brightness.light,
          ),
      child: child,
    );
  }

  SystemUiOverlayStyle? get systemUi {
    if (isLight == null) return null;
    if (isLight!) {
      return SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        systemNavigationBarDividerColor: systemNavigationBarDividerColor,
        systemNavigationBarColor:
            systemNavigationBarColor ?? Colors.transparent,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarIconBrightness: navIconBrightness ?? Brightness.dark,
        systemStatusBarContrastEnforced: false,
        statusBarBrightness: Brightness.dark,
      );
    }
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: false,
      statusBarBrightness: Brightness.light,
    );
  }
}
