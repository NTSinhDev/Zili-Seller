import 'dart:math';

import 'package:intl/intl.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../res/res.dart';

const _kMaxDecimalDigits = 5;
final int _kDecimalScale = pow(10, _kMaxDecimalDigits).toInt();
// Mở rộng NumberFormat để tắt tự làm tròn lên bằng cách cắt bỏ phần dư.
String _formatWithoutRounding(
  num value,
  NumberFormat format,
  int decimalDigits,
) {
  if (decimalDigits == 0) return format.format(value.truncate());

  // Truncate to exact decimal digits
  final multiplier = pow(10, decimalDigits);
  final truncatedValue = (value * multiplier).truncateToDouble() / multiplier;
  return format.format(truncatedValue);
}

NumberFormat _enFormatCurrency(int decimalDigits) {
  return NumberFormat.currency(
    locale: 'en_US',
    customPattern: '#,##0${decimalDigits > 0 ? '.0' : ''}',
    symbol: '',
    decimalDigits: decimalDigits,
  );
}

NumberFormat _viFormatCurrency(int decimalDigits, {String? symbol}) {
  return NumberFormat.currency(
    locale: "vi_VN",
    customPattern: '#,##0${decimalDigits > 0 ? '.0' : ''}',
    symbol: symbol,
    decimalDigits: decimalDigits,
  );
}

enum NumOp { add, subtract, multiply, divide }

extension NumExt on num {
  String get removeTrailingZero {
    String result = toStringAsFixed(_kMaxDecimalDigits);
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r"0*$"), "");
      result = result.replaceAll(RegExp(r"\.$"), "");
    }
    return result;
  }

  String get decimalValueInput {
    return removeTrailingZero.replaceAll(".", ",");
  }

  String get twoDecimal {
    return double.parse(toStringAsFixed(2)).removeTrailingZero;
  }

  String get decimal {
    return double.parse(toStringAsFixed(1)).removeTrailingZero;
  }

  /// Format number kiểu US (không ký hiệu), tự bỏ đuôi .0/.00
  /// - Trả "0" nếu null/0
  /// - Số nguyên: không phần thập phân; số thập phân: tối đa 5 chữ số, bỏ 0 cuối
  String get toUSD {
    if (isNull || !isNotZero) return "0";

    final decimalDigits = this % 1 == 0 ? 0 : _kMaxDecimalDigits;
    final format = _viFormatCurrency(decimalDigits);
    final raw = _formatWithoutRounding(this, format, decimalDigits);
    return _trimTrailingZeros(raw);
  }

  bool get isNotZero => !(this == 0);

  /// Input: 87000 => Output: 87.000đ
  /// Input: 87000.5 => Output: 87.000,5đ
  /// Input: 1234567.89 => Output: 1.234.567,89đ
  String toPrice() {
    if (this <= 0) return "0${AppConstant.strings.VND}";

    final decimalDigits = this % 1 == 0 ? 0 : _kMaxDecimalDigits;
    final format = _viFormatCurrency(
      decimalDigits,
      symbol: AppConstant.strings.VND,
    );
    final raw = _formatWithoutRounding(this, format, decimalDigits);
    return "${_trimTrailingZeros(raw)}${AppConstant.strings.VND}";
  }

  String _trimTrailingZeros(String value) {
    // vi_VN format: thousands separator is '.', decimal separator is ','
    final match = RegExp(r'^(\D*)([\d\.]+)(,\d+)?(.*)$').firstMatch(value);
    if (match == null) {
      // Fallback cho truong hop en_US hoac ki tu la la
      final enMatch = RegExp(r'^(\D*)([\d,]+)(\.\d+)?(.*)$').firstMatch(value);
      if (enMatch == null) return value;
      final prefix = enMatch.group(1) ?? '';
      final intPart = enMatch.group(2) ?? '';
      final fracPart = enMatch.group(3);
      final suffix = enMatch.group(4) ?? '';
      if (fracPart == null) return '$prefix$intPart$suffix';
      var frac = fracPart.replaceFirst(RegExp(r'0+$'), '');
      if (frac == '.') frac = '';
      return '$prefix$intPart$frac$suffix';
    }
    final prefix = match.group(1) ?? '';
    final intPart = match.group(2) ?? '';
    final fracPart = match.group(3);
    final suffix = match.group(4) ?? '';
    if (fracPart == null) return '$prefix$intPart$suffix';
    var frac = fracPart.replaceFirst(RegExp(r'0+$'), '');
    if (frac == ',') frac = '';
    return '$prefix$intPart$frac$suffix';
  }

  static num? tryParseComma(String? value) {
    return num.tryParse((value ?? '').replaceAll(',', '.'));
  }

  // num operate(NumOp op, int value) {
  //   final str = toString();

  //   final parts = str.split('.');

  //   final intPart = int.parse(parts[0]);
  //   final decimalPart = parts.length > 1 ? parts[1] : '';

  //   int newInt;

  //   switch (op) {
  //     case NumOp.add:
  //       newInt = intPart + value;
  //       break;
  //     case NumOp.subtract:
  //       newInt = intPart - value;
  //       break;
  //   }

  //   final resultStr = decimalPart.isEmpty ? '$newInt' : '$newInt.$decimalPart';

  //   return num.parse(resultStr);
  // }

  num operate(NumOp op, num value) {
    final int scaledA = (this * _kDecimalScale).round();
    final int scaledB = (value * _kDecimalScale).round();

    late int result;

    switch (op) {
      case NumOp.add:
        result = scaledA + scaledB;
        return result / _kDecimalScale;
      case NumOp.subtract:
        result = scaledA - scaledB;
        return result / _kDecimalScale;
      case NumOp.multiply:
        result = (scaledA * scaledB) ~/ _kDecimalScale;
        return result / _kDecimalScale;
      case NumOp.divide:
        if (scaledB == 0) {
          throw Exception('Division by zero');
          return 0;
        }
        result = (scaledA * _kDecimalScale) ~/ scaledB;
        return result / _kDecimalScale;
    }
  }
}

