import 'package:flutter/material.dart';

import '../../res/res.dart';

class SwitchButtonWidget extends StatelessWidget {
  final bool value;
  final double? scale;
  final double? height;
  final double? width;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final WidgetStateProperty<Icon?>? thumbIcon;
  final Function(bool)? onSwitch;
  const SwitchButtonWidget({
    super.key,
    required this.value,
    this.onSwitch,
    this.scale,
    this.height,
    this.width,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.thumbIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: height,
      width: width,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Transform.scale(
          scale: scale ?? 0.84,
          child: Switch(
            value: value,
            onChanged: onSwitch?.call,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbIcon:
                thumbIcon ??
                WidgetStateProperty.resolveWith<Icon?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return const Icon(Icons.check, color: AppColors.primary);
                  }
                  return Icon(
                    Icons.close,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    applyTextScaling: true,
                    fill: 1,
                  );
                }),
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: inactiveThumbColor ?? AppColors.greyC0,
            inactiveTrackColor:
                inactiveTrackColor ?? AppColors.greyC0.withValues(alpha: 0.3),
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) return null;
              return AppColors.greyC0;
            }),
          ),
        ),
      ),
    );
  }
}
