
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/validator.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class InputEmail extends StatefulWidget {
  final String? email;
    final String? hint;
  final Function(String) changedEmail;
  const InputEmail({super.key, this.email, required this.changedEmail, this.hint});

  @override
  State<InputEmail> createState() => __InputEmailState();
}

class __InputEmailState extends State<InputEmail> {
  bool validate = true;
  @override
  Widget build(BuildContext context) {
    return CustomInputFieldWidget(
      hint: widget.email ?? widget.hint??"",
      label: 'Email',
      text: widget.email,
      color: !validate ? AppColors.red : AppColors.black,
      notify: !validate ? 'Email không đúng định dạng!' : null,
      onChanged: (email) {
        final result = Validator.validateEmail(email);
        if (result != validate) {
          setState(() {
            validate = result;
          });
        }

        if (validate) {
          widget.changedEmail(email);
        } else {
          widget.changedEmail('');
        }
      },
      type: TextInputType.emailAddress,
      customStyleLabel: AppStyles.text.medium(fSize: 16.sp),
      customStyleInput: AppStyles.text.medium(fSize: 14.sp),
    );
  }
}
