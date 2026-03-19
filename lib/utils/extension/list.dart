import 'dart:developer';

import 'package:zili_coffee/data/models/media_file.dart';

extension ListExt2<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty ? true : false;

  T? valueAt(int index) {
    if (isNullOrEmpty) return null;

    return this!.asMap()[index];
  }

  T? valueBy(bool Function(T item) test) {
    if (isNullOrEmpty) return null;

    try {
      return this!.firstWhere(test);
    } catch (e) {
      log("valueBy: $e");
      return null;
    }
  }

  List<T> filter(bool Function(T item) test) {
    if (isNullOrEmpty) return [];
    return this!.where(test).toList();
  }

  void addWhere(List<T>? input, bool Function(T item) test) {
    if (isNullOrEmpty) return;
    final needJoin = List<T>.from(input?.where(test) ?? []);
    this!.addAll(needJoin);
  }
}

extension ListExt3<T> on List<T> {
  /// used [firstOrNull]
  T? get firstItem {
    if (isEmpty) return null;

    return first;
  }

  T? get lastItem => isNotEmpty ? last : null;

  List<List<T>> groupList(int groupSize) {
    List<List<T>> result = [];
    int lastIndex = length - 1;

    for (int i = 0; i < lastIndex; i += groupSize) {
      int endIndex = i + groupSize;
      if (endIndex > length) {
        endIndex = length;
      }
      result.add(sublist(i, endIndex));
    }

    List<T> lastGroup = [];
    int remainingElements = lastIndex % groupSize + 1;
    if (remainingElements < groupSize) {
      int previousIndex = lastIndex - remainingElements;
      lastGroup.addAll(sublist(previousIndex));
      lastGroup.addAll(sublist(previousIndex, lastIndex));
      result.add(lastGroup);
    }

    return result;
  }

  String valuesToString() {
    if (this is! List<String>) return '';
    String result = '';
    for (String string in this as List<String>) {
      result += "$string. ";
    }
    return result;
  }

  String get formatToStringForAPI {
    String result = "[";
    const String divider = "\"";
    const String urlKey = "${divider}url$divider:";
    const String urlThumbKey = "${divider}url_thumb$divider:";
    if (this is! List<MediaFile>) return "[]";
    for (var i = 0; i < length; i++) {
      result += "{$urlKey $divider${(this[i] as MediaFile).url}$divider, ";
      result +=
          "$urlThumbKey $divider${(this[i] as MediaFile).urlThumb}$divider}";
      if (i == length - 1) {
      } else {
        result += ",";
      }
    }
    result += "]";
    return result;
  }
}
