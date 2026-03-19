import 'dart:convert';

class Category {
  String id;
  String? imageUrl;
  String? imageUrlThumb;
  String name;
  String? nameDisplay;
  String? category;
  String? categoryCode;
  String? categoryType;

  Category({
    required this.id,
    this.imageUrl,
    this.imageUrlThumb,
    required this.name,
    this.nameDisplay,
    required this.category,
    required this.categoryCode,
    required this.categoryType,
  });

  Category copyWith({
    String? id,
    String? imageUrl,
    String? imageUrlThumb,
    String? name,
    String? nameDisplay,
    String? category,
    String? categoryCode,
    String? categoryType,
    List<dynamic>? categorySizes,
  }) {
    return Category(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrlThumb: imageUrlThumb ?? this.imageUrlThumb,
      name: name ?? this.name,
      nameDisplay: nameDisplay ?? this.nameDisplay,
      category: category ?? this.category,
      // categorySearch: categorySearch ?? this.categorySearch,
      categoryCode: categoryCode ?? this.categoryCode,
      categoryType: categoryType ?? this.categoryType,
    );
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      imageUrlThumb: map['image_url_thumb'] != null
          ? map['image_url_thumb'] as String
          : null,
      name: map['name'] as String,
      nameDisplay: map['nameDisplay'] != null ? map['nameDisplay'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      categoryCode:
          map['category_code'] != null ? map['category_code'] as String : null,
      categoryType:
          map['category_type'] != null ? map['category_type'] as String : null,
    );
  }


  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.imageUrl == imageUrl &&
        other.imageUrlThumb == imageUrlThumb &&
        other.name == name &&
        // other.nameDisplay == nameDisplay &&
        other.category == category &&
        // other.categorySearch == categorySearch &&
        other.categoryCode == categoryCode &&
        other.categoryType == categoryType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageUrl.hashCode ^
        imageUrlThumb.hashCode ^
        name.hashCode ^
        // nameDisplay.hashCode ^
        category.hashCode ^
        // categorySearch.hashCode ^
        categoryCode.hashCode ^
        categoryType.hashCode;
  }
}
