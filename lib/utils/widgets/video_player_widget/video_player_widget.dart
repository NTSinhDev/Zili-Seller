import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/image_loading_widget.dart';
import 'package:zili_coffee/utils/widgets/video_player_widget/components/play_pause_button.dart';
import 'package:zili_coffee/utils/widgets/video_player_widget/components/video_progress_bar.dart';
part 'components/not_found_video.dart';
part 'components/video_placeholder.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String urlThumb;
  final Function(
    VideoPlayerController videoController,
    Future<void> videoControllerFuture,
  ) returnVideoData;
  final VideoPlayerController? videoController;
  final Future<void>? videoControllerFuture;
  final double? maxViewHeight;
  const VideoPlayerWidget({
    super.key,
    required this.url,
    required this.urlThumb,
    required this.returnVideoData,
    this.videoController,
    this.videoControllerFuture,
    this.maxViewHeight,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoController;
  late Future<void> videoControllerFuture;

  bool _showVideoAction = true;
  bool _mute = false;
  @override
  void initState() {
    super.initState();
    if (widget.videoController == null) {
      videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      videoControllerFuture = videoController.initialize();
      videoController.setLooping(true);
    } else {
      videoController = widget.videoController!;
      videoControllerFuture = widget.videoControllerFuture!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: videoControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const _NotFoundVideo();

        if (snapshot.connectionState == ConnectionState.done) {
          if (widget.videoController == null) {
            widget.returnVideoData(videoController, videoControllerFuture);
          }
          return GestureDetector(
            onTap: () async {
              setState(() => _showVideoAction = !_showVideoAction);
            },
            child: AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: Stack(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: Spaces.screenWidth(context),
                      height:
                          widget.maxViewHeight ?? Spaces.screenWidth(context),
                      child: VideoPlayer(videoController),
                    ),
                  ),
                  if (_showVideoAction)
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      width: Spaces.screenWidth(context),
                      height:
                          widget.maxViewHeight ?? Spaces.screenWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          PlayPauseButton(
                            videoController: videoController,
                            onTap: playPauseEvent,
                          ),
                          VideoProgressBar(
                            videoController: videoController,
                            onMute: onMute,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return _VideoPlaceholder(
          urlThumb: widget.urlThumb,
          maxHeight: widget.maxViewHeight,
        );
      },
    );
  }

  void onMute() {
    if (!_mute) {
      videoController.setVolume(0).then((value) {
        setState(() => _mute = !_mute);
      });
    } else {
      videoController.setVolume(1).then((value) {
        setState(() => _mute = !_mute);
      });
    }
  }

  void playPauseEvent() {
    setState(() {
      if (videoController.value.isPlaying) {
        videoController.pause();
      } else {
        videoController.play();
      }
    });
  }
}
