import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:zili_coffee/res/res.dart';

class PlayPauseButton extends StatelessWidget {
  final VideoPlayerController videoController;
  final Function() onTap;
  const PlayPauseButton({
    super.key,
    required this.videoController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          videoController.value.isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: AppColors.white,
          size: 40.sp,
        ),
      ),
    );
  }
}
