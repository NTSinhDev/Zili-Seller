import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';

/// Shared form input used across modules.
/// Giữ UX/validation đồng bộ với các màn đã dùng (vd. customer/create),
/// tránh tự ý thay đổi hành vi, màu, hiển thị lỗi khác biệt trên cùng component.
class InputFormField extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormFieldState> formFieldKey;
  final String label;
  final String? hint;
  final TextInputType? type;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color? bgColor;
  final int? maxLines;
  final FocusNode? focusNode;
  final Widget? suffix;
  final EdgeInsetsGeometry? suffixPadding;
  final bool obscureText;
  const InputFormField({
    super.key,
    required this.controller,
    required this.formFieldKey,
    required this.label,
    this.hint,
    this.type,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.maxLines,
    this.bgColor,
    this.focusNode,
    this.suffix,
    this.suffixPadding,
    this.obscureText = false,
  });

  static TextStyle get labelStyle =>
      AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84);

  static TextStyle get hintStyle =>
      AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey84);

  static InputBorder get focusedBorder => OutlineInputBorder(
    borderRadius: .circular(8.r),
    borderSide: const BorderSide(color: AppColors.primary),
  );

  static InputBorder get border => OutlineInputBorder(
    borderRadius: .circular(8.r),
    borderSide: const BorderSide(color: AppColors.greyC0),
  );

  static EdgeInsets get contentPadding => .symmetric(horizontal: 16.w);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formFieldKey,
      autofocus: false,
      focusNode: focusNode,
      controller: controller,
      autovalidateMode: .onUserInteraction,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        labelText: label,
        filled: (bgColor != null) ? true : false,
        fillColor: bgColor,
        isDense: true,
        hintText: hint ?? label,
        alignLabelWithHint: maxLines != null && maxLines! > 1,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        hintStyle: hintStyle,
        labelStyle: labelStyle.copyWith(
          color: controller.text.isNotEmpty
              ? AppColors.black3
              : AppColors.grey84,
        ),
        suffixIcon: suffix != null
            ? Padding(
                padding: suffixPadding ?? EdgeInsets.only(right: 8.w),
                child: suffix,
              )
            : null,
        suffixIconConstraints: BoxConstraints(
          minHeight: 0,
          minWidth: 0,
          maxHeight: 40.h,
        ),
      ),
      keyboardType: type ?? .text,
      validator: validator ?? (String? value) => null,
      textInputAction: textInputAction ?? .next,
      inputFormatters: inputFormatters ?? [],
      onChanged: (value) => onChanged?.call(value),
      maxLines: maxLines ?? 1,
      obscureText: obscureText,
    );
  }
}
