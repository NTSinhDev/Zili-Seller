part of '../register_screen.dart';

class _FormInput extends StatefulWidget {
  final Function(String) onInputName;
  final Function(String) onInputEmail;
  final Function(String) onInputPassword;
  final Function() register;
  const _FormInput({
    required this.onInputEmail,
    required this.onInputPassword,
    required this.register,
    required this.onInputName,
  });

  @override
  State<_FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<_FormInput> {
  bool validateFullName = true;
  bool validateEmail = true;
  bool validatePassword = true;
  String validatorPassword = 'Mật khẩu phải bắt đầu bằng kí tự in hoa';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomInputFieldWidget(
          label: 'Số điện thoại',
          hint: 'Nhập số điện thoại',
          type: TextInputType.emailAddress,
          // color: !validateEmail ? AppColors.red : null,
          // notify: !validateEmail ? 'Email không đúng định dạng!' : null,
          onChanged: (input) {
            // final result = Validator.validateEmail(input);
            // if (result != validateEmail) {
            //   setState(() {
            //     validateEmail = result;
            //   });
            // }
            // if (validateEmail) {
            //   widget.onInputEmail(input);
            // } else {
            //   widget.onInputEmail('');
            // }
          },
        ),
        CustomInputFieldWidget(
          label: 'Mật khẩu',
          hint: 'Nhập mật khẩu',
          type: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          // color: !validateFullName ? AppColors.red : null,
          // notify: !validateFullName
          //     ? 'Không được chứa số hoặc kí tự đặc biệt!'
          //     : null,
          onChanged: (input) {
            // final result = Validator.validateName(input);
            // if (result != validateFullName) {
            //   setState(() {
            //     validateFullName = result;
            //   });
            // }
            // if (validateFullName) {
            //   widget.onInputName(input);
            // } else {
            //   widget.onInputName('');
            // }
          },
        ),
        CustomInputFieldWidget(
          label: 'Xác nhận mật khẩu',
          hint: 'Nhập lại mật khẩu',
          type: TextInputType.visiblePassword,
          textInputAction: TextInputAction.send,
          // color: !validatePassword ? AppColors.red : null,
          // notify: !validatePassword ? validatorPassword : null,
          obscure: true,
          onChanged: (input) {
            // final result = input.length > 5 && input.length < 26;
            // if (result != validatePassword) {
            //   setState(() {
            //     validatePassword = result;
            //   });
            // }
            // if (validatePassword) {
            //   widget.onInputPassword(input);
            // } else {
            //   _setValidatorPassword(input);
            //   widget.onInputPassword('');
            // }
          },
          onSubmitted: (p0) => widget.register(),
        ),
      ],
    );
  }

  // _setValidatorPassword(String password) {
  //   if (password.length < 6) {
  //     setState(() {
  //       validatorPassword = 'Mật khẩu phải có tối thiểu 6 kí tự!';
  //     });
  //   } else if (password.length > 25) {
  //     setState(() {
  //       validatorPassword = 'Mật khẩu phải có tối thiểu 25 kí tự!';
  //     });
  //   }
  // }
}
