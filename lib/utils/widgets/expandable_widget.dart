import 'package:flutter/material.dart';

import 'column_widget.dart';

class ExpandableWidget extends StatefulWidget {
  final List<Widget> expandedChildren;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool initiallyExpanded;
  final num gap;
  final Widget? denseWidget;

  const ExpandableWidget({
    super.key,
    this.initiallyExpanded = true,
    this.gap = 0,
    required this.expandedChildren,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOut,
    this.denseWidget,
  });

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedSize(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        child: widget.initiallyExpanded
            ? ColumnWidget(
                gap: widget.gap,
                children: [...widget.expandedChildren],
              )
            : widget.denseWidget ?? const SizedBox(height: 4),
      ),
    );
  }
}
