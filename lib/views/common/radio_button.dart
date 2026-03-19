import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';

class CommonRadioButtonItem extends StatelessWidget {
  final Function()? onSelect;
  final bool isSelected;
  final String label;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final Widget? trailing;
  final bool canExpand;
  const CommonRadioButtonItem({
    super.key,
    this.onSelect,
    required this.isSelected,
    required this.label,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    this.trailing,
    this.canExpand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: InkWell(
        onTap: onSelect,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: CommonRadioButton(
                isActive: isSelected,
                inactiveColor: AppColors.black3,
              ),
            ),
            width(width: 8),
            if (canExpand)
              Expanded(
                child: Text(
                  label,
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: isSelected ? AppColors.primary : AppColors.black3,
                    height: 18 / 14,
                  ),
                ),
              )
            else
              Text(
                label,
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: isSelected ? AppColors.primary : AppColors.black3,
                ),
              ),
            trailing ?? Container(),
          ],
        ),
      ),
    );
  }
}

class CommonRadioButton extends StatelessWidget {
  final bool isActive;
  final Color? inactiveColor;
  final Color? color;
  final double? size;
  final double? stroke;
  const CommonRadioButton({
    super.key,
    required this.isActive,
    this.inactiveColor,
    this.color,
    this.size,
    this.stroke,
  });

  @override
  Widget build(BuildContext context) {
    return !isActive
        ? Container(
            width: size ?? 20.w,
            height: size ?? 20.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: inactiveColor ?? AppColors.greyC0,
                width: 1.3.sp,
              ),
              shape: BoxShape.circle,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              border: Border.all(color: color ?? AppColors.primary),
              shape: BoxShape.circle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: (size ?? 20.w) - 6.w,
                  height: (size ?? 20.w) - 6.w,
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: color ?? AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
  }
}
