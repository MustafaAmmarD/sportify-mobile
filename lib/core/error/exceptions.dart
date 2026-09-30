/// Custom exceptions for API and network error handling.
///
/// These are thrown by the data layer (interceptors, data sources)
/// and caught by repositories to convert into [Failure] objects.

/// Base class for all Sportify exceptions.
sealed class SportifyException implements Exception {
  const SportifyException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'SportifyException($statusCode): $message';
}

/// 400 — Bad request / malformed request.
class BadRequestException extends SportifyException {
  const BadRequestException({required super.message}) : super(statusCode: 400);
}

/// 401 — Token expired or missing.
class UnauthorizedException extends SportifyException {
  const UnauthorizedException({required super.message})
      : super(statusCode: 401);
}

/// 403 — Insufficient permissions.
class ForbiddenException extends SportifyException {
  const ForbiddenException({required super.message}) : super(statusCode: 403);
}

/// 404 — Resource not found.
class NotFoundException extends SportifyException {
  const NotFoundException({required super.message}) : super(statusCode: 404);
}

/// 422 — Validation errors (Laravel's default for invalid input).
class ValidationException extends SportifyException {
  const ValidationException({
    required super.message,
    this.errors = const {},
  }) : super(statusCode: 422);

  /// Field-level errors from Laravel: {"field": ["error1", "error2"]}
  final Map<String, List<String>> errors;
}

/// 429 — Rate limit exceeded.
class RateLimitException extends SportifyException {
  const RateLimitException({required super.message}) : super(statusCode: 429);
}

/// 500+ — Server error.
class ServerException extends SportifyException {
  const ServerException({required super.message}) : super(statusCode: 500);
}

/// No internet connection.
class NetworkException extends SportifyException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
  });
}

/// Request timed out.
class TimeoutException extends SportifyException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
  });
}

/// Unexpected/unknown error.
class UnknownException extends SportifyException {
  const UnknownException({
    super.message = 'Something went wrong. Please try again.',
  });
}
