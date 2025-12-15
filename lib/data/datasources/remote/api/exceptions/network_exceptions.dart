/// Base class for network-related exceptions.
class NetworkException implements Exception {
  final String message;
  final dynamic data;

  const NetworkException(this.message, {this.data});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when a request times out.
class TimeoutException extends NetworkException {
  const TimeoutException(super.message, {super.data});

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown when server returns 400 Bad Request.
class BadRequestException extends NetworkException {
  const BadRequestException(super.message, {super.data});

  @override
  String toString() => 'BadRequestException: $message';
}

/// Exception thrown when server returns 401 Unauthorized.
class UnauthorizedException extends NetworkException {
  const UnauthorizedException(super.message, {super.data});

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exception thrown when server returns 5xx errors.
class ServerException extends NetworkException {
  const ServerException(super.message, {super.data});

  @override
  String toString() => 'ServerException: $message';
}

