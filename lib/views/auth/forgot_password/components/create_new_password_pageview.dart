part of '../forgot_password_screen.dart';

class _CreateNewPasswordPageView extends StatefulWidget {
  final String code;
  const _CreateNewPasswordPageView({required this.code});

  @override
  State<_CreateNewPasswordPageView> createState() =>
      _CreateNewPasswordPageViewState();
}

class _CreateNewPasswordPageViewState
    extends State<_CreateNewPasswordPageView> {
  String newPassword = '';
  String verifyPassword = '';
  final authCubit = di<AuthCubit>();
  // UI
  String validatorNewPassword = '';
  String validatorVerifyPassword = '';
  final FocusNode focusNodeNewPassword = FocusNode();
  final FocusNode focusNodeVerifyPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (context, state) {
        if (state is ForgotPasswordState) {
          if (state.step == ForgotPasswordSteps.error) {
            context.showNotificationDialog(
              message: state.message!,
              cancelWidget: Container(),
              action: "Đóng",
            );
          }
        } else if (state is HasBeenChangedPasswordState) {
          context.navigator.pop();
        } else if (state is AuthFailedState) {
          context.showNotificationDialog(
            message: state.error.errorMessage,
            cancelWidget: Container(),
            action: "Đóng",
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height(height: 74),
          Text(
            'TẠO MẬT KHẨU MỚI',
            style: AppStyles.text.bold(
              fSize: 23.sp,
              color: AppColors.primary,
            ),
          ),
          height(height: 9),
          SizedBox(
            width: Spaces.screenWidth(context) - 40.w,
            child: Text(
              'Mật khẩu mới của bạn phải khác với mật khẩu đã sử dụng trước đó',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.primary,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          height(height: 26),
          Container(
            padding: EdgeInsets.all(53.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: SvgPicture.asset(AppConstant.svgs.icCreateNewPassword),
          ),
          height(height: 26),
          width(
            width: Spaces.screenWidth(context) - 40.w,
            child: CustomInputFieldWidget(
              focusNode: focusNodeNewPassword,
              label: 'Mât khẩu',
              hint: 'Hãy nhập mật khẩu mới của bạn',
              obscure: true,
              textInputAction: TextInputAction.send,
              color: validatorNewPassword.isNotEmpty ? AppColors.red : null,
              notify:
                  validatorNewPassword.isNotEmpty ? validatorNewPassword : null,
              onChanged: (password) {
                if (password.length < 6 || password.length > 25) {
                  newPassword = '';
                  setState(() {
                    validatorNewPassword = _setValidatorPassword(password);
                  });
                } else {
                  newPassword = password;
                  setState(() {
                    validatorNewPassword = '';
                  });
                }
              },
              onSubmitted: (p) {
                focusNodeNewPassword.unfocus();
                focusNodeVerifyPassword.requestFocus();
              },
            ),
          ),
          height(height: 25),
          width(
            width: Spaces.screenWidth(context) - 40.w,
            child: CustomInputFieldWidget(
              focusNode: focusNodeVerifyPassword,
              label: 'Nhập lại mật khẩu',
              hint: 'Nhập lại mật khẩu để xác nhận',
              obscure: true,
              textInputAction: TextInputAction.send,
              color: validatorVerifyPassword.isNotEmpty ? AppColors.red : null,
              notify: validatorVerifyPassword.isNotEmpty
                  ? validatorVerifyPassword
                  : null,
              onChanged: (input) {
                if (input == newPassword) {
                  setState(() {
                    validatorVerifyPassword = '';
                  });
                  verifyPassword = input;
                } else {
                  setState(() {
                    validatorVerifyPassword = 'Mật khẩu không chính xác!';
                  });
                  verifyPassword = '';
                }
              },
              onSubmitted: (p) => _handleCreateNewPassword(),
            ),
          ),
          height(height: 42),
          width(
            width: Spaces.screenWidth(context) - 40.w,
            child: CustomButtonWidget(
              label: 'XÁC NHẬN MẬT KHẨU',
              onTap: _handleCreateNewPassword,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCreateNewPassword() {
    if (newPassword.isEmpty || verifyPassword.isEmpty || widget.code.isEmpty) {
      return;
    }
    authCubit.createNewPassword(newPassword: newPassword, code: widget.code);
  }

  String _setValidatorPassword(String password) {
    if (password.length < 6) {
      return 'Mật khẩu phải có tối thiếu 6 kí tự';
    }
    if (password.length > 25) {
      return 'Mật khẩu có tối đa 25 kí tự!';
    }
    return '';
  }
}
