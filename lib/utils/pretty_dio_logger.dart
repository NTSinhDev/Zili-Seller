
// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'dart:math' as math;

import 'package:dio/dio.dart';

class PrettyDioLogger extends Interceptor {
  PrettyDioLogger({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 90,
    this.compact = true,
    this.logPrint = print,
  });

  /// Print request \[Options\]
  final bool request;

  /// Print request header \[Options.headers\]
  final bool requestHeader;

  /// Print request data \[Options.data\]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var logStr = '';
    if (request) {
      logStr += _printRequestHeader(options);
    }
    if (requestHeader) {
      logStr +=
          _printMapAsTable(options.queryParameters, header: 'Query Parameters');
      final requestHeaders = <String, dynamic>{}..addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout;
      requestHeaders['receiveTimeout'] = options.receiveTimeout;
      logStr += _printMapAsTable(requestHeaders, header: 'Headers');
      logStr += _printMapAsTable(options.extra, header: 'Extras');
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) {
          logStr +=
              _printMapAsTable(options.data as Map?, header: 'Body') + '\n';
        }

        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          logStr += _printMapAsTable(
                formDataMap,
                header: 'Form data | ${data.boundary}',
              ) +
              '\n';
        } else {
          logStr += _printBlock(data.toString()) + '\n';
        }
      }
    }

    logPrint(logStr);
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    var logStr = '';
    if (error) {
      if (err.type == DioExceptionType.badResponse) {
        final uri = err.response?.requestOptions.uri;
        logStr += _printBoxed(
              header:
                  'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
              text: uri.toString(),
            ) +
            '\n';
        if (err.response != null && err.response?.data != null) {
          logStr += '╔ ${err.type.toString()}' '\n';
          logStr += _printResponse(err.response!) + '\n';
        }
        logStr += _printLine('╚') + '\n';
        logStr += '\n';
      } else {
        logStr +=
            _printBoxed(header: 'DioError ║ ${err.type}', text: err.message) +
                '\n';
      }
    }

    logPrint(logStr);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    var logStr = '';
    logStr += _printResponseHeader(response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      logStr += _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      logStr += '╔ Body\n';
      logStr += '║\n';
      logStr += '║  $response\n';
      logStr += '║\n';
      logStr += _printLine('╚') + '\n';
    }

    logPrint(logStr);
    super.onResponse(response, handler);
  }

  String _printBoxed({String? header, String? text}) {
    var logStr = '\n';
    logStr += '╔╣ $header\n';
    logStr += '║  $text\n';
    logStr += _printLine('╚');
    return logStr;

    // logPrint('');
    // logPrint('╔╣ $header');
    // logPrint('║  $text');
    // _printLine('╚');
  }

  String _printResponse(Response<dynamic> response) {
    var logStr = '';
    if (response.data != null) {
      if (response.data is Map) {
        logStr += _printPrettyMap(response.data as Map);
      } else if (response.data is List) {
        logPrint('║${_indent()}[');
        logStr += _printList(response.data as List);
        logPrint('║${_indent()}[');
      } else {
        logStr += _printBlock(response.data.toString());
      }
    }

    return logStr;
  }

  String _printResponseHeader(Response<dynamic> response) {
    var logStr = '';
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    final now = DateTime.now();
    logStr += _printBoxed(
      header:
          '${now.toString()} ║ Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}',
      text: uri.toString(),
    );
    return logStr;
  }

  String _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    final now = DateTime.now();
    final logStr = _printBoxed(
      header: '${now.toString()} ║ Request ║ $method ',
      text: uri.toString(),
    );
    return logStr;
  }

  String _printLine([String pre = '', String suf = '╝\n']) =>
      '$pre${'═' * maxWidth}$suf';

  String _printKV(String? key, Object? v) {
    var logStr = '';
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logStr += '$pre\n';
      logStr += _printBlock(msg);
    } else {
      logStr += '$pre$msg\n';
    }

    return logStr;
  }

  String _printBlock(String msg) {
    var logStr = '';
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      // logPrint((i >= 0 ? '║ ' : '') +
      //     msg.substring(i * maxWidth,
      //         math.min<int>(i * maxWidth + maxWidth, msg.length)));

      logStr += (i >= 0 ? '║ ' : '') +
          msg.substring(
            i * maxWidth,
            math.min<int>(i * maxWidth + maxWidth, msg.length),
          ) +
          '\n';
    }

    return logStr;
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  String _printPrettyMap(
    Map<dynamic, dynamic> data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var logStr = '';
    var _tabs = tabs;
    final isRoot = _tabs == initialTab;
    final initialIndent = _indent(_tabs);
    _tabs++;

    if (isRoot || isListItem) logStr += '║$initialIndent{\n';

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          logStr += '║${_indent(_tabs)} $key: $value${!isLast ? ',' : ''}' '\n';
        } else {
          logStr += '║${_indent(_tabs)} $key: {' '\n';
          logStr += _printPrettyMap(value, tabs: _tabs) + '\n';
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          logStr += '║${_indent(_tabs)} $key: ${value.toString()}' '\n';
        } else {
          logStr += '║${_indent(_tabs)} $key: [' '\n';
          logStr += _printList(value, tabs: _tabs);
          logStr += '║${_indent(_tabs)} ]${isLast ? '' : ','}' '\n';
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(_tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logStr +=
                '║${_indent(_tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}'
                '\n';
          }
        } else {
          logStr += '║${_indent(_tabs)} $key: $msg${!isLast ? ',' : ''}' '\n';
        }
      }
    });

    logStr += '║$initialIndent}${isListItem && !isLast ? ',' : ''}' '\n';
    return logStr;
  }

  String _printList(List<dynamic> list, {int tabs = initialTab}) {
    var logStr = '';
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          logStr += '║${_indent(tabs)}  $e${!isLast ? ',' : ''}' '\n';
        } else {
          logStr += _printPrettyMap(
            e,
            tabs: tabs + 1,
            isListItem: true,
            isLast: isLast,
          );
        }
      } else {
        logStr += '║${_indent(tabs + 2)} $e${isLast ? '' : ','}' '\n';
      }
    });

    return logStr;
  }

  bool _canFlattenMap(Map<dynamic, dynamic> map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List<dynamic> list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  String _printMapAsTable(Map<dynamic, dynamic>? map, {String? header}) {
    var logStr = '';
    if (map == null || map.isEmpty) return logStr;

    logStr += '╔ $header\n';
    map.forEach(
      (dynamic key, dynamic value) => logStr += _printKV(key.toString(), value),
    );
    logStr += _printLine('╚');
    return logStr;

    // logPrint('╔ $header ');
    // map.forEach(
    //     (dynamic key, dynamic value) => _printKV(key.toString(), value));
    // _printLine('╚');
  }
}
