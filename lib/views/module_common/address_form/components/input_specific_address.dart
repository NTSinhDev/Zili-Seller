import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class InputSpecificAddress extends StatelessWidget {
  final String? address;
  final Function(String) changedSpecificAddress;
  const InputSpecificAddress({
    super.key,
    required this.changedSpecificAddress,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return MultilineInputFieldWidget(
      hint: address ?? 'Nhập địa chỉ cụ thể',
      label: 'Địa chỉ nhận hàng*',
      text: address,
      onChanged: (value) {
        changedSpecificAddress(value);
      },
      textStyle: AppStyles.text.medium(fSize: 16.sp),
      hintColor: AppColors.grey,
      radius: 15.r,
    );
  }
}
