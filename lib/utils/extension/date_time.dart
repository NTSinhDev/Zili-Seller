import 'package:intl/intl.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../res/res.dart';
import 'extension.dart';

extension DateTimeExt on DateTime {
  String csToString(String formatString) {
    final format = DateFormat(formatString);
    return format.format(this);
  }

  DateTime startOfDate() {
    return DateTime(year, month, day);
  }

  DateTime endOfDate() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  /// Start of month: year-month-01 00:00:00
  DateTime startOfMonth() {
    return DateTime(year, month, 1);
  }

  /// End of month: year-month-(last day of month) 23:59:59
  DateTime endOfMonth() {
    return DateTime(year, month + 1, 0, 23, 59, 59);
  }

  bool isToday() {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.year == year &&
        tomorrow.month == month &&
        tomorrow.day == day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.year == year &&
        yesterday.month == month &&
        yesterday.day == day;

        
  }

  //Start at Monday
  static List<DateTime> dateInWeekByDate(DateTime date) {
    final now = DateTime.now().startOfDate();
    final weekDay = date.weekday;
    final result = <DateTime>[];
    for (var i = 1; i <= 7; i++) {
      final calculate = now.add(Duration(days: i - weekDay));
      result.add(calculate);
    }

    return result;
  }

  String dateByFormat({required DateTimeFormat format}) =>
      DateFormat(format.value).format(this);

  /// Input: 2023-07-21 08:19:25.194Z => 08:19 | 21-07-2023
  String get orderStateTree {
    formatted(String time) => time.padLeft(2, '0');

    String minute = formatted(this.minute.toString());
    String hour = formatted(this.hour.toString());
    String day = formatted(this.day.toString());
    String month = formatted(this.month.toString());
    String year = formatted(this.year.toString());

    return "$hour:$minute\t|\t$day-$month-$year";
  }

  /// Input: 2023-07-21 08:19:25.194Z => 21-07
  String get toDayMonth {
    int day = this.day;
    int month = this.month;

    String dayFormatted = day.toString().padLeft(2, '0');
    String monthFormatted = month.toString().padLeft(2, '0');

    return "$dayFormatted-$monthFormatted";
  }

  /// Input: 2023-07-21 08:19:25.194Z => "21 thg 7"
  /// Format date như trong order list: "24 thg 11"
  String get toOrderListDate {
    final months = [
      '',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12'
    ];
    return "$day thg ${months[month]}";
  }

  /// Convert DateTime to ISO 8601 string with timezone offset.
  /// - Nếu không truyền offset, sẽ dùng offset hiện tại của thiết bị.
  /// Format: yyyy-MM-ddTHH:mm:ss+07:00
  String toIso8601StringWithTimezone({int? timezoneOffsetHours}) {
    final deviceOffset = DateTime.now().timeZoneOffset;
    final offset = timezoneOffsetHours != null
        ? Duration(hours: timezoneOffsetHours)
        : deviceOffset;

    final utcDateTime = toUtc();
    final offsetDateTime = utcDateTime.add(offset);

    final year = offsetDateTime.year.toString().padLeft(4, '0');
    final month = offsetDateTime.month.toString().padLeft(2, '0');
    final day = offsetDateTime.day.toString().padLeft(2, '0');
    final hour = offsetDateTime.hour.toString().padLeft(2, '0');
    final minute = offsetDateTime.minute.toString().padLeft(2, '0');
    final second = offsetDateTime.second.toString().padLeft(2, '0');

    final totalMinutes = offset.inMinutes;
    final sign = totalMinutes >= 0 ? '+' : '-';
    final absMinutes = totalMinutes.abs();
    final offHours = (absMinutes ~/ 60).toString().padLeft(2, '0');
    final offMinutes = (absMinutes % 60).toString().padLeft(2, '0');

    return '$year-$month-${day}T$hour:$minute:$second$sign$offHours:$offMinutes';
  }
}

extension DateTimeNullableExt on DateTime? {
  /// Format DateTime with timezone offset to string pattern
  /// Default: pattern 'HH:mm dd/MM/yyyy', offset = timezone hiện tại của thiết bị
  String formatWithTimezone({
    int? timezoneOffsetHours,
    Duration? timezoneOffset,
    String pattern = 'HH:mm dd/MM/yyyy',
    String empty = '',
  }) {
    final dt = this;
    if (dt == null) {
      return empty.isNotEmpty ? empty : AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }
    final offset = timezoneOffset ??
        (timezoneOffsetHours != null
            ? Duration(hours: timezoneOffsetHours)
            : DateTime.now().timeZoneOffset);
    final utcDateTime = dt.toUtc();
    final offsetDateTime = utcDateTime.add(offset);
    return DateFormat(pattern).format(offsetDateTime);
  }
}

