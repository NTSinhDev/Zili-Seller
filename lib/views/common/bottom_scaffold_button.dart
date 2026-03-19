import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';
import '../../utils/widgets/widgets.dart';

class BottomScaffoldButton extends StatelessWidget {
  final String label;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Function() onTap;
  const BottomScaffoldButton({
    super.key,
    required this.onTap,
    required this.label,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? .symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grayEA)),
      ),
      child: SafeArea(
        child: RowWidget(
          children: [
            Expanded(
              child: ElevatedButton(
                autofocus: false,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: .symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                  elevation: 0,
                ),
                onPressed: onTap,
                child: Text(
                  label,
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum BottomScaffoldButtonColor { primary, secondary, danger, warning, info }

enum BottomScaffoldButtonStyle { filled, outline, text }

class BottomScaffoldButtonModel {
  final String label;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  final BottomScaffoldButtonColor color;
  final BottomScaffoldButtonStyle style;
  final Color? textColor;
  final bool canFocus;

  BottomScaffoldButtonModel({
    required this.label,
    this.onTap,
    this.padding,
    this.color = BottomScaffoldButtonColor.primary,
    this.style = BottomScaffoldButtonStyle.filled,
    this.textColor,
    this.canFocus = false,
  }) {
    focusNode = FocusNode(canRequestFocus: canFocus);
  }
  late final FocusNode focusNode;

  Color? get backgroundColor {
    switch (color) {
      case .primary:
        return AppColors.primary;
      case .secondary:
        return AppColors.white;
      case .danger:
        return AppColors.scarlet;
      case .warning:
        return AppColors.warning;
      case .info:
        return AppColors.info;
    }
  }

  Color? get borderColor {
    switch (color) {
      case .primary:
        return AppColors.primary;
      case .secondary:
        return AppColors.grayEA;
      case .danger:
        return AppColors.scarlet;
      case .warning:
        return AppColors.warning;
              case .info:
        return AppColors.info;
    }
  }

  Color? get buttonTextColor {
    if (textColor != null) {
      return textColor;
    }
    if (style == .filled) {
      return AppColors.white;
    }
    if (style == .outline) {
      return borderColor;
    }
    if (style == .text) {
      return AppColors.black3;
    }
    return null;
  }
}

class BottomScaffoldRowButtons extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final List<BottomScaffoldButtonModel> buttons;
  const BottomScaffoldRowButtons({
    super.key,
    required this.buttons,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? .symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grayEA)),
      ),
      child: SafeArea(
        child: RowWidget(
          gap: 20.w,
          children: buttons.map((button) {
            if (button.style == .filled) {
              return Expanded(
                child: ElevatedButton(
                  focusNode: button.focusNode,
                  onPressed: button.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: button.color == .primary
                        ? AppColors.primary
                        : AppColors.white,
                    padding: button.padding ?? .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    button.label,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: button.buttonTextColor ?? AppColors.white,
                    ),
                  ),
                ),
              );
            }
            if (button.style == .outline) {
              return Expanded(
                child: OutlinedButton(
                  onPressed: button.onTap,
                  focusNode: button.focusNode,
                  style: OutlinedButton.styleFrom(
                    side: button.borderColor != null
                        ? BorderSide(color: button.borderColor!)
                        : null,
                    padding: button.padding ?? .symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
                  ),
                  child: Text(
                    button.label,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: button.buttonTextColor,
                    ),
                  ),
                ),
              );
            }
            return Expanded(
              child: TextButton(
                focusNode: button.focusNode,
                onPressed: button.onTap,
                style: TextButton.styleFrom(
                  padding: button.padding ?? .symmetric(vertical: 14.h),
                ),
                child: Text(
                  button.label,
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: button.buttonTextColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
