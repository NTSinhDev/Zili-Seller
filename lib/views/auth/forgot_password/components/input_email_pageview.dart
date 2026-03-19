part of '../forgot_password_screen.dart';

class _InputEmailPageView extends StatefulWidget {
  final Function(String email, String message) next;
  const _InputEmailPageView({required this.next});
  @override
  State<_InputEmailPageView> createState() => _InputEmailPageViewState();
}

class _InputEmailPageViewState extends State<_InputEmailPageView> {
  final AuthCubit authCubit = di<AuthCubit>();
  String email = '';

  @override
  initState() {
    super.initState();
    email = kDebugMode ? 'xkhr.nhanvienkythuat@wstore.vn' : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (_, state) {
        if (state is AuthProcessingState) {
          context.showLoading(message: 'Đang xử lý...');
        } else {
          context.hideLoading();
        }

        if (state is ForgotPasswordState) {
          if (state.step == .verifyCode) {
            widget.next(email, state.message ?? '');
          } else if (state.step == .error) {
            CustomSnackBarWidget(
              context,
              type: .error,
              message: state.message!,
            ).show();
          }
        } else if (state is AuthFailedState) {
          CustomSnackBarWidget(
            context,
            type: .error,
            message: state.error.errorMessage,
          ).show();
        }
      },
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .center,
        children: [
          height(height: 74),
          Text(
            'QUÊN MẬT KHẨU',
            style: AppStyles.text.bold(fSize: 23.sp, color: AppColors.primary),
          ),
          height(height: 9),
          SizedBox(
            width: Spaces.screenWidth(context) - 40.w,
            child: Text(
              'Vui lòng nhập Địa chỉ Email của bạn chúng tôi sẽ gửi bạn mã Code xác nhận qua Email của bạn',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.primary,
                height: 1.08,
              ),
              textAlign: TextAlign.center,
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
          height(height: 26),
          width(
            width: Spaces.screenWidth(context) - 40.w,
            child: CustomInputFieldWidget(
              text: kDebugMode ? 'xkhr.nhanvienkythuat@wstore.vn' : '',
              autofocus: true,
              label: 'Email',
              hint: 'Đăng nhập Email của bạn',
              type: TextInputType.emailAddress,
              onChanged: (email) => setState(() => this.email = email),
              onSubmitted: (_) => _handleSubmitted(),
            ),
          ),
          height(height: 42),
          width(
            width: Spaces.screenWidth(context) - 40.w,
            child: CustomButtonWidget(
              label: 'GỬI NGAY',
              onTap: _handleSubmitted,
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
      ),
    );
  }

  void _handleSubmitted() async {
    if (email.trim().isEmpty) return;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    authCubit.forgotPassword(email: email);
  }
}
