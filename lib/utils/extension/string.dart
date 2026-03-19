import 'package:zili_coffee/utils/enums.dart';

extension StringExt on String {
  /// Input: 0324456789 => Output: 032 445 6789
  String get toNumberPhone {
    if (length == 10) {
      return "${substring(0, 3)}\t${substring(3, 6)}\t${substring(6, length)}";
    }
    return this;
  }

  MediaType get checkTypeFile {
    final videoExtensions = ['mp4', 'avi', 'mkv', 'mov'];
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
    if (imageExtensions.contains(toLowerCase())) {
      return MediaType.image;
    }
    if (videoExtensions.contains(toLowerCase())) {
      return MediaType.video;
    }
    return MediaType.undefine;
  }

  String get anonymousName {
    return "${substring(0, 1)}***${substring(length - 2, length)}";
  }

  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String videoCurrentTime(Duration position) {
    return position.toString().split('.').first.substring(2);
  }

    String videoDuration(Duration position) {
    return position.toString().split('.').first.substring(2);
  }
}
