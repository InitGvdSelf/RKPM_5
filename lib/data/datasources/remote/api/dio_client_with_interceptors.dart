import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/api/interceptors/auth_interceptor.dart';
import 'package:rkpm_5/data/datasources/remote/api/interceptors/error_interceptor.dart';
import 'package:rkpm_5/data/datasources/remote/api/interceptors/logging_interceptor.dart';

class DioClientWithInterceptors {
  final Dio dio;

  DioClientWithInterceptors({
    required String baseUrl,
    required String apiKey,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Order matters (as in many методички): auth -> logging -> error mapping
    dio.interceptors.addAll([
      AuthInterceptor(apiKey: apiKey),
      LoggingInterceptor(),
      ErrorMappingInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio.post<T>(path, data: data, queryParameters: queryParameters);
  }
}
