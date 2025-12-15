import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String apiKey;

  AuthInterceptor({required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // OpenWeatherMap expects api key in query: appid=...
    options.queryParameters['appid'] = apiKey;
    handler.next(options);
  }
}
