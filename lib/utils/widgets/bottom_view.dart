import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

// required parent is Stack widget
class BottomViewWidget extends StatelessWidget {
  final List<Widget> children;
  const BottomViewWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: Spaces.screenWidth(context),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          color: AppColors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              offset: const Offset(0.0, -3.0),
              blurRadius: 5.r,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
