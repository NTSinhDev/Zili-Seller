part of '../multi_line_input_field.dart';

class VideoItem extends StatefulWidget {
  final File file;
  const VideoItem({super.key, required this.file});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_controller.value.isInitialized) ...[
          SizedBox(
            width: 56.w,
            height: 56.w,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7.r),
                  child: VideoPlayer(_controller),
                ),
                const Center(
                  child: Icon(
                    Icons.play_circle_fill_outlined,
                    color: AppColors.white,
                  ),
                )
              ],
            ),
          ),
        ] else
          const CircularProgressIndicator(),
      ],
    );
  }
}
