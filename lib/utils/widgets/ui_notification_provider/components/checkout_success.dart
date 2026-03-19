part of '../ui_notification_provider.dart';

class _CheckoutSuccess extends StatelessWidget {
  const _CheckoutSuccess();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Lottie.asset(
            AppConstant.animations.success,
            height: 220.h,
            fit: BoxFit.fill,
          ),
          Text(
            'Đặt hàng thành công!',
            style: AppStyles.text.semiBold(
              fSize: 16.sp,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          height(height: 6),
          Text(
            'Đơn hàng của bạn đã được đặt thành công, vui lòng kiểm tra lại đơn hàng!',
            style: AppStyles.text.medium(
              fSize: 12.sp,
              color: AppColors.primary,
              height: 1.18.sp,
            ),
            textAlign: TextAlign.center,
          ),
          height(height: 20),
          CustomButtonWidget(
            onTap: () {
              context.navigator.popUntil((route) => route.isFirst);
              // context.navigator.pushNamed(OrderDetailScreen.keyName);
            },
            radius: 48.r,
            color: AppColors.white,
            height: 44.h,
            padding: const EdgeInsets.all(0),
            boxShadows: const [],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset(AppConstant.svgs.icArrowLeftCircle),
                ),
                width(width: 5),
                Text(
                  'Đến đơn hàng của tôi',
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
            onTap: () => context.navigator.popUntil((route) => route.isFirst),
            child: Text(
              'Về trang chủ',
              style: AppStyles.text
                  .semiBold(fSize: 14.sp, color: AppColors.primary)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
