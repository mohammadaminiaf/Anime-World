import 'package:dio/dio.dart';

import '/common/services/mal_interceptors.dart';

class MalClient {
  static final MalClient _instance = MalClient._internal();
  factory MalClient() => _instance;

  late final Dio _dio;

  Dio get dio => _dio;

  MalClient._internal() {
    _dio = _createDio();
  }

  static Dio _createDio() {
    final dio = Dio()
      ..options.baseUrl = 'https://api.myanimelist.net/v2/'
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      ..interceptors.add(MalInterceptors());

    return dio;
  }
}
