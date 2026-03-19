part of '../video_player_widget.dart';

class _VideoPlaceholder extends StatelessWidget {
  final String urlThumb;
  final double? maxHeight;
  const _VideoPlaceholder({required this.urlThumb, this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageLoadingWidget(
          url: urlThumb,
          width: Spaces.screenWidth(context),
          height: maxHeight ?? Spaces.screenWidth(context),
          fit: BoxFit.fill,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: EdgeInsets.all(8.w),
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2.5,
                backgroundColor: AppColors.white.withOpacity(0.4),
              ),
            ),
          ),
        )
      ],
    );
  }
}
