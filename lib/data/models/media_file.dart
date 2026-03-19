import 'dart:convert';

import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/string.dart';

class MediaFile {
  final MediaType type;
  final String url;
  final String urlThumb;
  final int? position;
  final int? sizeInBytes;
  final String? fileName;
  MediaFile({
    required this.type,
    required this.url,
    required this.urlThumb,
    this.position,
    this.sizeInBytes,
    this.fileName,
  });

  MediaFile copyWith({
    MediaType? type,
    String? url,
    String? urlThumb,
    int? position,
  }) {
    return MediaFile(
      type: type ?? this.type,
      url: url ?? this.url,
      urlThumb: urlThumb ?? this.urlThumb,
      position: position ?? this.position,
    );
  }

  factory MediaFile.fromMap(Map<String, dynamic> map) {
    return MediaFile(
      type: map['media_type'] == "image"
          ? MediaType.image
          : map['media_type'] == "video"
              ? MediaType.video
              : MediaType.undefine,
      url: map['url'] as String,
      urlThumb: map['url_thumb'] as String,
      position: map['position'] != null ? map['position'] as int : null,
    );
  }

  factory MediaFile.fromMap2(Map<String, dynamic> map) {
    final fileType = (map['originalname'] as String).split(".").last;
    return MediaFile(
      type: fileType.checkTypeFile,
      url: map['url'] as String,
      urlThumb: map['thumb_url'] as String,
     );
  }

  factory MediaFile.fromJson(String source) =>
      MediaFile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MediaFile(type: $type, url: $url, url_thumb: $urlThumb)';

  @override
  bool operator ==(covariant MediaFile other) {
    if (identical(this, other)) return true;

    return other.type == type && other.url == url && other.urlThumb == urlThumb;
  }

  @override
  int get hashCode => type.hashCode ^ url.hashCode ^ urlThumb.hashCode;
}
