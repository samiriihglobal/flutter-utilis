import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("Request => ${options.method} ${options.uri}");
    log("Headers => ${options.headers}");
    log("Data => ${options.data}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("RESPONSE => ${response.statusCode}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("ERROR => ${err.response?.statusCode}");
    log("MESSAGE => ${err.message}");
    super.onError(err, handler);
  }
}