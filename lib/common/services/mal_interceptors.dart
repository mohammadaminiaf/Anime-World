import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MalInterceptors extends Interceptor {
  //! Control what happens when you make an Api Request
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
        ),
      );
    }

    final clientId = dotenv.env['CLIENT_ID'] ?? '';
    if (clientId.isNotEmpty) {
      options.headers.putIfAbsent('X-MAL-CLIENT-ID', () => clientId);
    }

    return handler.next(options);
  }

  //! Control what happens when you receive a response
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    return handler.next(err);
  }
}
