// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BlogCategory {
  final int id;
  final String name;
  final String languageCode;
  BlogCategory({
    this.id = 1,
    required this.name,
    this.languageCode = 'vi',
  });

  static List<BlogCategory> get blogCategoryList => [
        BlogCategory(name: "Tất cả"),
        BlogCategory(name: "Nông dân"),
        BlogCategory(name: "Cách pha chế"),
        BlogCategory(name: "Cà phê"),
        BlogCategory(name: "Dòng cà phê"),
        BlogCategory(name: "Loại caffee"),
      ];

  BlogCategory copyWith({
    int? id,
    String? name,
    String? languageCode,
  }) {
    return BlogCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'languageCode': languageCode,
    };
  }

  factory BlogCategory.fromMap(Map<String, dynamic> map) {
    return BlogCategory(
      id: map['id'] as int,
      name: map['vi_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogCategory.fromJson(String source) =>
      BlogCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BlogCategory(id: $id, name: $name, languageCode: $languageCode)';

  @override
  bool operator ==(covariant BlogCategory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ languageCode.hashCode;
}
