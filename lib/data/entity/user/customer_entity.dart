/// User status enum
enum UserStatus {
  active('ACTIVE'),
  inactive('INACTIVE'),
  blocked('BLOCKED'),
  suspend('SUSPEND');

  final String value;
  const UserStatus(this.value);

  static UserStatus fromString(String? value) {
    if (value == null) return UserStatus.active;
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return UserStatus.active;
      case 'INACTIVE':
        return UserStatus.inactive;
      case 'BLOCKED':
        return UserStatus.blocked;
      case 'SUSPEND':
        return UserStatus.suspend;
      default:
        return UserStatus.active;
    }
  }
}

/// Customer role type constants
class CustomerRoleType {
  static const String normal = 'NORMAL';
  // Add other role types as needed
}

/// Customer advanced type constants
class CustomerAdvancedType {
  // Add advanced types as needed
}

/// Customer price default constants
class CustomerPriceDefault {
  static const String purchasePrice = 'PURCHASE_PRICE';
  static const String costPrice = 'COST_PRICE';
  static const String retailPrice = 'RETAIL_PRICE';
  static const String wholesalePrice = 'WHOLESALE_PRICE';
}

/// Customer Entity - mapped from TypeORM User entity
class CustomerEntity {
  final String id;
  final String? code;
  String? fullName;
  final String username;
  String? email;
  String? phone;
  final DateTime? birthday;
  String? nickname;
  final String? referralCode;
  final UserStatus status;
  final String? avatar;
  final String? country;
  final int? gender; // 0: male, 1: female, null: other
  final DateTime createdAt;
  final double currentDebt; // công nợ
  final double totalSpending; // tổng chi tiêu
  final double totalOrder; // số lượng order
  final double returnedTotalAmount; // tổng tiền đã trả hàng
  final double returnedProductQuantity; // số lượng sản phẩm trả hàng
  final double failedDeliveryTotalAmount; // tổng tiền giao thất bại
  final double failedDeliveryOrderCount; // số đơn giao giao thất bại
  final double totalPurchasedProduct; // số hàng đã mua
  final DateTime? lastPurchaseAt; // ngày cuối mua hàng
  final String? taxCode;
  final String? note;

  CustomerEntity({
    required this.id,
    this.code,
    this.fullName,
    required this.username,
    this.email,
    this.phone,
    this.birthday,
    this.nickname,
    this.referralCode,
    this.status = UserStatus.active,
    this.avatar,
    this.country,
    this.gender,
    required this.createdAt,
    this.currentDebt = 0,
    this.totalSpending = 0,
    this.totalOrder = 0,
    this.returnedTotalAmount = 0,
    this.returnedProductQuantity = 0,
    this.failedDeliveryTotalAmount = 0,
    this.failedDeliveryOrderCount = 0,
    this.totalPurchasedProduct = 0,
    this.lastPurchaseAt,
    this.taxCode,
    this.note,
  });
}

