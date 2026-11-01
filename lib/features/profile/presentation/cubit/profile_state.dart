import 'package:equatable/equatable.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  const ProfileError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
