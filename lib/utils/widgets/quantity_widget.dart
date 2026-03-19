import 'package:flutter/material.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import 'widgets.dart';

enum ButtonType { increment, decrement }

class QuantityWidget extends StatefulWidget {
  final num? defaultValue;
  final Function(num)? onChangedQty;
  final double? sizeBtn;
  final double? fSize;
  final bool readOnly;
  final num? minValue;
  const QuantityWidget({
    super.key,
    this.onChangedQty,
    this.sizeBtn,
    this.fSize,
    this.defaultValue,
    this.minValue,
    this.readOnly = false,
  });

  @override
  State<QuantityWidget> createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  late num qty;
  late num minValue;

  @override
  void initState() {
    minValue = widget.minValue ?? 1;
    if (widget.defaultValue != null) {
      qty = widget.defaultValue!;
    }
    super.initState();
  }

  @override
  didUpdateWidget(QuantityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultValue != widget.defaultValue &&
        qty != widget.defaultValue &&
        widget.defaultValue != null) {
      setState(() {
        qty = widget.defaultValue!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RowWidget(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      mainAxisSize: .min,
      borderRadius: .circular(10000),
      padding: .all(2),
      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
      children: [
        _circleBtn(type: ButtonType.decrement, disabled: qty - 1 < minValue),
        SizedBox(
          width: 55,
          child: Text(
            qty.removeTrailingZero,
            style: AppStyles.text.semiBold(
              fSize: 14,
              color: AppColors.primary,
              height: 16 / 14,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        _circleBtn(type: ButtonType.increment),
      ],
    );
  }

  Widget _circleBtn({required ButtonType type, bool disabled = false}) {
    return GestureDetector(
      onTap: widget.readOnly
          ? null
          : disabled
          ? () {}
          : () {
              if (type == ButtonType.increment) {
                setState(() => qty = qty.operate(.add, 1));
              } else {
                setState(() => qty = qty.operate(.subtract, 1));
              }
              if (widget.onChangedQty != null) widget.onChangedQty!(qty);
            },
      onLongPress: () {
        if (type == ButtonType.increment) {
          setState(() => qty++);
        } else {
          setState(() => qty--);
        }
        if (widget.onChangedQty != null) widget.onChangedQty!(qty);
      },
      child: Icon(
        type == ButtonType.increment
            ? Icons.add_circle_rounded
            : Icons.remove_circle_rounded,
        size: widget.fSize ?? 25,
        color: AppColors.primary,
      ),
    );
  }
}
