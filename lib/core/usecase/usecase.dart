import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';

/// Base UseCase interface for clean architecture.
abstract interface class UseCase<Type, Params> {
  /// Executes the use case.
  Future<Either<Failure, Type>> call(Params params);
}

/// A generic placeholder for use cases that don't require parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
