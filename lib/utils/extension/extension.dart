export 'build_context.dart';
export 'date_time.dart';
export 'duration.dart';
export 'list.dart';
export 'string.dart';
export 'file.dart';
export 'int.dart';
export 'num.dart';
export 'payment_method_extension.dart';

extension General<T> on T? {
  bool get isNull => this == null ? true : false;
  bool get isNotNull => this != null ? true : false;
  bool get isString => this is String ? true : false;
  bool get isDateTime => this is DateTime ? true : false;
  bool get isInt => this is int ? true : false;
  bool get isDouble => this is double ? true : false;
}
