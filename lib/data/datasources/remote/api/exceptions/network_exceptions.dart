class NetworkException implements Exception {
  final String message;
  final dynamic data;

  NetworkException(this.message, {this.data});

  @override
  String toString() => message;
}

class TimeoutException extends NetworkException {
  TimeoutException(String message, {dynamic data}) : super(message, data: data);
}

class BadRequestException extends NetworkException {
  BadRequestException(String message, {dynamic data}) : super(message, data: data);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(String message, {dynamic data}) : super(message, data: data);
}

class ServerException extends NetworkException {
  ServerException(String message, {dynamic data}) : super(message, data: data);
}