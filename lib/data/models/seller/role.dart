import 'dart:convert';
import 'seller_permission.dart';

/// Model cho Role - Match với API response structure
class Role {
  final int id;
  final String name;
  final String key;
  final String? grand;
  final bool status;
  final bool isShow;
  final String createdById;
  final String updatedAt;
  final String createdAt;
  final List<SellerPermission> sellerPermissions;
  final List<dynamic> users; // Có thể là List<User> sau này

  Role({
    required this.id,
    required this.name,
    required this.key,
    this.grand,
    required this.status,
    required this.isShow,
    required this.createdById,
    required this.updatedAt,
    required this.createdAt,
    required this.sellerPermissions,
    required this.users,
  });

  /// Parse từ API response (JSON)
  factory Role.fromMap(Map<String, dynamic> map) {
    final permissionsData = map['sellerPermissions'] as List<dynamic>? ?? [];
    final permissions = permissionsData
        .map((item) => SellerPermission.fromMap(item as Map<String, dynamic>))
        .toList();

    return Role(
      id: map['id'] as int? ?? 0,
      name: map['name']?.toString() ?? '',
      key: map['key']?.toString() ?? '',
      grand: map['grand']?.toString(),
      status: map['status'] as bool? ?? false,
      isShow: map['isShow'] as bool? ?? false,
      createdById: map['createdById']?.toString() ?? '',
      updatedAt: map['updatedAt']?.toString() ?? '',
      createdAt: map['createdAt']?.toString() ?? '',
      sellerPermissions: permissions,
      users: map['users'] as List<dynamic>? ?? [],
    );
  }

  /// Parse từ JSON string
  factory Role.fromJson(String source) => 
      Role.fromMap(json.decode(source));

  /// Helper methods cho UI
  String get displayName => name;
  
  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'key': key,
      'grand': grand,
      'status': status,
      'isShow': isShow,
      'createdById': createdById,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'sellerPermissions': sellerPermissions.map((p) => p.toMap()).toList(),
      'users': users,
    };
  }

  /// Convert to JSON string
  String toJson() => json.encode(toMap());

  /// Copy with method để tạo instance mới với một số fields thay đổi
  Role copyWith({
    int? id,
    String? name,
    String? key,
    String? grand,
    bool? status,
    bool? isShow,
    String? createdById,
    String? updatedAt,
    String? createdAt,
    List<SellerPermission>? sellerPermissions,
    List<dynamic>? users,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      key: key ?? this.key,
      grand: grand ?? this.grand,
      status: status ?? this.status,
      isShow: isShow ?? this.isShow,
      createdById: createdById ?? this.createdById,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      sellerPermissions: sellerPermissions ?? this.sellerPermissions,
      users: users ?? this.users,
    );
  }
}

