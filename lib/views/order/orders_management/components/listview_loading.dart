part of '../orders_management_screen.dart';

class _ListViewLoading extends StatelessWidget {
  const _ListViewLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.0,
              backgroundColor: AppColors.grayEA,
            ),
          ),
          width(width: 7),
          Text(
            'Loading...',
            style: AppStyles.text.semiBold(
              fSize: 13.sp,
              color: AppColors.primary,
            ),
          )
        ],
      ),
    );
  }
}
