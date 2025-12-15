import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient({
    required String baseUrl,
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
        );
}
