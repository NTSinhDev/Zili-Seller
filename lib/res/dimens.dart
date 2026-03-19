import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/enums.dart';

class Spaces {
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;
}

Widget width({required double width, Widget? child}) =>
    SizedBox(width: width.w, child: child);
Widget height({required double height, Widget? child}) =>
    SizedBox(height: height.w, child: child);

class DimensionView {
  final BuildContext context;
  late final FlutterView view;

  DimensionView(this.context) : view = View.of(context);

  double get physicalWidth => view.physicalSize.width;
  double get physicalHeight => view.physicalSize.height;

  LayoutView get useLayout {
    if (physicalWidth > 600) return LayoutView.horizontal;
    if (physicalWidth > 360) return LayoutView.vertical;
    return LayoutView.none;
  }
}
