import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';
import 'package:sportify/features/profile/domain/use_cases/get_profile.dart';
import 'package:sportify/features/profile/domain/use_cases/update_profile.dart';
import 'package:sportify/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(const ProfileInitial());

  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  Future<void> fetchProfile(String userId) async {
    emit(const ProfileLoading());
    final result = await _getProfile(userId);
    emit(
      result.fold(
        ProfileError.new,
        ProfileLoaded.new,
      ),
    );
  }

  Future<void> updateProfile(Profile profile) async {
    emit(const ProfileLoading());
    final result = await _updateProfile(profile);
    emit(
      result.fold(
        ProfileError.new,
        ProfileLoaded.new,
      ),
    );
  }
}
