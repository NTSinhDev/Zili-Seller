import 'package:flutter/material.dart';
import 'package:zili_coffee/res/res.dart';

class RowWidget extends StatelessWidget {
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
  final List<BoxShadow>? boxShadow;
  final List<Widget> children;

  const RowWidget({
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
    this.boxShadow,
    required this.children,
  });

  List<Widget> widgets() {
    List<Widget> widgets = [];
    for (var i = 0; i < children.length; i++) {
      if (i == children.length - 1) {
        widgets.add(children[i]);
      } else {
        widgets.add(children[i]);
        widgets.add(width(width: gap!.toDouble()));
      }
    }

    return widgets;
  }

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
        boxShadow: boxShadow,
      ),
      clipBehavior: clipBehavior,
      child: Row(
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: gap != null ? widgets() : children,
      ),
    );
  }
}
