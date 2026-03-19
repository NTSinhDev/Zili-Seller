import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/validator.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class InputPhone extends StatefulWidget {
  final String? phone;
  final String? hint;
  final String? label;

  final Function(String) changedPhone;
  const InputPhone({
    super.key,
    this.phone,
    required this.changedPhone,
    this.hint,
    this.label,
  });

  @override
  State<InputPhone> createState() => _InputPhoneState();
}

class _InputPhoneState extends State<InputPhone> {
  bool validate = true;
  String validator = '';

  @override
  Widget build(BuildContext context) {
    return CustomInputFieldWidget(
      hint: widget.phone ?? widget.hint ?? '',
      label: widget.label ?? 'Số điện thoại',
      text: widget.phone,
      color: !validate ? AppColors.red : AppColors.black,
      notify: !validate ? validator : null,
      onChanged: (phone) {
        final result = Validator.validatePhone(phone);
        if (result != validate) {
          setState(() {
            validate = result;
          });
        }

        if (validate) {
          widget.changedPhone(phone);
        } else {
          _setValidator(phone);
          widget.changedPhone('');
        }
      },
      type: TextInputType.phone,
      customStyleLabel: AppStyles.text.medium(fSize: 16.sp),
      customStyleInput: AppStyles.text.medium(fSize: 14.sp),
    );
  }

  void _setValidator(String phone) {
    if (phone.isEmpty) {
      setState(() {
        validator = 'Không được để trống!';
      });
    } else {
      setState(() {
        validator = 'Số điện thoại không đúng!';
      });
    }
  }
}
