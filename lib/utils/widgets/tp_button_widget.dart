import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

enum TPButtonType {
  filled,
  outline,
  linked,
  text,
}

class TPButton extends StatelessWidget {
  const TPButton({
    ValueKey? key,
    this.width = 180,
    this.height = 44,
    this.title,
    required this.onPressed,
    this.type = TPButtonType.filled,
    this.radius,
    this.wTitle,
    this.btnColor,
    this.tintColor,
  }) : super(key: key);

  factory TPButton.textButton({
    ValueKey? key,
    String? title,
    Function()? onPressed,
    Widget? wTitle,
    Color? tintColor,
    double width = 0,
  }) {
    return TPButton(
      key: key,
      width: width,
      title: title,
      onPressed: onPressed,
      type: TPButtonType.text,
      wTitle: wTitle,
      tintColor: tintColor,
    );
  }

  factory TPButton.filledButton({
    ValueKey? key,
    double width = 180,
    double height = 44,
    String? title,
    Function()? onPressed,
    double? radius,
    Widget? wTitle,
    Color? btnColor,
    Color? tintColor,
  }) {
    return TPButton(
      key: key,
      width: width,
      height: height,
      title: title,
      onPressed: onPressed,
      radius: radius,
      wTitle: wTitle,
      btnColor: btnColor,
      tintColor: tintColor,
    );
  }

  factory TPButton.deleteButton({
    ValueKey? key,
    double width = 180,
    double height = 44,
    String? title = 'Delete',
    required Function() onPressed,
    double? radius,
    Widget? wTitle,
    Color? tintColor,
  }) {
    return TPButton(
      key: key,
      width: width,
      height: height,
      title: title,
      onPressed: onPressed,
      radius: radius,
      wTitle: wTitle,
      btnColor: Colors.redAccent[100],
      tintColor: tintColor,
    );
  }

  factory TPButton.linkedButton({
    ValueKey? key,
    String? title,
    Function()? onPressed,
    Widget? wTitle,
    Color? tintColor,
    double width = 0,
  }) {
    return TPButton(
      key: key,
      width: width,
      title: title,
      onPressed: onPressed,
      type: TPButtonType.linked,
      wTitle: wTitle,
      tintColor: tintColor,
    );
  }
  final double width;
  final double height;
  final String? title;
  final TPButtonType type;
  final Function()? onPressed;
  final double? radius;
  final Widget? wTitle;
  final Color? btnColor;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: width, minHeight: height),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor ?? AppColors.primary,
            disabledForegroundColor: btnColor?.withPercentAlpha(0.5) ??
                AppColors.primary.withPercentAlpha(0.5).withOpacity(0.38),
            disabledBackgroundColor: btnColor?.withPercentAlpha(0.5) ??
                AppColors.primary.withPercentAlpha(0.5).withOpacity(0.12),
          ),
          onPressed: onPressed,
          child: wTitle ??
              Text(
                title!,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: tintColor ?? Colors.white,
                ),
              ),
        ),
    );
  }
}

extension ColorExt on Color {
  Color withPercentAlpha(double percent) {
    if (percent >= 1) {
      return this;
    }

    return withAlpha((255 * percent).toInt());
  }

  static Color colorWithHex(int hexColor) {
    return Color.fromARGB(
      0xFF,
      (hexColor >> 16) & 0xFF,
      (hexColor >> 8) & 0xFF,
      hexColor & 0xFF,
    );
  }

  static Color get myBlack {
    return ColorExt.colorWithHex(0x2C2C2C);
  }
}
