import 'bank_info.dart';

/// Seller Payment Method Model
/// 
/// Model mới cho API /seller/payment-method/synthetic/active (System Service)
/// Khác với PaymentMethod cũ để tránh breaking changes
class SellerPaymentMethod {
  final String id;
  final String nameVi;
  final String nameEn;
  final String method; // Payment method enum (e.g., "CASH")
  final String? icon;
  final int position;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double minimumOrder;
  final String? bankCode;
  final BankInfo? bankInfo;

  SellerPaymentMethod({
    required this.id,
    required this.nameVi,
    required this.nameEn,
    required this.method,
    this.icon,
    required this.position,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    required this.minimumOrder,
    this.bankCode,
    this.bankInfo,
  });

  String get paymentMethodName => nameVi.isNotEmpty ? nameVi : nameEn;

  bool compareWith(SellerPaymentMethod other) {
    bool compareBankInfo = true;
    if(bankInfo != null && other.bankInfo != null) {
      compareBankInfo = bankInfo?.id == other.bankInfo?.id;
    }
    return id == other.id && method == other.method && compareBankInfo;
  }

  factory SellerPaymentMethod.fromMap(Map<String, dynamic> map) {
    return SellerPaymentMethod(
      id: map['id']?.toString() ?? '',
      nameVi: map['nameVi'] ?? '',
      nameEn: map['nameEn'] ?? '',
      method: map['method'] ?? '',
      icon: map['icon'],
      position: map['position'] ?? 0,
      isActive: map['isActive'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      minimumOrder: (map['minimumOrder'] ?? 0).toDouble(),
      bankCode: map['bankCode'],
      bankInfo: map['bankInfo'] != null
          ? BankInfo.fromMap(map['bankInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameVi': nameVi,
      'nameEn': nameEn,
      'method': method,
      'icon': icon,
      'position': position,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'minimumOrder': minimumOrder,
      'bankCode': bankCode,
      'bankInfo': bankInfo?.toMap(),
    };
  }

  /// Get display name (prefer Vietnamese, fallback to English)
  String get displayName => nameVi.isNotEmpty ? nameVi : nameEn;

  /// Copy with method for immutability
  SellerPaymentMethod copyWith({
    String? id,
    String? nameVi,
    String? nameEn,
    String? method,
    String? icon,
    int? position,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? minimumOrder,
    String? bankCode,
    BankInfo? bankInfo,
  }) {
    return SellerPaymentMethod(
      id: id ?? this.id,
      nameVi: nameVi ?? this.nameVi,
      nameEn: nameEn ?? this.nameEn,
      method: method ?? this.method,
      icon: icon ?? this.icon,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      bankCode: bankCode ?? this.bankCode,
      bankInfo: bankInfo ?? this.bankInfo,
    );
  }
}

