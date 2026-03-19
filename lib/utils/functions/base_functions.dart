import '../enums.dart';
import '../extension/extension.dart';

String formatCurrency(double amount) {
  return amount
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}

class TimeRange {
  final DateTime start;
  final DateTime end;
  TimeRange({required this.start, required this.end});
}

TimeRange getRangeOfTimeOption(TimeOption timeOption) {
  final now = DateTime.now();
  switch (timeOption) {
    case TimeOption.today:
      return TimeRange(start: now.startOfDate(), end: now.endOfDate());
    case TimeOption.yesterday:
      return TimeRange(
        start: now.subtract(const Duration(days: 1)).startOfDate(),
        end: now.subtract(const Duration(days: 1)).endOfDate(),
      );
    case TimeOption.thisWeek:
      int dayOfWeek = now.weekday;
      final startOfWeek = now.subtract(Duration(days: dayOfWeek - 1));
      final endOfWeek = now.add(Duration(days: 7 - dayOfWeek));
      return TimeRange(
        start: startOfWeek.startOfDate(),
        end: endOfWeek.endOfDate(),
      );
    case TimeOption.lastWeek:
      final dayOfWeekLast = now.weekday;
      final startOfLastWeek = now.subtract(Duration(days: dayOfWeekLast + 6));
      final endOfLastWeek = now.subtract(Duration(days: dayOfWeekLast));
      return TimeRange(
        start: startOfLastWeek.startOfDate(),
        end: endOfLastWeek.endOfDate(),
      );
    case TimeOption.thisMonth:
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      return TimeRange(
        start: startOfMonth.startOfDate(),
        end: endOfMonth.endOfDate(),
      );
    case TimeOption.lastMonth:
      final lastMonth = now.month == 1 ? 12 : now.month - 1;
      final lastMonthYear = now.month == 1 ? now.year - 1 : now.year;
      final startOfLastMonth = DateTime(lastMonthYear, lastMonth, 1);
      final endOfLastMonth = DateTime(
        lastMonthYear,
        lastMonth + 1,
        0,
        23,
        59,
        59,
      );
      return TimeRange(
        start: startOfLastMonth.startOfDate(),
        end: endOfLastMonth.endOfDate(),
      );
    case TimeOption.thisYear:
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
      return TimeRange(
        start: startOfYear.startOfDate(),
        end: endOfYear.endOfDate(),
      );
    case TimeOption.lastYear:
      final lastYear = now.year - 1;
      final startOfLastYear = DateTime(lastYear, 1, 1);
      final endOfLastYear = DateTime(lastYear, 12, 31, 23, 59, 59);
      return TimeRange(
        start: startOfLastYear.startOfDate(),
        end: endOfLastYear.endOfDate(),
      );
  }
}

/// Parses server timezone datetime and converts it to client local timezone.
///
/// This function handles two common formats from server:
/// - **String**: ISO 8601 datetime string (e.g., "2025-12-31T17:00:00.000Z")
/// - **int**: UTC milliseconds since epoch (e.g., 1735657200000)
///
/// **Behavior:**
/// - For String: Uses [parseFromServerTimezone] extension to parse ISO string
///   and convert from server timezone (typically UTC) to client local timezone.
/// - For int: Assumes UTC milliseconds and converts to client local timezone
///   using `DateTime.fromMillisecondsSinceEpoch(data, isUtc: true).toLocal()`.
///
/// **Returns:**
/// - `DateTime?` in client local timezone, or `null` if:
///   - `data` is `null`
///   - `data` is neither String nor int
///   - String parsing fails (for String input)
///
/// **Examples:**
/// ```dart
/// // Parse ISO string from server
/// final date1 = parseServerTimeZoneDateTime("2025-12-31T17:00:00.000Z");
/// // Result: DateTime in client timezone (e.g., 2026-01-01 00:00:00 for UTC+7)
///
/// // Parse UTC milliseconds from server
/// final date2 = parseServerTimeZoneDateTime(1735657200000);
/// // Result: DateTime in client timezone
///
/// // Null input
/// final date3 = parseServerTimeZoneDateTime(null);
/// // Result: null
/// ```
///
/// **Note:**
/// This function ensures consistent timezone conversion across the app,
/// converting all server timestamps to the client's local timezone for display.
DateTime? parseServerTimeZoneDateTime(dynamic data) {
  if (data == null) return null;
  if (data is String) return data.parseFromServerTimezone();
  if (data is int) {
    // Convert from UTC milliseconds to local timezone
    // Server typically sends UTC milliseconds, so we need to convert to client timezone
    return DateTime.fromMillisecondsSinceEpoch(data, isUtc: true).toLocal();
  }
  return null;
}


String normalizeVietnamese(String input) {
  var text = input.toLowerCase();
  const Map<String, String> map = {
    'à': 'a',
    'á': 'a',
    'ạ': 'a',
    'ả': 'a',
    'ã': 'a',
    'â': 'a',
    'ầ': 'a',
    'ấ': 'a',
    'ậ': 'a',
    'ẩ': 'a',
    'ẫ': 'a',
    'ă': 'a',
    'ằ': 'a',
    'ắ': 'a',
    'ặ': 'a',
    'ẳ': 'a',
    'ẵ': 'a',
    'è': 'e',
    'é': 'e',
    'ẹ': 'e',
    'ẻ': 'e',
    'ẽ': 'e',
    'ê': 'e',
    'ề': 'e',
    'ế': 'e',
    'ệ': 'e',
    'ể': 'e',
    'ễ': 'e',
    'ì': 'i',
    'í': 'i',
    'ị': 'i',
    'ỉ': 'i',
    'ĩ': 'i',
    'ò': 'o',
    'ó': 'o',
    'ọ': 'o',
    'ỏ': 'o',
    'õ': 'o',
    'ô': 'o',
    'ồ': 'o',
    'ố': 'o',
    'ộ': 'o',
    'ổ': 'o',
    'ỗ': 'o',
    'ơ': 'o',
    'ờ': 'o',
    'ớ': 'o',
    'ợ': 'o',
    'ở': 'o',
    'ỡ': 'o',
    'ù': 'u',
    'ú': 'u',
    'ụ': 'u',
    'ủ': 'u',
    'ũ': 'u',
    'ư': 'u',
    'ừ': 'u',
    'ứ': 'u',
    'ự': 'u',
    'ử': 'u',
    'ữ': 'u',
    'ỳ': 'y',
    'ý': 'y',
    'ỵ': 'y',
    'ỷ': 'y',
    'ỹ': 'y',
    'đ': 'd',
  };

  final buffer = StringBuffer();
  for (final rune in text.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(map[ch] ?? ch);
  }

  return buffer.toString().replaceAll(RegExp(r'[\u0300-\u036f]'), '');
}