extension NumNullableExt on num? {
  /// Input: 87000 => Output: 87.000đ
  /// Input: 87000.5 => Output: 87.000,5đ
  /// Input: 1234567.89 => Output: 1.234.567,89đ
  String get toUSD {
    if (isNull || !isNotZero) return "0";

    final decimalDigits = this! % 1 == 0 ? 0 : _kMaxDecimalDigits;
    final format = _viFormatCurrency(decimalDigits);
    final raw = _formatWithoutRounding(this!, format, decimalDigits);
    return _trimTrailingZeros(raw);
  }

  bool get isNotZero => !(this == 0);

  /// Input: 87000 => Output: 87.000đ
  /// Input: 87000.5 => Output: 87.000,5đ
  /// Input: 1234567.89 => Output: 1.234.567,89đ
  String toPrice([String? unit]) {
    if (isNull || !isNotZero || (this ?? 0) <= 0) {
      return "0${unit ?? AppConstant.strings.VND}";
    }

    final decimalDigits = this! % 1 == 0 ? 0 : _kMaxDecimalDigits;
    final format = _viFormatCurrency(
      decimalDigits,
      symbol: AppConstant.strings.VND,
    );
    final raw = _formatWithoutRounding(this!, format, decimalDigits);
    return "${_trimTrailingZeros(raw)}${unit ?? AppConstant.strings.VND}";
  }

  String _trimTrailingZeros(String value) {
    final match = RegExp(r'^(\D*)([\d\.]+)(,\d+)?(.*)$').firstMatch(value);
    if (match == null) {
      final enMatch = RegExp(r'^(\D*)([\d,]+)(\.\d+)?(.*)$').firstMatch(value);
      if (enMatch == null) return value;
      final prefix = enMatch.group(1) ?? '';
      final intPart = enMatch.group(2) ?? '';
      final fracPart = enMatch.group(3);
      final suffix = enMatch.group(4) ?? '';
      if (fracPart == null) return '$prefix$intPart$suffix';
      var frac = fracPart.replaceFirst(RegExp(r'0+$'), '');
      if (frac == '.') frac = '';
      return '$prefix$intPart$frac$suffix';
    }
    final prefix = match.group(1) ?? '';
    final intPart = match.group(2) ?? '';
    final fracPart = match.group(3);
    final suffix = match.group(4) ?? '';
    if (fracPart == null) return '$prefix$intPart$suffix';
    var frac = fracPart.replaceFirst(RegExp(r'0+$'), '');
    if (frac == ',') frac = '';
    return '$prefix$intPart$frac$suffix';
  }

  static num? tryParseComma(String? value) {
    return num.tryParse((value ?? '').replaceAll(',', '.'));
  }
}
