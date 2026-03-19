part of '../login_screen.dart';

class _SocialAuthentication extends StatelessWidget {
  final AuthCubit authCubit;
  const _SocialAuthentication({required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Divider(color: AppColors.primary, height: 1.h)),
            width(width: 6),
            Text(
              'Hoặc đăng nhập bằng'.toUpperCase(),
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
            width(width: 6),
            Expanded(child: Divider(color: AppColors.primary, height: 1.h)),
          ],
        ),
        height(height: 25),
        Row(
          children: [
            Expanded(
              child: CustomButtonWidget(
                // onTap: () async => await authCubit.googleSignIn(),
                radius: 60.r,
                color: AppColors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppConstant.svgs.logoGoogle),
                    width(width: 10),
                    Text(
                      'Google',
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
              ),
            ),
            width(width: 20),
            Expanded(
              child: CustomButtonWidget(
                // onTap: () async => await authCubit.facebookSignIn(),
                radius: 60.r,
                color: AppColors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppConstant.svgs.logoFacebook),
                    width(width: 10),
                    Text(
                      'Facebook',
                      style: AppStyles.text.semiBold(
                        fSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
