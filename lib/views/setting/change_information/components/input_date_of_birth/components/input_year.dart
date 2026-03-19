part of '../../../change_information_screen.dart';

class _InputYear extends StatefulWidget {
  final Function(String) onChangedYear;
  final FocusNode focusNode;
  final String? value;
  final Function(FocusNode currentNode) whenUnfocus;
  const _InputYear({
    required this.onChangedYear,
    required this.focusNode,
    this.value,
    required this.whenUnfocus,
  });

  @override
  State<_InputYear> createState() => _InputYearState();
}

class _InputYearState extends State<_InputYear> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
    controller.addListener(_resetInput);
  }

  @override
  void dispose() {
    controller.removeListener(_resetInput);
    controller.dispose();
    super.dispose();
  }

  void _resetInput() {
    if (controller.text.length > 4) {
      final lastword = controller.text[4];
      controller.clear();
      controller.text = lastword;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LayoutInput(
      onChanged: (input) {
        // Case: nhập đủ 2 số
        final digits = input.replaceAll(RegExp('[^0-9]'), '');
        if (digits.length < 4) return;

        widget.onChangedYear(digits);
        FocusScope.of(context).unfocus();
        controller.text = digits;
      },
      whenUnfocus: (currentNode) {
        if (controller.value.text.isEmpty) {
          widget.whenUnfocus(currentNode);
        }
      },
      onSubmitted: (p0) => FocusScope.of(context).unfocus(),
      controller: controller,
      hint: 'yyyy',
      width: 34.w,
      focusNode: widget.focusNode,
      type: TextInputAction.done,
    );
  }
}
