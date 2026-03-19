import 'package:flutter/material.dart';

class CustomRichTextWidget extends StatelessWidget {
  final TextStyle defaultStyle;
  final List<dynamic> texts;
  final TextAlign? textAlign;
  final int? maxLines;
  const CustomRichTextWidget({
    super.key,
    required this.defaultStyle,
    required this.texts,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: .ellipsis,
      maxLines: maxLines ?? 56,
      textAlign: textAlign ?? .start,
      text: TextSpan(style: defaultStyle, children: _text()),
    );
  }

  List<InlineSpan> _text() {
    List<InlineSpan> t = [];
    t = texts.map((e) {
      if (e is String) return TextSpan(text: e);
      return e as InlineSpan;
    }).toList();
    return t;
  }
}
