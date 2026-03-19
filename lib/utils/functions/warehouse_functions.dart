import 'package:flutter/material.dart';

import '../../res/res.dart';
import '../../services/firebase_cloud_messaging/firebase_enum.dart';
import '../enums/product_enum.dart';
import '../enums/warehouse_enum.dart';

String packingSlipStatusLabel(PackingSlipStatus? status) {
  switch (status) {
    case .completed:
      return "Hoàn thành";
    case .cancelled:
      return "Đã hủy";
    case .processing:
      return "Đang xử lý";
    case .newRequest:
      return "Yêu cầu mới";
    case .packing:
      return "Đang đóng gói";
    case .confirmed:
      return "Chờ xác nhận";
    default:
      return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }
}

Color? packingSlipStatusColor(PackingSlipStatus? status) {
  switch (status) {
    case .completed:
    case .confirmed:
      return AppColors.success;
    case .cancelled:
      return AppColors.cancel;
    case .processing:
    case .packing:
      return AppColors.warning;
    case .newRequest:
      return AppColors.info;
    default:
      return AppColors.greyC0;
  }
}

String roastingSlipStatusLabel(RoastingSlipStatus? status) {
  switch (status) {
    case .completed:
      return "Hoàn thành";
    case .cancelled:
      return "Đã hủy";
    case .roasting:
      return "Đang rang";
    case .newRequest:
      return "Yêu cầu mới";
    default:
      return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }
}

Color? roastingSlipStatusColor(RoastingSlipStatus? status) {
  switch (status) {
    case .completed:
      return AppColors.success;
    case .cancelled:
      return AppColors.cancel;
    case .roasting:
      return AppColors.warning;
    case .newRequest:
      return AppColors.info;
    default:
      return AppColors.greyC0;
  }
}

RoastingSlipStatus? roastingSlipStatusByFCMType(
  FirebaseMessagingType? fcmType,
) {
  switch (fcmType) {
    case .newRoastingSlip:
      return .newRequest;
    case .completedRoastingSlip:
      return .completed;
    case .cancelledRoastingSlip:
      return .cancelled;
    default:
      return null;
  }
}

PackingSlipStatus? packingSlipStatusByFCMType(FirebaseMessagingType? fcmType) {
  switch (fcmType) {
    case .newPackingSlip:
      return .newRequest;
    case .exportedMaterialPackingSlip:
      return .processing;
    case .completedPackingSlip:
      return .completed;
    case .cancelledPackingSlip:
      return .cancelled;
    default:
      return null;
  }
}

String? renderProductVariantCategoryCode(
  ProductVariantCategoryCode? categoryCode,
) {
  switch (categoryCode) {
    case .all:
      return 'Tất cả';
    case .brandProduct:
      return 'Thương hiệu';
    case .greenBean:
      return 'Nhân xanh';
    case .roastedBean:
      return 'Hạt rang';
    default:
      return null;
  }
}
