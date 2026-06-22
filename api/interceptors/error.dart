import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      throw Exception("Connection Timeout");
    }

    if (err.response?.statusCode == 404) {
      throw Exception("Resource Not Found");
    }

    if (err.response?.statusCode == 500) {
      throw Exception("Server Error");
    }

    super.onError(err, handler);
  }
}