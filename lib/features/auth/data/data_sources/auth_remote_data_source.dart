import 'package:sportify/core/error/exceptions.dart';
import 'package:sportify/core/network/api_client.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';

abstract interface class AuthRemoteDataSource {
  Future<User> loginWithEmail(String email, String password);
  
  Future<User> register(
    String email, 
    String password, 
    UserRole role, 
    String firstName, 
    String lastName, 
    bool gdprConsent,
  );
  
  Future<User> loginWithSocial(SocialProvider provider);
  
  Future<void> logout();
}

/// MOCK implementation until Tony finishes the backend Auth endpoints.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this.apiClient);
  
  final ApiClient apiClient;

  @override
  Future<User> loginWithEmail(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1)); // Simulate network

    // Test cases for the error UI:
    //  - offline@test.com  -> no connection
    //  - password 'wrongpass' -> invalid credentials
    if (email == 'offline@test.com') throw const NetworkException();
    if (password == 'wrongpass') {
      throw const UnauthorizedException(message: 'Invalid email or password.');
    }

    // Accept any login for prototyping
    return User(
      id: 'mock_1',
      email: email,
      role: UserRole.player,
      firstName: 'Test',
      lastName: 'User',
      accessToken: 'mock_jwt_token',
    );
  }

  @override
  Future<User> register(
    String email, 
    String password, 
    UserRole role, 
    String firstName, 
    String lastName, 
    bool gdprConsent,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    // Test case: taken@test.com -> email already registered.
    if (email == 'taken@test.com') {
      throw const ValidationException(
        message: 'This email is already taken.',
        errors: {
          'email': ['This email is already taken.'],
        },
      );
    }
    return User(
      id: 'mock_2',
      email: email,
      role: role,
      firstName: firstName,
      lastName: lastName,
      accessToken: 'mock_jwt_token',
    );
  }

  @override
  Future<User> loginWithSocial(SocialProvider provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final label = switch (provider) {
      SocialProvider.google => 'Google',
      SocialProvider.apple => 'Apple',
      SocialProvider.facebook => 'Facebook',
      SocialProvider.tiktok => 'TikTok',
    };
    return User(
      id: 'social_${provider.name}',
      email: '${provider.name}@sportifyplus.de',
      role: UserRole.player,
      firstName: 'Mustafa',
      lastName: '($label)',
      accessToken: 'mock_jwt_${provider.name}',
    );
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
