import 'dart:ui';

import '../../res/res.dart';

Color? renderProductStatusColor(String? status) {
  switch (status) {
    case "PAUSED":
      return AppColors.scarlet;
    case "APPROVED":
      return AppColors.success;
    case "OUT_OF_STOCK":
      return AppColors.scarlet;
    default:
      return null;
  }
}

String? renderProductStatus(String? status) {
  switch (status) {
    case "APPROVED":
      return "Đang giao dịch";
    case "PAUSED":
      return "Ngừng giao dịch";
    case "OUT_OF_STOCK":
      return "Hết hàng";
    default:
      return null;
  }
}

String convertProductWeight(int? gram) {
  if (gram == null || gram == 0) return "0g";
  if (gram >= 1000 && gram % 1000 == 0) return "${gram / 1000}kg";
  return "${gram}g";
}
