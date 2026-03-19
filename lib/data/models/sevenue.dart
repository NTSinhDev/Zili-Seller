// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import '../../utils/extension/date_time.dart';

class RevenueByYear {}

class RevenueByMonth {
  final String month;
  final List<RevenueByDay> revenues;
  final int stepRevenue;
  final int stepDate;
  RevenueByMonth({
    required this.month,
    required this.revenues,
    required this.stepRevenue,
    required this.stepDate,
  });

  num get totalRevenue => revenues.lastOrNull?.totalRevenue ?? 0;
  double get maxRevenue => revenues.length > 1
      ? revenues.map((e) => e.value).reduce((a, b) => a > b ? a : b)
      : revenues.firstOrNull?.value ?? 0;

  factory RevenueByMonth.fromMap(Map<String, dynamic> map, String month) {
    final revenuesData =
        map['listData'] as List<dynamic>? ??
        map['data'] as List<dynamic>? ??
        map['revenues'] as List<dynamic>? ??
        [];

    final revenues = revenuesData
        .map((item) => RevenueByDay.fromMap(item as Map<String, dynamic>))
        .toList();

    // Tính toán stepRevenue và stepDate từ danh sách revenues
    int stepRevenue = 0;
    int stepDate = 0;

    if (revenues.isNotEmpty) {
      // 1. Lấy value lớn nhất và nhỏ nhất
      final values = revenues.map((r) => r.value).toList();
      final maxValue = values.reduce((a, b) => a > b ? a : b);
      final minValue = values.reduce((a, b) => a < b ? a : b);

      // 2. Tính toán stepRevenue để chart hiển thị 5 hàng
      // Để có 5 hàng trên chart, cần chia khoảng từ minValue đến maxValue thành 4 khoảng
      // stepRevenue = khoảng cách giữa mỗi hàng (interval)
      final revenueDiff = maxValue - minValue;
      if (revenueDiff > 0) {
        // Chia thành 4 khoảng để có 5 hàng: min, min+step, min+2*step, min+3*step, max
        // stepRevenue = khoảng cách giữa mỗi hàng
        final rawStep = revenueDiff / 4; // 4 khoảng = 5 hàng

        // Làm tròn lên để đảm bảo có đủ 5 hàng và dễ đọc
        stepRevenue = _roundUpToNiceNumber(rawStep);
      } else {
        // Nếu tất cả values giống nhau, set stepRevenue = maxValue / 4 để vẫn có 5 hàng
        stepRevenue = maxValue > 0 ? _roundUpToNiceNumber(maxValue / 4) : 1;
      }

      // 3. Lấy date lớn nhất và nhỏ nhất
      final dates = revenues.map((r) => r.date).toList();
      final maxDate = dates.reduce((a, b) => a > b ? a : b);
      final minDate = dates.reduce((a, b) => a < b ? a : b);

      // 4. Tính toán stepDate = (date max - date min) / 5
      // Làm tròn lên để đảm bảo interval đủ lớn
      final dateDiff = maxDate - minDate;
      stepDate = dateDiff > 0
          ? ((dateDiff / 5).ceil())
          : 1; // Nếu tất cả cùng ngày, set stepDate = 1
    }

    return RevenueByMonth(
      month: month,
      revenues: revenues,
      stepRevenue: stepRevenue,
      stepDate: stepDate,
    );
  }

  @override
  String toString() {
    return 'RevenueByMonth(month: $month, stepRevenue: $stepRevenue, stepDate: $stepDate, revenues: ${revenues.map((e) => e.toString()).join(', ')})';
  }

  /// Làm tròn lên số đến số tròn (nice number) để dễ đọc trên chart
  /// Ví dụ: 12152200 -> 15000000, 2430440 -> 2500000
  static int _roundUpToNiceNumber(double value) {
    if (value <= 0) return 1;

    // Tính số chữ số (magnitude)
    final logValue = log(value) / ln10;
    final magnitude = logValue.floor();
    final factor = pow(10, magnitude).toInt();

    // Làm tròn lên đến bội số của factor/2 hoặc factor
    final normalized = value / factor;
    int rounded;

    if (normalized <= 1) {
      rounded = 1;
    } else if (normalized <= 2) {
      rounded = 2;
    } else if (normalized <= 5) {
      rounded = 5;
    } else {
      rounded = 10;
    }

    return (rounded * factor).toInt();
  }
}

class RevenueByDay {
  final int date; // Day of month (1-31)
  final double value;
  final num totalRevenue;
  RevenueByDay({
    required this.date,
    required this.value,
    required this.totalRevenue,
  });

  factory RevenueByDay.fromMap(Map<String, dynamic> map) {
    // Parse date from ISO string từ server và convert timezone sang client
    // Sử dụng parseFromServerTimezone để đảm bảo hiển thị đúng theo client timezone
    int day = 1;
    final dateStr = map['date']?.toString();
    if (dateStr != null && dateStr.isNotEmpty) {
      // Sử dụng extension method parseFromServerTimezone để parse và convert timezone
      final dateTime = dateStr.parseFromServerTimezone();
      if (dateTime != null) {
        // Lấy day từ DateTime đã được convert sang client timezone
        day = dateTime.day;
      } else {
        // Fallback: nếu parse failed, thử extract day từ string
        try {
          final parts = dateStr.split('-');
          if (parts.length >= 3) {
            day = int.tryParse(parts[2].split('T')[0]) ?? 1;
          }
        } catch (e) {
          // Keep default day = 1
        }
      }
    }

    final valueNum = map['value'] as num? ?? 0;
    final value = valueNum.toDouble();

    final totalRevenueNum = map['valueIncreasing'] != null
        ? map['valueIncreasing'] as num? ?? 0
        : 0;
    return RevenueByDay(date: day, value: value, totalRevenue: totalRevenueNum);
  }

  @override
  String toString() {
    return 'RevenueByDay(date: $date, value: $value)';
  }
}
