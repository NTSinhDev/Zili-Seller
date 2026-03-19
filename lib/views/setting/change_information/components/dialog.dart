part of '../change_information_screen.dart';

class _CustomUIDialog extends StatelessWidget {
  final String label;
  final String message;
  const _CustomUIDialog({required this.label, required this.message});

  @override
  Widget build(BuildContext context) {
    return UINotificationProvider.custom(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(height: 14.h),
          Text(
            label,
            style: AppStyles.text.semiBold(
              fSize: 16.sp,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.start,
          ),
          height(height: 20.h),
          Text(
            message,
            style: AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.primary,
              height: 1.3,
            ),
            textAlign: TextAlign.start,
          ),
          height(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButtonWidget(
                onTap: () {
                  context.navigator.popUntil((route) => route.isFirst);
                },
                radius: 48.r,
                color: AppColors.white,
                width: 120.w,
                height: 40.h,
                boxShadows: const [],
                child: Center(
                  child: Text(
                    'Thoát',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              width(width: 12),
              CustomButtonWidget(
                onTap: () => context.navigator.pop(),
                radius: 48.r,
                width: 120.w,
                height: 40.h,
                borderColor: AppColors.primary,
                color: AppColors.primary,
                boxShadows: const [],
                child: Center(
                  child: Text(
                    'Tiếp tục',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
