import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/styles.dart';

import '../../utils/widgets/widgets.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? decorateIcon;
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.decorateIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: .circular(12.r),
      ),
      child: RowWidget(
        gap: 4.w,
        children: [
          Text(
            label,
            style: AppStyles.text.medium(
              fSize: 12.sp,
              color: color,
              height: 18 / 12,
            ),
          ),
          if (decorateIcon != null)
            Icon(decorateIcon, size: 16.sp, color: color),
        ],
      ),
    );
  }
}
