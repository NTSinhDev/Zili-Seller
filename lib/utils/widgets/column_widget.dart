import 'package:flutter/material.dart';
import 'package:zili_coffee/res/res.dart';

class ColumnWidget extends StatelessWidget {
  final num? gap;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;
  final double? maxHeight;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Clip clipBehavior;
  final List<Widget> children;

  const ColumnWidget({
    super.key,
    this.gap,
    this.maxWidth,
    this.maxHeight,
    this.padding,
    this.margin,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.clipBehavior = Clip.none,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
        border: border,
      ),
      clipBehavior: clipBehavior,
      child: Column(
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: gap != null
            ? children.map((e) {
                if (e == children.last) {
                  return e;
                } else {
                  return Column(children: [e, height(height: gap!.toDouble())]);
                }
              }).toList()
            : children,
      ),
    );
  }
}
