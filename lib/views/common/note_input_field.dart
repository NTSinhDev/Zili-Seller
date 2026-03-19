import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';
import '../../utils/extension/extension.dart';

class NoteInputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  const NoteInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.maxLines = 4,
  });
  final int? maxLines;

  TextStyle get labelStyle =>
      AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3);
  TextStyle get hintStyle =>
      AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey84);
  InputBorder get focusedBorder => OutlineInputBorder(
    borderRadius: .circular(8.r),
    borderSide: const BorderSide(color: AppColors.primary),
  );
  InputBorder get border => OutlineInputBorder(
    borderRadius: .circular(8.r),
    borderSide: const BorderSide(color: AppColors.greyC0),
  );
  EdgeInsets get contentPadding => .symmetric(horizontal: 16.w, vertical: 0);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      style: AppStyles.text.medium(fSize: 14.sp),
      onTapOutside: (event) => context.focus.unfocus(),
      textInputAction: TextInputAction.newline,
      autofocus: false,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        alignLabelWithHint: true,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        contentPadding: .all(12.w),
      ),
    );
  }
}
