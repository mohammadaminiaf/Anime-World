import 'package:anime_world/constants/endpoints.dart';
import 'package:dio/dio.dart';

import '/common/services/app_interceptors.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = createDio();
  }

  /// This method takes the dio exception and returns a related error message
  static String handleError(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please try again later.";
      case DioExceptionType.sendTimeout:
        return "Request timeout. Please try again later.";
      case DioExceptionType.receiveTimeout:
        return "Server response timeout. Please try again later.";
      case DioExceptionType.badResponse:
        // Handle non-200 responses
        final statusCode = exception.response?.statusCode;
        if (statusCode == 400) {
          return "Bad request. Please check your input.";
        } else if (statusCode == 401) {
          return "Unauthorized. Please log in again.";
        } else if (statusCode == 403) {
          return "Access denied. You do not have permission.";
        } else if (statusCode == 404) {
          return "Resource not found.";
        } else if (statusCode == 500) {
          return "Internal server error. Please try again later.";
        }
        final detail = exception.response?.data['detail'];
        if (detail != null) {
          return detail;
        }

        return "Received invalid status code: $statusCode.";
      case DioExceptionType.cancel:
        return "Request was cancelled. Please try again.";
      case DioExceptionType.unknown:
        return "An unexpected error occurred. Please check your internet connection.";
      default:
        return 'Error: ${exception.response?.data ?? exception.message}';
    }
  }

  static Dio createDio() {
    final dio = Dio()
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // 'Content-Type': 'multipart/form-data',
      }
      ..interceptors.add(AppInterceptors());

    return dio;
  }

  //! Post method
  Future<dynamic> post(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  //! Make Get request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  //! Make Put request
  Future<dynamic> put(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  //! Make Delete request
  Future<dynamic> delete(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  //! Make patch request
  Future<dynamic> patch(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }
}
