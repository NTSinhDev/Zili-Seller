part of "../orders_history_screen.dart";

class _OrderDuration extends StatelessWidget {
  final DateTime? durationStart;
  final DateTime? durationEnd;
  final bool loading;
  const _OrderDuration({
    required this.loading,
    this.durationStart,
    this.durationEnd,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderWidget(
      width: 150.w,
      height: 32.h,
      condition: loading,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            if (durationStart != null)
              const Icon(Icons.timelapse_sharp, color: AppColors.grey84)
            else
              const RotationTransition(
                turns: AlwaysStoppedAnimation(136 / 360),
                child: Icon(Icons.timelapse_sharp, color: AppColors.grey84),
              ),
            width(width: 8),
            Text(
              durationStart != null ? "12:14 13 thg 10" : "12:24 13 thg 10",
              style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
