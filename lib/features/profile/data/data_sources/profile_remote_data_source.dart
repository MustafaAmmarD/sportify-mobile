import 'package:sportify/core/network/api_client.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';

abstract interface class ProfileRemoteDataSource {
  Future<Profile> getProfile(String userId);
  Future<Profile> updateProfile(Profile profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this.apiClient);
  
  final ApiClient apiClient;

  // In-memory mock storage
  static final Map<String, Profile> _mockProfiles = {
    'mock_1': const Profile(
      id: 'prof_1',
      userId: 'mock_1',
      bio: 'Professional midfielder looking for new opportunities.',
      position: 'Midfielder',
      nationality: 'Germany',
      preferredFoot: 'Right',
      heightCm: 180,
      weightKg: 75,
      isAvailableForTransfer: true,
      videoLinks: [
        'https://example.com/highlight1.mp4'
      ],
    ),
  };

  @override
  Future<Profile> getProfile(String userId) async {
    await Future<void>.delayed(const Duration(seconds: 1)); // Simulate network
    
    if (_mockProfiles.containsKey(userId)) {
      return _mockProfiles[userId]!;
    }
    
    // Auto-create a blank profile if it doesn't exist
    final newProfile = Profile(
      id: 'prof_$userId',
      userId: userId,
    );
    _mockProfiles[userId] = newProfile;
    return newProfile;
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _mockProfiles[profile.userId] = profile;
    return profile;
  }
}
