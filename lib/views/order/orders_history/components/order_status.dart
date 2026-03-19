part of "../orders_history_screen.dart";

class _OrderStatus extends StatelessWidget {
  final bool isDone;
  const _OrderStatus({required this.isDone});

  @override
  Widget build(BuildContext context) {
    final Color color = isDone ? AppColors.primary : AppColors.red;
    final String label = isDone ? "Hoàn thành" : "\t\tĐã hủy\t\t\t";
    return Positioned(
      right: -38.w,
      top: 11.h,
      child: RotationTransition(
        turns: const AlwaysStoppedAnimation(30 / 360),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 40.w),
          color: color.withOpacity(0.3),
          child: Text(
            label,
            style: AppStyles.text.bold(fSize: 9.2.sp, color: color),
          ),
        ),
      ),
    );
  }
}
