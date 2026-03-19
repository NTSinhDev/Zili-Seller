import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zili_coffee/views/warehouse/packing_slip/packing_slip_details/packing_slip_details_screen.dart';

import '../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../di/dependency_injection.dart';
import '../../../utils/enums/warehouse_enum.dart';
import '../../../views/quote/details/quotation_details_screen.dart';
import '../../../views/warehouse/green_beans/green_beans_screen.dart';
import '../../../views/warehouse/roasting_slip/export.dart';
import '../firebase_cloud_messaging_services.dart';

extension OnMsgInAppMixin on FCMHandler {
  Future<void> createQuotation(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final quotationCode = data["quotationCode"] != null
        ? data["quotationCode"] as String?
        : null;
    final payload = {
      "route": QuotationDetailsScreen.routeName,
      "quotationCode": quotationCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Phiếu báo giá mới!",
      body: "Bạn có phiếu báo giá mới cần xét duyệt: $quotationCode",
      payload: jsonEncode(payload),
      tag: "/quotation",
    );
  }

  Future<void> approveQuotation(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final quotationCode = data["quotationCode"] != null
        ? data["quotationCode"] as String?
        : null;
    final payload = {
      "route": QuotationDetailsScreen.routeName,
      "quotationCode": quotationCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Phiếu báo giá",
      body:
          "Phiếu báo giá của bạn đã được xét duyệt thành công: $quotationCode",
      payload: jsonEncode(payload),
      tag: "/quotation",
    );
  }

  Future<void> rejectQuotation(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final quotationCode = data["quotationCode"] != null
        ? data["quotationCode"] as String?
        : null;
    final payload = {
      "route": QuotationDetailsScreen.routeName,
      "quotationCode": quotationCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Phiếu báo giá",
      body: "Phiếu báo giá của bạn đã bị từ chối: $quotationCode",
      payload: jsonEncode(payload),
      tag: "/quotation",
    );
  }

  Future<void> newPackingSlip(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final slipCode = data["slipCode"] != null
        ? data["slipCode"] as String?
        : null;
    final payload = {
      "route": PackingSlipDetailsScreen.routeName,
      "slipCode": slipCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Phiếu đóng gói mới!",
      body: "Bạn có phiếu đóng gói mới cần xử lý: $slipCode",
      payload: jsonEncode(payload),
      tag: "/packing-slips",
    );
  }

  Future<void> exportedMaterialPackingSlip(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final slipCode = data["slipCode"] != null
        ? data["slipCode"] as String?
        : null;
    final slipItemCode = data["slipItemCode"] != null
        ? data["slipItemCode"] as String?
        : null;
    final payload = {
      "route": PackingSlipDetailsScreen.routeName,
      "slipCode": slipCode,
      "slipItemCode": slipItemCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Xuất kho nguyên liệu!",
      body: "Phiếu đóng gói $slipItemCode đã được xuất kho nguyên liệu.",
      payload: jsonEncode(payload),
      tag: "/packing-slips",
    );
  }

  Future<void> completedPackingSlip(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final slipCode = data["slipCode"] != null
        ? data["slipCode"] as String?
        : null;
    final payload = {
      "route": PackingSlipDetailsScreen.routeName,
      "slipCode": slipCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Hoàn thành phiếu đóng gói!",
      body: "Phiếu đóng gói $slipCode đã hoàn thành.",
      payload: jsonEncode(payload),
      tag: "/packing-slips",
    );
  }

  Future<void> cancelledPackingSlip(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final slipCode = data["slipCode"] != null
        ? data["slipCode"] as String?
        : null;
    final payload = {
      "route": PackingSlipDetailsScreen.routeName,
      "slipCode": slipCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Hủy phiếu đóng gói!",
      body: "Phiếu đóng gói $slipCode đã bị hủy.",
      payload: jsonEncode(payload),
      tag: "/packing-slips",
    );
  }

  /// Xử lý thông báo phiếu rang mới
  ///
  /// **Logic:**
  /// 1. Hiển thị local notification
  /// 2. Kiểm tra nếu user đang ở màn hình GreenBeansScreen (`/green-beans`)
  /// 3. Nếu đúng, tự động refresh data roasting slips từ API
  ///
  /// [context] - BuildContext để check route và navigate
  /// [data] - Data từ FCM notification, chứa `slipCode` (optional)
  Future<void> newRoastingSlip(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final slipCode = data["slipCode"] != null
        ? data["slipCode"] as String?
        : null;
    final payload = {
      "route": RoastingSlipDetailScreen.routeName,
      "slipCode": slipCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Phiếu rang mới!",
      body: "Bạn có phiếu rang mới cần xử lý: $slipCode",
      payload: jsonEncode(payload),
      tag: "/roasting-slips",
    );

    // Kiểm tra nếu user đang ở màn hình GreenBeansScreen
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == GreenBeansScreen.routeName) {
      // Refresh data roasting slips từ API
      final warehouseCubit = di<WarehouseCubit>();
      await warehouseCubit.filterRoastingSlips(
        limit: 20,
        offset: 0,
        isLoadMore: false,
        status: RoastingSlipStatus.newRequest,
      );
    }
  }

  Future<void> completedRoastingSlip(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final slipCode = data["slipCode"] != null
        ? data["slipCode"] as String?
        : null;
    final payload = {
      "route": RoastingSlipDetailScreen.routeName,
      "slipCode": slipCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Hoàn thành phiếu rang!",
      body: "Phiếu rang $slipCode đã hoàn thành.",
      payload: jsonEncode(payload),
      tag: "/roasting-slips",
    );
  }

  Future<void> cancelledRoastingSlip(
    BuildContext context, {
    Map<String, dynamic> data = const {},
  }) async {
    final slipCode = data["slipCode"] != null
        ? data["slipCode"] as String?
        : null;
    final payload = {
      "route": RoastingSlipDetailScreen.routeName,
      "slipCode": slipCode,
    };
    notificationService.showNotification(
      id: data.hashCode,
      title: "Hủy phiếu rang!",
      body: "Phiếu rang $slipCode đã bị hủy.",
      payload: jsonEncode(payload),
      tag: "/roasting-slips",
    );
  }
}
