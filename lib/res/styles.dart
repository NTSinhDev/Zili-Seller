import 'package:flutter/material.dart';
import 'package:zili_coffee/res/res.dart';

class AppStyles {
  // ignore: library_private_types_in_public_api
  static _TextStyle text = _TextStyle();
}

class _TextStyle {
  TextStyle passionsConflict({required double fSize, double? height, Color? color}) {
    return TextStyle(
      fontFamily: "Passions Conflict",
      fontSize: fSize,
      fontWeight: FontWeight.w400,
      height: height ?? 1,
      color: color ?? AppColors.primary,
    );
  }

  TextStyle bold({required double fSize, double? height, Color? color}) {
    return TextStyle(
      fontFamily: "SVNGilroy Bold",
      fontSize: fSize,
      fontWeight: FontWeight.w800,
      height: height ?? 1,
      color: color ?? AppColors.black,
    );
  }

  TextStyle semiBold({required double fSize, double? height, Color? color}) {
    return TextStyle(
      fontFamily: "SVNGilroy SemiBold",
      fontSize: fSize,
      fontWeight: FontWeight.w600,
      height: height ?? 1,
      color: color ?? AppColors.black,
    );
  }

  TextStyle medium({required double fSize, double? height, Color? color}) {
    return TextStyle(
      fontFamily: "SVNGilroy Medium",
      fontSize: fSize,
      fontWeight: FontWeight.w500,
      height: height ?? 1,
      color: color ?? AppColors.black,
    );
  }

  TextStyle mediumItalic(
      {required double fSize, double? height, Color? color}) {
    return TextStyle(
      fontFamily: "SVNGilroy Medium Italic",
      fontSize: fSize,
      fontWeight: FontWeight.w500,
      height: height ?? 1,
      color: color ?? AppColors.black,
    );
  }
}
