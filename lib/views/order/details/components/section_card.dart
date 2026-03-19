import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

import '../../../../utils/widgets/widgets.dart';
import '../../../common/shimmer_view.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget? statusWidget;
  final bool loadingState;
  final Widget child;
  const SectionCard({
    super.key,
    required this.title,
    this.statusWidget,
    this.loadingState = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(16.w),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 10.h,
        children: [
          if (loadingState)
            ShimmerView(type: .onlyLoadingIndicator)
          else ...[
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  title,
                  style: AppStyles.text.semiBold(
                    fSize: 16.sp,
                    color: AppColors.black5,
                  ),
                ),
                if (statusWidget != null) statusWidget!,
              ],
            ),
            Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
          ],
          child,
        ],
      ),
    );
  }
}
