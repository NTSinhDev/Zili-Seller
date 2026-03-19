part of '../home_screen.dart';

void _lostAccount(BuildContext context) {
    context.showCustomDialog(
      height: 140.h,
      barrierColor: Colors.black38,
      canDismiss: true,
      backgroundColor: AppColors.white,
      child: UINotificationProvider.custom(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(height: 14.h),
            Text(
              'Thông báo',
              style: AppStyles.text.semiBold(
                fSize: 16.sp,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.start,
            ),
            height(height: 20.h),
            Text(
              "Tài khoản của bạn đã bị xóa ở nơi khác!",
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
                  onTap: () => context.navigator.popAndPushNamed(
                    RegisterScreen.keyName,
                    arguments: NavArgsKey.fromHome,
                  ),
                  radius: 48.r,
                  color: AppColors.white,
                  width: 160.w,
                  height: 40.h,
                  boxShadows: const [],
                  child: Center(
                    child: Text(
                      'Đăng ký tài khoản',
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
                  width: 80.w,
                  height: 40.h,
                  borderColor: AppColors.primary,
                  color: AppColors.primary,
                  boxShadows: const [],
                  child: Center(
                    child: Text(
                      'Đóng',
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
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    context.showCustomDialog(
      height: 140.h,
      barrierColor: Colors.black12,
      canDismiss: false,
      backgroundColor: AppColors.white,
      child: UINotificationProvider.custom(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            height(height: 14.h),
            Text(
              'Thông báo',
              style: AppStyles.text.semiBold(
                fSize: 16.sp,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.start,
            ),
            height(height: 20.h),
            Text(
              "Bạn muốn thoát ứng dụng?",
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
                  onTap: () => context.navigator.pop(),
                  radius: 48.r,
                  width: 100.w,
                  height: 40.h,
                  borderColor: AppColors.primary,
                  color: AppColors.primary,
                  boxShadows: const [],
                  child: Center(
                    child: Text(
                      'Ở lại',
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                width(width: 12),
                CustomButtonWidget(
                  onTap: () => exit(0),
                  radius: 48.r,
                  color: AppColors.white,
                  width: 140.w,
                  height: 40.h,
                  boxShadows: const [],
                  child: Center(
                    child: Text(
                      'Thoát ứng dụng',
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return false;
  }