import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/api/interceptors/error_mapping_interceptor.dart';
import 'package:rkpm_5/data/datasources/remote/api/interceptors/logging_interceptor.dart';

/// Wrapper around Dio with interceptors for logging and error mapping.
class DioClientWithInterceptors {
  final Dio _dio;

  /// Access to underlying Dio instance (for Options, etc.)
  Dio get dio => _dio;

  /// Creates a Dio client with interceptors.
  /// 
  /// [baseUrl] - Base URL for all requests
  /// [defaultHeaders] - Default headers to include in all requests
  DioClientWithInterceptors({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (defaultHeaders != null) ...defaultHeaders,
            },
          ),
        ) {
    // Add interceptors in order
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorMappingInterceptor());
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

