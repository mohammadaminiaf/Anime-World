import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  //! Handle what happens when you make a request
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

    // final token = GlobalState.instance.userToken;
    // if (token != null && token.isNotEmpty) {
    //   options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
    // }

    return handler.next(options);
  }

  //! Handle what happens when you receive a response
  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      // Handle 401 unauthorized error
      await _handleUnauthorizedError();
    }
    return handler.next(response);
  }

  //! Handle what happens when you receive an error
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle 401 unauthorized error
      await _handleUnauthorizedError();
    }
    return handler.next(err);
  }

  //! Handle 401 unauthorized error
  Future<void> _handleUnauthorizedError() async {
    // TODO: Call refresh token here or maybe sign the user out.
  }
}
