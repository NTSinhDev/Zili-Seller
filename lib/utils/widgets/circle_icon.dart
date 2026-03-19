import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';

class CircleIconWidget extends StatelessWidget {
  final String iconRoute;
  final Color? iconColor;
  final Color? color;
  final double? padding;
  final Widget? child;
  const CircleIconWidget({
    super.key,
    required this.iconRoute,
    this.child,
    this.iconColor,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? AppColors.primary.withOpacity(0.1),
      ),
      child: child ??
          SvgPicture.asset(
            iconRoute,
            colorFilter: ColorFilter.mode(
              iconColor ?? AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
    );
  }
}
