part of '../../../change_information_screen.dart';

class _LayoutInput extends StatelessWidget {
  final String hint;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final Function(FocusNode) whenUnfocus;
  final double? width;
  final TextInputAction? type;

  const _LayoutInput({
    required this.onChanged,
    required this.hint,
    this.width,
    required this.focusNode,
    this.onSubmitted,
    required this.controller,
    this.type,
    required this.whenUnfocus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 24.w,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event.runtimeType == RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            whenUnfocus(focusNode);
          }
        },
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          cursorColor: AppColors.primary,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          keyboardType: TextInputType.phone,
          textInputAction: type ?? TextInputAction.next,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(0),
            hintText: hint,
            hintStyle: _textInputStyle.copyWith(color: AppColors.grey),
          ),
          style: _textInputStyle,
        ),
      ),
    );
  }
}
