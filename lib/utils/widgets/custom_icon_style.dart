import 'package:flutter/material.dart';

class CustomIconStyle extends StatelessWidget {
  final IconData icon;
  final TextStyle style;
  final Color? color;
  final TextAlign? align;
  const CustomIconStyle({
    super.key,
    required this.icon,
    required this.style,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(icon.codePoint),
      style: style.copyWith(
        inherit: false,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
      textAlign: align,
    );
  }
}
