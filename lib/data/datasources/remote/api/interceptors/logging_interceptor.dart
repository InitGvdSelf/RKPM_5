import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging HTTP requests and responses.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('🌐 REQUEST: ${options.method} ${options.uri}');
      if (options.headers.isNotEmpty) {
        debugPrint('   Headers: ${options.headers}');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('   Query: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('   Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      if (response.data != null) {
        debugPrint('   Data: ${response.data}');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: ${err.type} ${err.requestOptions.uri}');
      debugPrint('   Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('   Response Data: ${err.response?.data}');
      }
    }
    handler.next(err);
  }
}

