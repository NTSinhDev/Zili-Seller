part of '../forgot_password_screen.dart';

class _TurnBackToLoginPageView extends StatelessWidget {
  const _TurnBackToLoginPageView();

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      children: [
        height(height: 74),
        Text(
          'QUÊN MẬT KHẨU',
          style: AppStyles.text.bold(fSize: 23.sp, color: AppColors.primary),
        ),
        height(height: 9),
        height(height: 26),
        SizedBox(
          width: Spaces.screenWidth(context) - 40.w,
          child: Text(
            'Chúng tôi đã gửi mật khẩu mới đến email của bạn.',
            style: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: AppColors.primary,
              height: 1.4,
            ),
            textAlign: .start,
          ),
        ),
        height(height: 4),
        SizedBox(
          width: Spaces.screenWidth(context) - 40.w,
          child: Text(
            'Vui lòng kiểm tra Email để nhận thông tin mật khẩu mới được thay đổi.',
            style: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: AppColors.primary,
              height: 1.4,
            ),
            textAlign: .start,
          ),
        ),
        height(height: 12),
        SizedBox(
          width: Spaces.screenWidth(context) - 40.w,
          child: Text(
            'Cảm ơn bạn!',
            style: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: AppColors.primary,
              height: 1.4,
            ),
            textAlign: .start,
          ),
        ),
        height(height: 26),
        Container(
          padding: EdgeInsets.all(53.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: SvgPicture.asset(AssetIcons.iLockLargeSvg),
        ),
        height(height: 42),
        width(
          width: Spaces.screenWidth(context) - 40.w,
          child: CustomButtonWidget(
            label: 'Đăng nhập'.toUpperCase(),
            onTap: context.navigator.pop,
          ),
        ),
        const Spacer(),
        // InkWell(
        //   onTap: () {
        //     // Navigate to login screen
        //     context.navigator
        //       ..pop
        //       // Replace login screen by register screen
        //       ..context
        //           .navigator
        //           .pushReplacementNamed(RegisterScreen.keyName);
        //   },
        //   child: RichText(
        //     text: TextSpan(
        //       style: AppStyles.text
        //           .medium(fSize: 14.sp, color: AppColors.primary),
        //       children: [
        //         const TextSpan(text: 'Bạn chưa có tài khoản?\t'),
        //         TextSpan(
        //           text: 'Đăng Ký',
        //           style: AppStyles.text
        //               .semiBold(
        //                 fSize: 14.sp,
        //                 color: AppColors.primary,
        //                 height: 1.18,
        //               )
        //               .copyWith(decoration: TextDecoration.underline),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
