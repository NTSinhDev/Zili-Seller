part of '../store_reviews_screen.dart';

class _MediaContainer extends StatelessWidget {
  final MediaFile mediaFile;
  final Function() onTap;
  const _MediaContainer({required this.mediaFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 52.w,
        margin: EdgeInsets.only(right: 6.w),
        child: Stack(
          children: [
            ImageLoadingWidget(
              url: mediaFile.urlThumb.isEmpty
                  ? mediaFile.url
                  : mediaFile.urlThumb,
              width: 52.w,
              height: 52.w,
              fit: BoxFit.cover,
            ),
            if (mediaFile.type == MediaType.video)
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.white,
                    size: 17.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
