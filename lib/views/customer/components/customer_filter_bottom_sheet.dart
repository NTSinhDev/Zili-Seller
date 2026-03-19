part of '../customer_screen.dart';

class _CustomerFilterBottomSheet extends StatelessWidget {
  final VoidCallback onFilterApplied;

  const _CustomerFilterBottomSheet({
    required this.onFilterApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyC0,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Lọc',
              style: AppStyles.text.bold(
                fSize: 18.sp,
                color: AppColors.black3,
              ),
            ),
          ),
          // Filter Options (Placeholder - sẽ implement sau)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Tính năng lọc nâng cao sẽ được phát triển sau',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.grey84,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

