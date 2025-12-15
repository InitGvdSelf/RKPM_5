import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 🌐 Request
    // ignore: avoid_print
    print('🌐 [REQ] ${options.method} ${options.uri}');
    // ignore: avoid_print
    print('🌐 [REQ] headers=${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      // ignore: avoid_print
      print('🌐 [REQ] query=${options.queryParameters}');
    }
    if (options.data != null) {
      // ignore: avoid_print
      print('🌐 [REQ] body=${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ✅ Response
    // ignore: avoid_print
    print('✅ [RES] ${response.statusCode} ${response.requestOptions.uri}');
    // ignore: avoid_print
    print('✅ [RES] data=${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ❌ Error
    // ignore: avoid_print
    print('❌ [ERR] ${err.type} ${err.requestOptions.uri}');
    // ignore: avoid_print
    print('❌ [ERR] message=${err.message}');
    if (err.response != null) {
      // ignore: avoid_print
      print('❌ [ERR] status=${err.response?.statusCode} data=${err.response?.data}');
    }
    handler.next(err);
  }
}
