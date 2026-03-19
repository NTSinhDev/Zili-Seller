import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/duration.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/video_view/video_view_screen.dart';

class VideoProgressBar extends StatelessWidget {
  final VideoPlayerController videoController;
  final Function() onMute;
  const VideoProgressBar({
    super.key,
    required this.videoController,
    required this.onMute,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: videoController,
                builder: (context, VideoPlayerValue value, child) {
                  return SizedBox(
                    width: 36.w,
                    child: Text(
                      value.position.videoCurrentTime,
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.white,
                      ),
                    ),
                  );
                },
              ),
              Text(
                "/\t\t${videoController.value.duration.videoDuration}",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.white,
                ),
              ),
              width(width: 16.w),
              InkWell(
                onTap: onMute,
                child: videoController.value.volume == 0
                    ? SvgPicture.asset(
                        AppConstant.svgs.iSpeakerXMark,
                        width: 20.w,
                        height: 20.w,
                      )
                    : SvgPicture.asset(
                        AppConstant.svgs.iSpeakerWave,
                        width: 20.w,
                        height: 20.w,
                      ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (!videoController.value.isPlaying) {
                    videoController.play();
                  }
                  context.navigator.push(
                    MaterialPageRoute(
                      builder: (context) => VideoViewScreen(
                        videoController: videoController,
                      ),
                    ),
                  );
                },
                child: CustomIconStyle(
                  icon: Icons.fullscreen,
                  style: AppStyles.text.medium(
                    fSize: 20.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          height(height: 6),
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
