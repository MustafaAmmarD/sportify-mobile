import 'package:equatable/equatable.dart';

/// Failure classes used by the domain layer.
///
/// Unlike [Exception]s (thrown in data layer), [Failure]s are returned
/// as values (via Either pattern or sealed result types) so the
/// presentation layer can react to them without try/catch.

/// Base class for all failures.
sealed class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Server returned an error response.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// No network connection available.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
  });
}

/// Request timed out.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
  });
}

/// Local cache/storage failure.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Failed to load cached data.'});
}

/// Validation failed (field-level errors from API).
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
  });

  /// Field-level errors: {"email": ["The email is required."]}
  final Map<String, List<String>> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}
