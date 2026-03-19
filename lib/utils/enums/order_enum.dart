enum OrderTimelineProcessStatus {
  pending,
  processing,
  packed,
  dispatched,
  completed,
  cancelled;

  /// Get label in Vietnamese
  String get label {
    switch (this) {
      case OrderTimelineProcessStatus.pending:
        return "Đặt hàng";
      case OrderTimelineProcessStatus.processing:
        return "Duyệt đơn";
      case OrderTimelineProcessStatus.packed:
        return "Đóng gói";
      case OrderTimelineProcessStatus.dispatched:
        return "Xuất kho";
      case OrderTimelineProcessStatus.completed:
        return "Hoàn thành";
      case OrderTimelineProcessStatus.cancelled:
        return "Hủy đơn";
    }
  }

  /// Convert from string value (uppercase)
  static OrderTimelineProcessStatus? fromString(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'PENDING':
        return OrderTimelineProcessStatus.pending;
      case 'PROCESSING':
        return OrderTimelineProcessStatus.processing;
      case 'PACKED':
        return OrderTimelineProcessStatus.packed;
      case 'DISPATCHED':
        return OrderTimelineProcessStatus.dispatched;
      case 'COMPLETED':
        return OrderTimelineProcessStatus.completed;
      case 'CANCELLED':
      case 'CANCELED':
        return OrderTimelineProcessStatus.cancelled;
      default:
        return null;
    }
  }

  /// Get constant string value (UPPER_SNAKE_CASE)
  String get toConstant {
    switch (this) {
      case OrderTimelineProcessStatus.pending:
        return 'PENDING';
      case OrderTimelineProcessStatus.processing:
        return 'PROCESSING';
      case OrderTimelineProcessStatus.packed:
        return 'PACKED';
      case OrderTimelineProcessStatus.dispatched:
        return 'DISPATCHED';
      case OrderTimelineProcessStatus.completed:
        return 'COMPLETED';
      case OrderTimelineProcessStatus.cancelled:
        return 'CANCELLED';
    }
  }
}

enum OrderStatus { pending, processing, completed, cancelled }

enum OrderShipmentStatus {
  pendingPickup,
  delivering,
  delivered,
  returnWaiting,
  returned,
  redeliveryWaiting,
  packingCancelled;

  /// Get label in Vietnamese
  String get label {
    switch (this) {
      case OrderShipmentStatus.pendingPickup:
        return "Chờ lấy hàng";
      case OrderShipmentStatus.delivering:
        return "Đang giao hàng";
      case OrderShipmentStatus.delivered:
        return "Đã giao hàng";
      case OrderShipmentStatus.returnWaiting:
        return "Hủy giao hàng - Chờ trả hàng";
      case OrderShipmentStatus.returned:
        return "Hủy giao hàng - Đã nhận lại";
      case OrderShipmentStatus.redeliveryWaiting:
        return "Chờ giao lại";
      case OrderShipmentStatus.packingCancelled:
        return "Hủy đóng gói";
    }
  }

  /// Convert from string value (uppercase)
  static OrderShipmentStatus? fromString(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'PENDING_PICKUP':
        return OrderShipmentStatus.pendingPickup;
      case 'DELIVERING':
        return OrderShipmentStatus.delivering;
      case 'DELIVERED':
        return OrderShipmentStatus.delivered;
      case 'RETURN_WAITING':
        return OrderShipmentStatus.returnWaiting;
      case 'RETURNED':
        return OrderShipmentStatus.returned;
      case 'REDELIVERY_WAITING':
        return OrderShipmentStatus.redeliveryWaiting;
      case 'PACKING_CANCELLED':
      case 'PACKING_CANCELED':
        return OrderShipmentStatus.packingCancelled;
      default:
        return null;
    }
  }

  /// Get constant string value (UPPER_SNAKE_CASE)
  String get toConstant {
    switch (this) {
      case OrderShipmentStatus.pendingPickup:
        return 'PENDING_PICKUP';
      case OrderShipmentStatus.delivering:
        return 'DELIVERING';
      case OrderShipmentStatus.delivered:
        return 'DELIVERED';
      case OrderShipmentStatus.returnWaiting:
        return 'RETURN_WAITING';
      case OrderShipmentStatus.returned:
        return 'RETURNED';
      case OrderShipmentStatus.redeliveryWaiting:
        return 'REDELIVERY_WAITING';
      case OrderShipmentStatus.packingCancelled:
        return 'PACKING_CANCELLED';
    }
  }
}

enum QuoteStatus { pending, approved, rejected, cancelled }

enum QuoteMailType { greenBeanQuote, brandQuote, quantityQuote }