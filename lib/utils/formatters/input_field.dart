import 'package:flutter/services.dart';

List<TextInputFormatter> decimalInputFormatter() {
  final includeNumberAndComma = FilteringTextInputFormatter.allow(
    RegExp(r'^[\d,]*$'),
  );
  final reformatInput = TextInputFormatter.withFunction((oldValue, newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final firstCommaIndex = text.indexOf(',');

    if (firstCommaIndex != -1) {
      final beforeComma = text.substring(0, firstCommaIndex + 1);
      final afterComma = text
          .substring(firstCommaIndex + 1)
          .replaceAll(',', '');

      final newText = beforeComma + afterComma;

      if (newText != text) {
        int offset = newValue.selection.end - (text.length - newText.length);
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: offset.clamp(0, newText.length).toInt(),
          ),
        );
      }
    }

    return newValue.copyWith(text: text.replaceAll('.', ''));
  });

  return [includeNumberAndComma, reformatInput];
}

TextInputType decimalInputType() =>
    const TextInputType.numberWithOptions(decimal: true);
