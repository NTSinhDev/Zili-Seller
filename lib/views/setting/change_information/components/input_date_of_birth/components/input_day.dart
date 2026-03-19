part of '../../../change_information_screen.dart';

class _InputDay extends StatefulWidget {
  final Function(String) onChangedDate;
  final FocusNode focusNode;
  final String? value;
  const _InputDay({
    required this.onChangedDate,
    required this.focusNode,
    this.value,
  });
  @override
  State<_InputDay> createState() => _InputDayState();
}

class _InputDayState extends State<_InputDay> {
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
      width: 18.w,
      onChanged: (input) {
        String digits = input.replaceAll(RegExp('[^0-9]'), '');
        if (digits.length < 2) return;
        // return day and go to next input
        if (digits == '00') {
          widget.onChangedDate('01');
          controller.text = '01';
        } else {
          widget.onChangedDate(digits);
        }
      },
      onSubmitted: (input) {
        final digits = input.replaceAll(RegExp('[^0-9]'), '');
        if (digits.isEmpty || digits == '0') {
          widget.onChangedDate('01');
          controller.text = '01';
        } else if (digits.length == 2) {
          widget.onChangedDate(digits);
        } else {
          widget.onChangedDate('0$digits');
          controller.text = '0$digits';
        }
      },
      whenUnfocus: (node) {},
      controller: controller,
      hint: 'dd',
      focusNode: widget.focusNode,
    );
  }
}
