part of '../change_password_screen.dart';

class _UINotificationFailed extends StatelessWidget {
  final FailedCustomerState state;
  const _UINotificationFailed({required this.state});

  @override
  Widget build(BuildContext context) {
    return UINotificationProvider.custom(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(height: 14.h),
          Text(
            'Thất bại',
            style: AppStyles.text.semiBold(
              fSize: 16.sp,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.start,
          ),
          height(height: 20.h),
          Text(
            _contentNotificationFailedState(state),
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
                onTap: () {},
                radius: 48.r,
                color: AppColors.white,
                width: 140.w,
                height: 40.h,
                boxShadows: const [],
                child: Center(
                  child: Text(
                    "Quên mật khẩu?",
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
                width: 100.w,
                height: 40.h,
                borderColor: AppColors.primary,
                color: AppColors.primary,
                boxShadows: const [],
                child: Center(
                  child: Text(
                    "Đóng",
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

  String _contentNotificationFailedState(FailedCustomerState state) {
    if (state.error.errorMessage == AppConstant.strings.samePasssword) {
      return "Mật khẩu mới không được trùng với mật khẩu cũ. Vui lòng kiểm tra lại mật khẩu đã nhập!";
    }
    if (state.error.errorMessage == AppConstant.strings.invalidPasssword) {
      return "Mật khẩu không chính xác. Vui lòng kiểm tra lại mật khẩu!";
    }
    return state.error.errorMessage;
  }
}
