part of '../multi_line_input_field.dart';

int _imageQuality = 100;
double _maxWidth = 800;
double _maxHeight = 800;

class _AddMediaView extends StatelessWidget {
  final Function(File) addPhoto;
  final Function(File) addVideo;
  final Function(List<File> images, List<File> videos) uploadFile;
  const _AddMediaView({
    required this.addPhoto,
    required this.addVideo,
    required this.uploadFile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        addButtonComponent(
          ontap: takeAPicture,
          icon: Icon(Icons.add_a_photo_outlined, size: 22.sp),
        ),
        width(width: 8),
        addButtonComponent(
          ontap: takeAVideo,
          icon: SizedBox(
            width: 24.w,
            child: Stack(
              children: [
                Stack(
                  children: [
                    Icon(Icons.video_settings_rounded, size: 22.sp),
                    Positioned(
                      bottom: 0.5.h,
                      right: -0.5.w,
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: -1.2.h,
                  right: -2.w,
                  child: CustomIconStyle(
                    icon: Icons.add,
                    style: AppStyles.text.bold(fSize: 12.8.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
        width(width: 8),
        addButtonComponent(
          ontap: getMediasFromGallery,
          icon: Icon(Icons.upload_rounded, size: 22.sp),
        ),
      ],
    );
  }

  Future<void> takeAPicture() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: _imageQuality,
      maxWidth: _maxWidth,
      maxHeight: _maxHeight,
    );
    if (image == null) return;
    addPhoto(File(image.path));
  }

  Future<void> takeAVideo() async {
    final XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 10),
    );
    if (video == null) return;
    addVideo(File(video.path));
  }

  Future<void> getMediasFromGallery() async {
    final List<XFile> medias = await ImagePicker().pickMultipleMedia(
      imageQuality: _imageQuality,
      maxWidth: _maxWidth,
      maxHeight: _maxHeight,
    );
    if (medias.isEmpty) return;
    List<File> images = [];
    List<File> videos = [];
    for (final media in medias) {
      final file = File(media.path);
      if (file.type == MediaType.image) {
        images.add(file);
      } else if (file.type == MediaType.video) {
        videos.add(file);
      }
    }
    uploadFile(images, videos);
  }

  Widget addButtonComponent({required Function() ontap, required Widget icon}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey97, width: 0.8.sp),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: icon,
      ),
    );
  }
}
