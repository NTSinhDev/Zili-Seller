import 'dart:convert';

class CustomerGroup {
  final String id;
  final String name;
  final String? code;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // New fields from API response
  final String? nameVi;
  final String? nameEn;
  final String? descriptionVi;
  final String? descriptionEn;
  final String? status; // ACTIVE, INACTIVE, etc.
  final int? discount;
  final String? paymentMethod;
  final String? defaultPrice; // RETAIL_PRICE, WHOLESALE_PRICE
  final String? type; // FIXED, AUTOMATIC
  final int totalUser;
  final bool isDefault;

  CustomerGroup({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    // New fields
    this.nameVi,
    this.nameEn,
    this.descriptionVi,
    this.descriptionEn,
    this.status,
    this.discount,
    this.paymentMethod,
    this.defaultPrice,
    this.type,
    this.totalUser = 0,
    this.isDefault = false,
  });

  factory CustomerGroup.fromMap(Map<String, dynamic> map) {
    // Support both old format (name, description, isActive) and new format (nameVi, nameEn, status)
    final nameValue = map['name']?.toString() ?? 
                      map['nameVi']?.toString() ?? 
                      '';
    final descriptionValue = map['description']?.toString() ?? 
                            map['descriptionVi']?.toString();
    final isActiveValue = map['isActive'] as bool? ?? 
                         (map['status']?.toString().toUpperCase() == 'ACTIVE');

    return CustomerGroup(
      id: map['id']?.toString() ?? '',
      name: nameValue,
      code: map['code']?.toString(),
      description: descriptionValue,
      isActive: isActiveValue,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      // New fields
      nameVi: map['nameVi']?.toString(),
      nameEn: map['nameEn']?.toString(),
      descriptionVi: map['descriptionVi']?.toString(),
      descriptionEn: map['descriptionEn']?.toString(),
      status: map['status']?.toString(),
      discount: (map['discount'] as num?)?.toInt(),
      paymentMethod: map['paymentMethod']?.toString(),
      defaultPrice: map['defaultPrice']?.toString(),
      type: map['type']?.toString(),
      totalUser: (map['totalUser'] as num?)?.toInt() ?? 0,
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  factory CustomerGroup.fromJson(String source) =>
      CustomerGroup.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      // New fields
      'nameVi': nameVi,
      'nameEn': nameEn,
      'descriptionVi': descriptionVi,
      'descriptionEn': descriptionEn,
      'status': status,
      'discount': discount,
      'paymentMethod': paymentMethod,
      'defaultPrice': defaultPrice,
      'type': type,
      'totalUser': totalUser,
      'isDefault': isDefault,
    };
  }

  String toJson() => json.encode(toMap());

  CustomerGroup copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? nameVi,
    String? nameEn,
    String? descriptionVi,
    String? descriptionEn,
    String? status,
    int? discount,
    String? paymentMethod,
    String? defaultPrice,
    String? type,
    int? totalUser,
    bool? isDefault,
  }) {
    return CustomerGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nameVi: nameVi ?? this.nameVi,
      nameEn: nameEn ?? this.nameEn,
      descriptionVi: descriptionVi ?? this.descriptionVi,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      status: status ?? this.status,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      type: type ?? this.type,
      totalUser: totalUser ?? this.totalUser,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'CustomerGroup(id: $id, name: $name, code: $code, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  /// Get display name (ưu tiên nameVi, nếu không có thì dùng name)
  String get displayName => nameVi ?? name;

  @override
  bool operator ==(covariant CustomerGroup other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.code == code &&
        other.description == description &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        description.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

