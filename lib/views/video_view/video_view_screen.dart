import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/duration.dart';
import 'package:zili_coffee/utils/widgets/video_player_widget/components/play_pause_button.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

part 'components/back_button.dart';
part 'components/video_progress_bar.dart';

class VideoViewScreen extends StatefulWidget {
  final VideoPlayerController videoController;
  const VideoViewScreen({super.key, required this.videoController});

  @override
  State<VideoViewScreen> createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  bool _showVideoAction = true;
  bool _mute = false;
  @override
  void initState() {
    super.initState();
    _setOrientationToLandscape();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _resetOrientation();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SizedBox(
          width: Spaces.screenWidth(context),
          height: Spaces.screenHeight(context),
          child: Center(
            child: GestureDetector(
              onTap: () async {
                setState(() => _showVideoAction = !_showVideoAction);
              },
              child: AspectRatio(
                aspectRatio: widget.videoController.value.aspectRatio,
                child: Stack(
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SizedBox(
                        width: widget.videoController.value.size.width,
                        height: widget.videoController.value.size.height,
                        child: VideoPlayer(widget.videoController),
                      ),
                    ),
                    if (_showVideoAction)
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BackButton(
                              onback: () {
                                _resetOrientation()
                                    .then((value) => context.navigator.pop());
                              },
                            ),
                            PlayPauseButton(
                              videoController: widget.videoController,
                              onTap: playPauseEvent,
                            ),
                            _VideoProgressbar(
                              videoController: widget.videoController,
                              onBack: () {
                                _resetOrientation()
                                    .then((value) => context.navigator.pop());
                              },
                              setVolume: () async {
                                if (widget.videoController.value.volume != 0) {
                                  widget.videoController
                                      .setVolume(0)
                                      .then((value) {
                                    setState(() => _mute = !_mute);
                                  });
                                } else {
                                  widget.videoController
                                      .setVolume(1)
                                      .then((value) {
                                    setState(() => _mute = !_mute);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void playPauseEvent() {
    setState(() {
      if (widget.videoController.value.isPlaying) {
        widget.videoController.pause();
      } else {
        widget.videoController.play();
      }
    });
  }

  Future<void> _setOrientationToLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  Future<void> _resetOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
  }
}
