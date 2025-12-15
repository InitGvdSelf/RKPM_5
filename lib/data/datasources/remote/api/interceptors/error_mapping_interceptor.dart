import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/api/exceptions/network_exceptions.dart';

/// Interceptor that maps Dio errors to custom network exceptions.
class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    NetworkException mappedException;

    // Handle timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      mappedException = TimeoutException(
        'Request timeout',
        data: err.response?.data,
      );
    }
    // Handle bad response errors
    else if (err.type == DioExceptionType.badResponse && err.response != null) {
      final statusCode = err.response!.statusCode!;
      final data = err.response!.data;

      if (statusCode == 400) {
        mappedException = BadRequestException(
          'Bad request (400)',
          data: data,
        );
      } else if (statusCode == 401) {
        mappedException = UnauthorizedException(
          'Unauthorized (401)',
          data: data,
        );
      } else if (statusCode >= 500 && statusCode < 600) {
        mappedException = ServerException(
          'Server error ($statusCode)',
          data: data,
        );
      } else {
        mappedException = NetworkException(
          'HTTP error ($statusCode)',
          data: data,
        );
      }
    }
    // Handle other network errors
    else {
      mappedException = NetworkException(
        'Network error',
        data: err.response?.data,
      );
    }

    // Create new DioException with mapped exception
    final newErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: mappedException,
      message: mappedException.message,
    );

    handler.reject(newErr);
  }
}

