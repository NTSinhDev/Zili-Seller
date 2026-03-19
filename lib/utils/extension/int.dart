import 'package:intl/intl.dart';
import 'package:zili_coffee/res/res.dart';

extension IntExt on int {
  /// Input: 87000 => Output: 87.000đ
  String toPrice() {
    if (this < 0 || this == 0) return "0${AppConstant.strings.VND}";
    final format = NumberFormat("#,##0", "vi_VN");
    return "${format.format(this)}${AppConstant.strings.VND}";
  }

  static int? tryParseComma(String? value) {
    return int.tryParse((value ?? '').replaceAll(',', '.'));
  }
}
