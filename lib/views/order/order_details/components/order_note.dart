part of '../order_details_screen.dart';

class _OrderNote extends StatelessWidget {
  const _OrderNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(20.w).copyWith(top: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ghi chú",
            style: AppStyles.text.semiBold(fSize: 15.sp),
          ),
          height(height: 8),
          Text(
            '''"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."''',
            style: AppStyles.text.mediumItalic(
              fSize: 14.sp,
              color: AppColors.black5,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
