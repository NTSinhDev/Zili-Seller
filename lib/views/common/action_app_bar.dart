import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/res.dart';

class AppBarActions {
  static List<Widget> build(List<AppBarActionModel> actions) {
    return [
      ...actions.map(
        (action) => ActionAppBarIcon(
          icon: action.icon,
          onTap: action.onTap,
          color: action.color,
          circleFrame: action.circleFrame,
          onLongPress: action.onLongPress,
        ),
      ),
      SizedBox(width: 4.w),
    ];
  }
}

class AppBarActionModel {
  final dynamic icon;
  final Color? color;
  final bool circleFrame;
  final Function() onTap;
  final Function()? onLongPress;
  const AppBarActionModel({
    required this.icon,
    this.color,
    required this.onTap,
    this.circleFrame = false,
    this.onLongPress,
  });
}

class ActionAppBarIcon extends StatelessWidget {
  final dynamic icon;
  final Color? color;
  final Function() onTap;
  final bool circleFrame;
  final Function()? onLongPress;
  const ActionAppBarIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.circleFrame = false,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: circleFrame ? EdgeInsets.all(12.w) : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(1000),
          child: Container(
            width: 24.sp,
            height: 24.sp,
            padding: !circleFrame ? EdgeInsets.all(8.h) : null,
            decoration: BoxDecoration(
              shape: circleFrame ? BoxShape.circle : BoxShape.rectangle,
              color: circleFrame
                  ? Colors.black12.withValues(alpha: 0.05)
                  : null,
            ),
            child: _buildIcon(),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(icon as IconData, color: color ?? AppColors.black3);
    }

    return SizedBox(
      width: 24.sp,
      height: 24.sp,
      child: SvgPicture.asset(
        icon as String,
        width: 24.sp,
        height: 24.sp,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.black3,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
