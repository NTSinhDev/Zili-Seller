import 'package:flutter/foundation.dart';

class Options {
  final String name;
  final List<String> values;
  Options({required this.name, required this.values});

  factory Options.fromMap(Map<String, dynamic> map) {
    return Options(
      name: map['name'] as String,
      values: List<String>.from((map['values'])),
    );
  }

  @override
  bool operator ==(covariant Options other) {
    if (identical(this, other)) return true;

    return other.name == name && listEquals(other.values, values);
  }

  @override
  int get hashCode => name.hashCode ^ values.hashCode;
}
