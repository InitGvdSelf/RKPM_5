import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/api/exceptions/network_exceptions.dart';

class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _map(err);
    // Wrap mapped exception into DioException so callers get a consistent throw path.
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: mapped.message,
      ),
    );
  }

  NetworkException _map(DioException err) {
    // Timeouts
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return TimeoutException('Request timeout', data: err.response?.data);
    }

    // HTTP errors
    if (err.type == DioExceptionType.badResponse) {
      final status = err.response?.statusCode ?? 0;
      final data = err.response?.data;
      if (status == 400) return BadRequestException('Bad request (400)', data: data);
      if (status == 401) return UnauthorizedException('Unauthorized (401)', data: data);
      if (status >= 500 && status <= 599) return ServerException('Server error ($status)', data: data);
      return NetworkException('HTTP error ($status)', data: data);
    }

    // Network / unknown
    return NetworkException('Network error', data: err.response?.data);
  }
}
