import 'package:dio/dio.dart';
import 'package:zili_coffee/res/res.dart';

class Printer {
  final String name;
  final String _ip;
  final String _api;
  final String _pingApi;
  final Map<String, dynamic> _config;

  bool isAvailable = false;

  late final Future<bool> availabilityFuture;

  Printer({
    required this.name,
    required String ip,
    required String api,
    required String pingApi,
    required Map<String, dynamic> config,
  })  : _ip = ip,
        _api = api,
        _pingApi = pingApi,
        _config = config {
    availabilityFuture = _tryPingToLocalServer();
  }

  Future<bool> _tryPingToLocalServer() async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

      final response = await dio.get(_pingApi);

      isAvailable = response.statusCode == 200;

      return isAvailable;
    } catch (_) {
      isAvailable = false;
      return false;
    }
  }

  String get ip => _ip;
  String get apiUrl => _api;
  Map<String, dynamic> get configRequest => _config;

  factory Printer.fromMap(Map<String, dynamic> map) {
    return Printer(
      name: map['name']?.toString() ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      ip: map['ip']?.toString() ?? "",
      api: map['api']?.toString() ?? "",
      pingApi: map['pingApi']?.toString() ?? "",
      config: map['config'] != null && map['config'] is Map?
          ? Map<String, dynamic>.from(map['config'] as Map)
          : <String, dynamic>{},
    );
  }
}