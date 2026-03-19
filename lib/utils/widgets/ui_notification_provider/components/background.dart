part of '../ui_notification_provider.dart';

class _Background extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double size;
  final double opacity;
  const _Background({
    required this.size,
    required this.opacity,
    this.left,
    this.top,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
