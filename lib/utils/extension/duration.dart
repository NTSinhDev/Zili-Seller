extension DurationExt on Duration {
  String get videoCurrentTime {
    return toString().split('.').first.substring(2);
  }

  String get videoDuration {
    return toString().split('.').first.substring(2);
  }
}
