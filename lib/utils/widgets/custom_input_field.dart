import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';

class CustomInputFieldWidget extends StatefulWidget {
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final String hint;
  final TextInputType? type;
  final bool obscure;
  final TextInputAction textInputAction;
  final TextCapitalization? textCapitalization;
  final String label;
  final TextStyle? customStyleLabel;
  final TextStyle? customStyleInput;
  final TextStyle? customStyleHint;
  final Color? color;
  final Widget? suffixIcon;
  final double? radius;
  final double? height;
  final String? notify;
  final FocusNode? focusNode;
  final bool? autofocus;
  final String? text;
  final double bottomSpace;
  final Function()? onTap;

  const CustomInputFieldWidget({
    super.key,
    this.onSubmitted,
    this.onChanged,
    this.obscure = false,
    this.textCapitalization,
    this.textInputAction = TextInputAction.next,
    required this.hint,
    this.type,
    required this.label,
    this.customStyleLabel,
    this.customStyleInput,
    this.customStyleHint,
    this.color,
    this.suffixIcon,
    this.radius,
    this.height,
    this.notify,
    this.focusNode,
    this.autofocus,
    this.text,
    this.bottomSpace = 25,
    this.onTap,
  });

  @override
  State<CustomInputFieldWidget> createState() => _CustomInputFieldWidgetState();
}

class _CustomInputFieldWidgetState extends State<CustomInputFieldWidget> {
  late bool showPassword;
  late final TextEditingController controller;
  final textStyle = AppStyles.text.medium(
    fSize: 16.sp,
    color: AppColors.primary,
  );

  @override
  void initState() {
    controller = TextEditingController(text: widget.text ?? "");
    showPassword = widget.obscure;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .start,
      children: [
        Text(widget.label, style: widget.customStyleLabel ?? textStyle),
        height(height: 8),
        InkWell(
          onTap: widget.onTap,
          child: Container(
            height: widget.height ?? 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius ?? 14.r),
              border: Border.all(
                color: widget.color ?? AppColors.primary,
                width: 1.5.r,
              ),
              color: AppColors.white,
            ),
            child: TextField(
              autofocus: widget.autofocus ?? false,
              focusNode: widget.focusNode,
              cursorColor: AppColors.primary,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              // readOnly: widget.onTap != null,
              enabled: widget.onTap == null,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,
              controller: controller,
              keyboardType: widget.type,
              textInputAction: widget.textInputAction,
              obscureText: showPassword,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  top: widget.obscure ? 2.h : 0,
                  left: 20.w,
                ),
                hintText: widget.hint,
                suffixIcon: widget.suffixIcon != null
                    ? Container(
                        margin: EdgeInsets.only(right: 20.w),
                        child: widget.suffixIcon!,
                      )
                    : widget.obscure
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20.w),
                          child: SvgPicture.asset(
                            showPassword
                                ? AssetIcons.iEyeOffSvg
                                : AssetIcons.iEyeSvg,
                          ),
                        ),
                      )
                    : null,
                suffixIconConstraints: BoxConstraints(
                  maxWidth: 48.w,
                  maxHeight: 48.w,
                ),
                hintStyle:
                    widget.customStyleHint ??
                    widget.customStyleInput?.copyWith(color: AppColors.grey) ??
                    textStyle.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
              ),
              style: widget.customStyleInput ?? textStyle,
            ),
          ),
        ),
        height(
          height: widget.bottomSpace,
          child: widget.notify != null
              ? Row(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4.w),
                      margin: EdgeInsets.only(top: 6.h),
                      child: Text(
                        widget.notify ?? '',
                        style: AppStyles.text.medium(
                          fSize: 11.sp,
                          color: AppColors.scarlet,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ],
    );
  }
}
