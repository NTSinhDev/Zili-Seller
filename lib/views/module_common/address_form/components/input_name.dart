import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/validator.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class InputName extends StatefulWidget {
  final String? name;
  final String? hint;
  final String? label;
  final Function(String) changedName;
  const InputName({
    super.key,
    this.name,
    required this.changedName,
    this.hint,
    this.label,
  });

  @override
  State<InputName> createState() => _InputNameState();
}

class _InputNameState extends State<InputName> {
  bool validate = true;
  String validator = '';
  @override
  Widget build(BuildContext context) {
    return CustomInputFieldWidget(
      hint: widget.name ?? widget.hint ?? '',
      label: widget.label ?? 'Họ và tên',
      text: widget.name,
      color: !validate ? AppColors.red : AppColors.black,
      notify: !validate ? validator : null,
      onChanged: (name) {
        final result = Validator.validateName(name);
        if (result != validate) {
          setState(() {
            validate = result;
          });
        }

        if (validate) {
          widget.changedName(name);
        } else {
          _setValidator(name);
          widget.changedName('');
        }
      },
      textCapitalization: TextCapitalization.words,
      customStyleLabel: AppStyles.text.medium(fSize: 16.sp),
      customStyleInput: AppStyles.text.medium(fSize: 14.sp),
    );
  }

  void _setValidator(String name) {
    if (name.isEmpty) {
      setState(() {
        validator = 'Không được để trống!';
      });
    }else{
      setState(() {
        validator = 'Không được chứa số hoặc kí tự đặc biệt!';
      });
    }
  }
}
