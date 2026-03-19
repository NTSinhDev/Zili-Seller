part of '../login_screen.dart';

class _FormInput extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;
  final Function(String) onInputEmail;
  final Function(String) onInputPassword;
  final Function() login;
  const _FormInput({
    required this.onInputEmail,
    required this.onInputPassword,
    required this.login,
    this.initialPassword,
    this.initialEmail,
  });

  @override
  State<_FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<_FormInput> {
  bool validateEmail = true;
  String validatorPassword = '';

  @override
  Widget build(BuildContext context) {
    // todo: Tạo form điều hỉnh lại input để thực hiện validate cho 2 field sau
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .stretch,
      children: [
        CustomInputFieldWidget(
          label: 'Email',
          hint: 'Đăng nhập Email của bạn',
          type: TextInputType.emailAddress,
          text: widget.initialEmail,
          color: !validateEmail ? AppColors.red : null,
          notify: !validateEmail ? 'Email không đúng định dạng!' : null,
          onChanged: (input) {
            final result = Validator.validateEmail(input);
            if (result != validateEmail) {
              setState(() {
                validateEmail = result;
              });
            }
            if (validateEmail) {
              widget.onInputEmail(input);
            } else {
              widget.onInputEmail('');
            }
          },
        ),
        CustomInputFieldWidget(
          label: 'Mật khẩu',
          hint: 'Đăng nhập mật khẩu của bạn',
          type: TextInputType.visiblePassword,
          textInputAction: TextInputAction.send,
          text: widget.initialPassword,
          obscure: true,
          color: validatorPassword.isNotEmpty ? AppColors.red : null,
          notify: validatorPassword.isNotEmpty ? validatorPassword : null,
          onChanged: (password) {
            // if (password.length < 6 || password.length > 25) {
            //   widget.onInputPassword('');
            //   setState(() {
            //     validatorPassword = _setValidatorPassword(password);
            //   });
            // } else {
            widget.onInputPassword(password);
            // setState(() {
            //   validatorPassword = '';
            // });
            // }
          },
          onSubmitted: (p0) => widget.login(),
          bottomSpace: 16,
        ),
        Row(
          mainAxisAlignment: .end,
          crossAxisAlignment: .start,
          children: [
            InkWell(
              onTap: () => context.navigator.pushNamed(
                ForgotPasswordScreen.keyName,
                arguments: NavArgsKey.fromLogin,
              ),
              child: Text(
                'Quên mật khẩu?',
                style: AppStyles.text
                    .medium(fSize: 14.sp, color: AppColors.primary)
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ],
    );
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
