import 'package:dio/dio.dart';
import 'package:fitme/api/Endpoint.dart';
import 'package:fitme/api/interceptors/error.dart';
import 'package:fitme/api/interceptors/logger.dart';

// dio client worker for sending requests
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    // main worker instance
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // final token = await LocalDatabase.instance.read(DbKeys.token);
          // if (token != null && token.isNotEmpty) {
          //   options.headers["Authorization"] = "Bearer $token";
          // } else {
          //   options.headers.remove("Authorization");
          // }
          // handler.next(options);
        },
      ),
    );
    // interceptors
    dio.interceptors.addAll([LoggingInterceptor(), ErrorInterceptor()]);
  }

  void handleStatusCode({
    required Response response,
    required void Function(dynamic data) onSuccess,
    required void Function(String message, int? statusCode) onError,
  }) {
    final statusCode = response.statusCode;

    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      onSuccess(response.data);
      return;
    }

    final message = response.statusMessage ?? "Request failed";
    onError(message, statusCode);
  }

  Future<void> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required void Function(dynamic data) onSuccess,
    required void Function(String message, int? statusCode) onError,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      handleStatusCode(
        response: response,
        onSuccess: onSuccess,
        onError: onError,
      );
    } on DioException catch (e) {
      onError(
        e.response?.statusMessage ?? e.message ?? "Request failed",
        e.response?.statusCode,
      );
    } catch (e) {
      onError(e.toString(), null);
    }
  }

  Future<void> postRequest({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    required void Function(dynamic data) onSuccess,
    required void Function(String message, int? statusCode) onError,
  }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        queryParameters: queryParameters,
      );

      handleStatusCode(
        response: response,
        onSuccess: onSuccess,
        onError: onError,
      );
    } on DioException catch (e) {
      onError(
        e.response?.statusMessage ?? e.message ?? "Request failed",
        e.response?.statusCode,
      );
    } catch (e) {
      onError(e.toString(), null);
    }
  }
}
