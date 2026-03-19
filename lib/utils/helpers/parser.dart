import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:zili_coffee/utils/extension/extension.dart';
import 'dart:typed_data';

import 'crash_logger.dart';

sealed class StringOrBytes {}

class StringValue extends StringOrBytes {
  final String value;
  StringValue(this.value);
}

class BytesValue extends StringOrBytes {
  final Uint8List value;
  BytesValue(this.value);
}

Future<StringOrBytes?> smartSvgOrImageParser(
  String? svgUrl, {
  double? width,
  double? height,
}) async {
  if (svgUrl.isNull || (svgUrl ?? "").trim().isEmpty) return null;

  try {
    final response = await http.get(Uri.parse(svgUrl ?? ""));
    if (response.statusCode != 200) {
      log('❌ Failed to load SVG: ${response.statusCode}');
      return null;
    }

    final svgContent = response.body;

    // Check nếu SVG có chứa base64 PNG
    final base64Regex = RegExp(r'data:image\/png;base64,([^"]+)');
    final match = base64Regex.firstMatch(svgContent);

    if (match != null) {
      final base64Str = match.group(1)!;
      final bytes = base64Decode(base64Str);

      return BytesValue(bytes);
    }

    // Nếu không có base64, dùng flutter_svg để render
    return StringValue(svgContent);
  } catch (e) {
    // logger.e('❌ Error loading SVG: $e');
    return null;
  }
}

T catchErrorOnParseModel<T>(T Function() fn, [Map<String, dynamic>? extra]) {
  try {
    return fn();
  } on FormatException catch (e) {
    CrashLogger.tryToRecordError(
      'Lỗi parse model ${T.toString()} từ map: ${extra?.toString()}',
      error: e,
      stackTrace: .current,
    );
    throw ArgumentError("Error on parse model $T: $e");
  }
}
