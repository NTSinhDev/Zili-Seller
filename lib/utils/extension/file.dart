import 'dart:io';

import 'package:zili_coffee/utils/enums.dart';

extension FileExt on File {
  MediaType get type {
    final videoExtensions = ['mp4', 'avi', 'mkv', 'mov'];
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];

    String fileExtension = path.split('.').last.toLowerCase();

    if (videoExtensions.contains(fileExtension)) {
      return MediaType.video;
    } else if (imageExtensions.contains(fileExtension)) {
      return MediaType.image;
    } else {
      return MediaType.undefine;
    }
  }
}
