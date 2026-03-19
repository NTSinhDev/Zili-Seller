import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function()? onTap;
  final String? label;
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsets? padding;
  final Color? color;
  final double? radius;
  final Color? borderColor;
  final List<BoxShadow>? boxShadows;
  final Color? labelColor;
  const CustomButtonWidget({
    super.key,
    this.onTap,
    this.label,
    this.width,
    this.child,
    this.padding,
    this.color,
    this.height,
    this.radius,
    this.borderColor,
    this.boxShadows,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: padding != null ? null : height ?? 50.h,
        padding: padding,
        width: padding != null ? null : width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 14.r),
          color: color ?? AppColors.primary,
          border: Border.all(color: borderColor ?? AppColors.primary),
          boxShadow: boxShadows ??
              <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 4.r,
                ),
              ],
        ),
        child: child ??
            Center(
              child: label!.isEmpty
                  ? SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: const CircularProgressIndicator(
                        color: AppColors.lightGrey,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      label!,
                      style: AppStyles.text.bold(
                          fSize: 16.sp, color: labelColor ?? AppColors.white),
                    ),
            ),
      ),
    );
  }
}
