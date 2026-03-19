import 'dart:convert';

/// Model cho SellerPermission - Match với API response structure
class SellerPermission {
  final int id;
  final String name;
  final String displayName;
  final String createdAt;
  final String updatedAt;

  SellerPermission({
    required this.id,
    required this.name,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse từ API response (JSON)
  factory SellerPermission.fromMap(Map<String, dynamic> map) {
    return SellerPermission(
      id: map['id'] as int? ?? 0,
      name: map['name']?.toString() ?? '',
      displayName: map['displayName']?.toString() ?? '',
      createdAt: map['createdAt']?.toString() ?? '',
      updatedAt: map['updatedAt']?.toString() ?? '',
    );
  }

  /// Parse từ JSON string
  factory SellerPermission.fromJson(String source) => 
      SellerPermission.fromMap(json.decode(source));

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convert to JSON string
  String toJson() => json.encode(toMap());

  /// Copy with method
  SellerPermission copyWith({
    int? id,
    String? name,
    String? displayName,
    String? createdAt,
    String? updatedAt,
  }) {
    return SellerPermission(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

