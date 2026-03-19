// Model Template - Copy và customize cho feature mới
// Model được customize để match với API response structure
//
// Hướng dẫn sử dụng:
// 1. Copy file này và đổi tên thành [model].dart
// 2. Thay thế ProductVariantExample bằng tên Model class của bạn
// 3. Thay thế ProductVariantOptionExample bằng nested Model của bạn (nếu có)
// 4. Thêm/sửa các fields để match với API response structure
// 5. Cập nhật fromMap() để parse đúng các fields từ API

// ignore_for_file: public_member_api_docs

import 'dart:convert';

/// Model cho ProductVariant - Match với API response structure
/// TODO: Đổi tên class và mô tả cho Model của bạn
class ProductVariantExample {
  // TODO: Thêm các fields match với API response
  final String id;
  final String? productId;
  final List<ProductVariantOptionExample> options; // Nested models nếu có
  final String? imageVariant;
  final double price;
  // ... other fields

  ProductVariantExample({
    required this.id,
    this.productId,
    required this.options,
    this.imageVariant,
    required this.price,
    // ... other parameters
  });

  /// Parse từ API response (JSON)
  factory ProductVariantExample.fromMap(Map<String, dynamic> map) {
    return ProductVariantExample(
      id: map['id']?.toString() ?? '',
      productId: map['productId']?.toString(),
      // Parse nested objects thành nested Models
      options: (map['options'] as List<dynamic>?)
          ?.map((item) => ProductVariantOptionExample.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      imageVariant: map['imageVariant']?.toString(),
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      // TODO: Map các fields khác từ API response
      // Handle null values và type conversions safely
    );
  }

  /// Parse từ JSON string
  factory ProductVariantExample.fromJson(String source) => 
      ProductVariantExample.fromMap(json.decode(source));

  /// Helper methods cho UI
  String get displayName => id; // TODO: Thay bằng field phù hợp
  bool get hasOptions => options.isNotEmpty;
  
  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'options': options.map((e) => e.toMap()).toList(),
      'imageVariant': imageVariant,
      'price': price,
      // ... other fields
    };
  }

  /// Convert to JSON string
  String toJson() => json.encode(toMap());

  /// Copy with method để tạo instance mới với một số fields thay đổi
  ProductVariantExample copyWith({
    String? id,
    String? productId,
    List<ProductVariantOptionExample>? options,
    String? imageVariant,
    double? price,
    // ... other fields
  }) {
    return ProductVariantExample(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      options: options ?? this.options,
      imageVariant: imageVariant ?? this.imageVariant,
      price: price ?? this.price,
      // ... other fields
    );
  }
}

/// Nested Model Example
/// TODO: Thay bằng nested Model của bạn hoặc xóa nếu không cần
class ProductVariantOptionExample {
  final String name;
  final String value;

  ProductVariantOptionExample({
    required this.name,
    required this.value,
  });

  factory ProductVariantOptionExample.fromMap(Map<String, dynamic> map) {
    return ProductVariantOptionExample(
      name: map['name']?.toString() ?? '',
      value: map['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
    };
  }
}

