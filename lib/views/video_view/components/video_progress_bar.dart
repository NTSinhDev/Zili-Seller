part of '../video_view_screen.dart';

class _VideoProgressbar extends StatelessWidget {
  final VideoPlayerController videoController;
  final Function() onBack;
  final Function() setVolume;
  const _VideoProgressbar({
    required this.videoController,
    required this.onBack,
    required this.setVolume,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: videoController,
                builder: (context, VideoPlayerValue value, child) {
                  return SizedBox(
                    width: 16.w,
                    child: Text(
                      value.position.videoCurrentTime,
                      style: AppStyles.text.medium(
                        fSize: 15.sp,
                        color: AppColors.white,
                      ),
                    ),
                  );
                },
              ),
              Text(
                "/\t${videoController.value.duration.videoDuration}",
                style: AppStyles.text.medium(
                  fSize: 15.sp,
                  color: AppColors.white,
                ),
              ),
              width(width: 10),
              InkWell(
                onTap: setVolume,
                // () async {
                //   if (!_mute) {
                //     videoController.setVolume(0).then((value) {
                //       setState(() => _mute = !_mute);
                //     });
                //   } else {
                //     widget.videoController.setVolume(1).then((value) {
                //       setState(() => _mute = !_mute);
                //     });
                //   }
                // },
                child: videoController.value.volume == 0
                    ? SvgPicture.asset(
                        AppConstant.svgs.iSpeakerXMark,
                        width: 10.w,
                        height: 10.w,
                      )
                    : SvgPicture.asset(
                        AppConstant.svgs.iSpeakerWave,
                        width: 10.w,
                        height: 10.w,
                      ),
              ),
              const Spacer(),
              InkWell(
                onTap: onBack,
                child: CustomIconStyle(
                  icon: Icons.fullscreen_exit,
                  style: AppStyles.text.medium(
                    fSize: 28.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          height(height: 4),
          SizedBox(
            height: 8.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: VideoProgressIndicator(
              videoController,
                colors: VideoProgressColors(
                  playedColor: AppColors.white,
                  bufferedColor: AppColors.white.withOpacity(0.3),
                  backgroundColor: AppColors.gray4B,
                ),
                allowScrubbing: true,
                padding: const EdgeInsets.all(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
