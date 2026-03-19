part of '../video_player_widget.dart';

class _NotFoundVideo extends StatelessWidget {
  const _NotFoundVideo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      height: Spaces.screenWidth(context),
      color: AppColors.lightGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.red,
            size: 30.sp,
          ),
          height(height: 8),
          Text(
            "Video không có sẵn!",
            style: AppStyles.text.semiBold(fSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
