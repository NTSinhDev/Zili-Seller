import 'dart:convert';

class DeliveryGroup {
  final String id;
  final String nameEn;
  final String nameVi;
  final String code;
  final String? logoUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DeliveryGroup({
    required this.id,
    required this.nameEn,
    required this.nameVi,
    required this.code,
    this.logoUrl,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryGroup.fromMap(Map<String, dynamic> map) {
    return DeliveryGroup(
      id: map['id']?.toString() ?? '',
      nameEn: map['nameEn']?.toString() ?? '',
      nameVi: map['nameVi']?.toString() ?? '',
      code: map['code']?.toString() ?? '',
      logoUrl: map['logoUrl']?.toString(),
      isActive: map['isActive'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    );
  }

  factory DeliveryGroup.fromJson(String source) =>
      DeliveryGroup.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameVi': nameVi,
      'code': code,
      'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  /// Get display name (ưu tiên nameVi, nếu không có thì dùng nameEn)
  String get displayName => nameVi.isNotEmpty ? nameVi : nameEn;

  DeliveryGroup copyWith({
    String? id,
    String? nameEn,
    String? nameVi,
    String? code,
    String? logoUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryGroup(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameVi: nameVi ?? this.nameVi,
      code: code ?? this.code,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'DeliveryGroup(id: $id, nameEn: $nameEn, nameVi: $nameVi, code: $code, logoUrl: $logoUrl, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant DeliveryGroup other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nameEn == nameEn &&
        other.nameVi == nameVi &&
        other.code == code &&
        other.logoUrl == logoUrl &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nameEn.hashCode ^
        nameVi.hashCode ^
        code.hashCode ^
        logoUrl.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

