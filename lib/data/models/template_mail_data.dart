// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:zili_coffee/utils/helpers/parser.dart';

class TemplateMailData {
  final String id;
  final String code;
  final String? exampleImageUrl;
  final String? name;
  final String? note;
  final Map<String, dynamic>? contentJSON;
  TemplateMailData({
    required this.id,
    required this.code,
    this.exampleImageUrl,
    this.name,
    this.note,
    this.contentJSON,
  });

  TemplateMailData copyWith({
    String? id,
    String? code,
    String? exampleImageUrl,
    String? name,
    String? note,
  }) {
    return TemplateMailData(
      id: id ?? this.id,
      code: code ?? this.code,
      exampleImageUrl: exampleImageUrl ?? this.exampleImageUrl,
      name: name ?? this.name,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'exampleImageUrl': exampleImageUrl,
      'name': name,
      'note': note,
    };
  }

  factory TemplateMailData.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel<TemplateMailData>(() {
      return TemplateMailData(
        id: map['id'],
        code: map['code'],
        exampleImageUrl: map['exampleImageUrl'] != null
            ? map['exampleImageUrl'] as String
            : null,
        name: map['name'] != null ? map['name'] as String : null,
        note: map['note'] != null ? map['note'] as String : null,
        contentJSON: map['contentJSON'] != null ? json.decode(map['contentJSON'] as String) : null,
      );
    }, map);
  }

  String toJson() => json.encode(toMap());

  factory TemplateMailData.fromJson(String source) =>
      TemplateMailData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TemplateMailData(id: $id, code: $code, exampleImageUrl: $exampleImageUrl, name: $name, note: $note)';
  }

  @override
  bool operator ==(covariant TemplateMailData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.exampleImageUrl == exampleImageUrl &&
        other.name == name &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        exampleImageUrl.hashCode ^
        name.hashCode ^
        note.hashCode;
  }
}
