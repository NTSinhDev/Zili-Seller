part of '../ui_notification_provider.dart';

class _CheckoutFailed extends StatelessWidget {
  const _CheckoutFailed();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Lottie.asset(
            AppConstant.animations.failed,
            height: 220.h,
            fit: BoxFit.fill,
          ),
          Text(
            'Đặt hàng không thành công!',
            style: AppStyles.text.semiBold(fSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          height(height: 6),
          Text(
            'Hệ thống đang xãy ra lỗi, vui lòng liên hệ chúng tôi để xử lý, xin cảm ơn.',
            style: AppStyles.text.medium(fSize: 12.sp, height: 1.28.sp),
            textAlign: TextAlign.center,
          ),
          height(height: 20),
          CustomButtonWidget(
            onTap: () => context.navigator.popUntil((route) => route.isFirst),
            radius: 48.r,
            color: AppColors.white,
            height: 44.h,
            padding: const EdgeInsets.all(0),
            boxShadows: const [],
            borderColor: AppColors.black,
            labelColor: AppColors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset(
                    AppConstant.svgs.icArrowLeftCircle,
                  ),
                ),
                width(width: 5),
                Text(
                  'Quay về trang chủ',
                  style: AppStyles.text.semiBold(
                    fSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
                width(width: 16),
              ],
            ),
          ),
          height(height: 20),
          InkWell(
            onTap: () => context.navigator.pop(),
            child: Text(
              'Thực hiện lại',
              style: AppStyles.text
                  .semiBold(fSize: 14.sp)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}