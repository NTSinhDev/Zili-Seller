part of '../ui_notification_provider.dart';

class _Unauthentication extends StatelessWidget {
  final String content;
  final Object passArgsToAuthScreen;
  const _Unauthentication({
    required this.content,
    required this.passArgsToAuthScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          color: Colors.transparent,
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
                content,
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
                      context.navigator.pop();
                      context.navigator.pushNamed(
                        RegisterScreen.keyName,
                        arguments: passArgsToAuthScreen,
                      );
                    },
                    radius: 48.r,
                    width: 120.w,
                    height: 40.h,
                    borderColor: AppColors.primary,
                    color: AppColors.primary,
                    boxShadows: const [],
                    child: Center(
                      child: Text(
                        'Đăng ký',
                        style: AppStyles.text.semiBold(
                          fSize: 14.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  width(width: 12),
                  CustomButtonWidget(
                    onTap: () {
                      context.navigator.pop();
                      context.navigator.pushNamed(
                        LoginScreen.keyName,
                        arguments: passArgsToAuthScreen,
                      );
                    },
                    radius: 48.r,
                    color: AppColors.white,
                    width: 120.w,
                    height: 40.h,
                    boxShadows: const [],
                    child: Center(
                      child: Text(
                        'Đăng nhập',
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
        _Background(top: -25.h, left: -25.w, size: 136.w, opacity: 0.1),
        _Background(top: 4.h, left: 120.w, size: 30.w, opacity: 0.15),
        _Background(top: 1.h, left: 105.w, size: 16.w, opacity: 0.15),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () => context.navigator.pop(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.r),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6.r,
                    color: AppColors.primary.withOpacity(0.75),
                    offset: const Offset(2.5, 2.5),
                  )
                ],
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.white,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
