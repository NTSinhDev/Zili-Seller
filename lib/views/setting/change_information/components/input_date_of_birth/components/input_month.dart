part of '../../../change_information_screen.dart';

class _InputMonth extends StatefulWidget {
  final Function(String) onChangedMonth;
  final FocusNode focusNode;
  final String? value;
  final Function(FocusNode currentNode) whenUnfocus;
  const _InputMonth({
    required this.onChangedMonth,
    required this.focusNode,
    this.value,
    required this.whenUnfocus,
  });

  @override
  State<_InputMonth> createState() => _InputMonthState();
}

class _InputMonthState extends State<_InputMonth> {
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
    if (controller.text.length > 2) {
      final lastword = controller.text[2];
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
        if (digits.length < 2) return;
        if (digits == '00') {
          widget.onChangedMonth('01');
          controller.text = '01';
        } else {
          widget.onChangedMonth(digits);
        }
      },
      onSubmitted: (input) {
        final digits = input.replaceAll(RegExp('[^0-9]'), '');
        if (digits.isEmpty || digits == '0') {
          widget.onChangedMonth('01');
          controller.text = '01';
        } else if (digits.length == 2) {
          widget.onChangedMonth(digits);
        } else {
          widget.onChangedMonth('0$digits');
          controller.text = '0$digits';
        }
      },
      whenUnfocus: (node) {
        if (controller.value.text.isEmpty) {
          widget.whenUnfocus(node);
        }
      },
      controller: controller,
      hint: 'mm',
      focusNode: widget.focusNode,
    );
  }
}
