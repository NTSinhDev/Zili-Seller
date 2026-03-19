import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/file.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
part 'components/add_media.dart';
part 'components/video_item.dart';

class MultilineInputFieldWidget extends StatefulWidget {
  final String hint;
  final String? label;
  final Function(String) onChanged;
  final TextStyle textStyle;
  final Color? hintColor;
  final Color? inputColor;
  final double? borderWeight;
  final int? line;
  final double? radius;
  final String? text;
  final List<File> media;
  final Widget? addMedia;
  final bool autoFocus;
  const MultilineInputFieldWidget({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.textStyle,
    this.label,
    this.hintColor,
    this.inputColor,
    this.borderWeight,
    this.line,
    this.radius,
    this.text,
    this.media = const [],
    this.addMedia,
    this.autoFocus = false,
  });

  @override
  State<MultilineInputFieldWidget> createState() =>
      _MultilineInputFieldWidgetState();

  static Widget addMediaView({
    required Function(File) addPhoto,
    required Function(File) addVideo,
    required Function(List<File> images, List<File> videos) uploadFile,
  }) =>
      _AddMediaView(
        addPhoto: addPhoto,
        addVideo: addVideo,
        uploadFile: uploadFile,
      );
}

class _MultilineInputFieldWidgetState extends State<MultilineInputFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: widget.textStyle),
          height(height: 10),
        ],
        Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.inputColor ?? AppColors.black,
              width: widget.borderWeight ?? 1.5.r,
            ),
            color: AppColors.white,
            borderRadius: BorderRadius.circular(widget.radius ?? 7.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black24.withOpacity(0.2),
                offset: const Offset(1, 1),
                blurRadius: 5.r,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: widget.textStyle,
                controller: controller,
                cursorColor: widget.hintColor,
                maxLines: widget.line ?? 10,
                onChanged: widget.onChanged,
                autofocus: widget.autoFocus,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration.collapsed(
                  hintText: widget.hint,
                  hintStyle: widget.textStyle.copyWith(color: widget.hintColor),
                ),
              ),
              if (widget.addMedia != null) ...[
                height(height: 10),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.w,
                  children: [
                    ...widget.media.map((file) {
                      if (file.type == MediaType.video) {
                        return VideoItem(file: file);
                      }
                      return SizedBox(
                        width: 56.w,
                        height: 56.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.file(file, fit: BoxFit.cover),
                        ),
                      );
                    }),
                  ],
                ),
                height(height: 20),
                widget.addMedia!,
              ]
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