extension DateTimeCanNullExt on DateTime? {
  String formatBy({required TimeFormat format}) {
    if (isNull) return "";
    return DateFormat(format.value).format(this!);
  }

  String formatByString({required String string}) {
    if (isNull) return "";

    return DateFormat(string).format(this!);
  }
}

extension DateTimeStringExt on String {
  /// Parse ISO 8601 string từ server và convert timezone sang client timezone
  ///
  /// Hàm này parse ISO string từ server (có thể có timezone offset hoặc UTC)
  /// và convert sang client timezone để đảm bảo hiển thị đúng theo timezone của thiết bị
  ///
  /// Parameters:
  /// - serverTimezoneOffsetHours: Timezone offset của server (ví dụ: 7 cho UTC+7)
  ///   Nếu null, sẽ tự động detect từ ISO string hoặc mặc định là UTC
  ///
  /// Returns:
  /// - DateTime ở client timezone, hoặc null nếu parse failed
  ///
  /// Example:
  /// ```dart
  /// // Server gửi: "2025-12-31T17:00:00.000Z" (UTC)
  /// final date = "2025-12-31T17:00:00.000Z".parseFromServerTimezone();
  /// // Kết quả: DateTime ở client timezone (ví dụ: UTC+7 sẽ là 2026-01-01 00:00:00)
  ///
  /// // Server gửi: "2026-01-01T00:00:00+07:00" (đã có timezone)
  /// final date2 = "2026-01-01T00:00:00+07:00".parseFromServerTimezone();
  /// // Kết quả: DateTime ở client timezone
  /// ```
  DateTime? parseFromServerTimezone({int? serverTimezoneOffsetHours}) {
    if (isEmpty) return null;

    try {
      // Parse ISO string (có thể có timezone hoặc UTC)
      final parsedDate = DateTime.parse(this);

      // Nếu ISO string đã có timezone offset, parsedDate sẽ tự động convert sang local timezone
      // Nếu ISO string là UTC (có 'Z' hoặc không có timezone), cần xử lý thêm
      if (contains('Z') || (!contains('+') && !contains('-') && !contains('T'))) {
        // UTC string hoặc không có timezone info
        // Convert từ UTC sang client timezone
        return parsedDate.toLocal();
      } else if (serverTimezoneOffsetHours != null) {
        // Có server timezone offset được chỉ định
        // Parse date theo server timezone, sau đó convert sang client timezone
        final serverOffset = Duration(hours: serverTimezoneOffsetHours);
        final utcDate = parsedDate.toUtc();
        // Adjust về server timezone trước
        final serverDate = utcDate.subtract(serverOffset);
        // Sau đó convert sang client timezone
        return serverDate.toLocal();
      } else {
        // ISO string đã có timezone offset, DateTime.parse() đã tự động convert
        // Chỉ cần đảm bảo nó ở local timezone
        return parsedDate.isUtc ? parsedDate.toLocal() : parsedDate;
      }
    } catch (e) {
      // Parse failed, return null
      return null;
    }
  }

  /// Parse ISO 8601 string từ server và giữ nguyên timezone của server
  ///
  /// Hàm này parse ISO string và trả về DateTime với timezone như server gửi
  /// (không convert sang client timezone)
  ///
  /// Returns:
  /// - DateTime với timezone như server, hoặc null nếu parse failed
  ///
  /// Example:
  /// ```dart
  /// // Server gửi: "2025-12-31T17:00:00.000Z" (UTC)
  /// final date = "2025-12-31T17:00:00.000Z".parseFromServer();
  /// // Kết quả: DateTime ở UTC
  ///
  /// // Server gửi: "2026-01-01T00:00:00+07:00"
  /// final date2 = "2026-01-01T00:00:00+07:00".parseFromServer();
  /// // Kết quả: DateTime với timezone +07:00
  /// ```
  DateTime? parseFromServer() {
    if (isEmpty) return null;

    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }
}
