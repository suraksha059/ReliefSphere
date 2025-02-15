import 'package:relief_sphere/app/exceptions/exceptions.dart';
import 'package:relief_sphere/app/utils/location_utils.dart';
import 'package:relief_sphere/app/utils/logger_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/services/secure_storage_service.dart';
import '../../app/services/service_locator.dart';
import '../model/user_model.dart';

class AuthApi {
  final SupabaseClient _client = ServiceLocator.supabase.client;
  final SecureStorageService _secureStorage = ServiceLocator.secureStorage;

  Future<String> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      logger.i(response);
      if (response.user == null) {
        throw AppExceptions('Unable to login');
      }
      if (response.user?.id == null) {
        throw AppExceptions('Unable to login');
      }
      return response.user!.id;
    } on AuthException catch (error) {
      logger.e(error);
      throw AppExceptions(error.message);
    } catch (error) {
      logger.e(error);
      throw AppExceptions('Something went wrong');
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<void> profileSetup({
    required String? userId,
    required String name,
    required String phoneNumber,
    required UserRole userRole,
  }) async {
    try {
      if (userId == null) {
        throw AppExceptions('User ID not found');
      }
      final userLocation = await LocationUtils.getUserCurrentLocation();
      final userData = {
        'id': userId,
        'name': name,
        'phone_number': phoneNumber,
        'role': userRole.name,
        'log': userLocation.longitude,
        'lat': userLocation.latitude,
      };
      final response =
          await _client.from('profiles').upsert(userData).select().single();
      print(response);
    } catch (error) {
      logger.e('Profile setup error: $error');
      throw AppExceptions('Profile setup error');
    }
  }

  Future<String> register({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response =
          await _client.auth.signUp(password: password, email: email);
      if (response.user == null) {
        throw AppExceptions('User not created');
      }
      if (response.user?.id == null) {
        throw AppExceptions('User not created');
      }
      return response.user!.id;
    } catch (error) {
      logger.e(error);
      throw AppExceptions('User not created');
    }
  }

  Future<void> updateFCMToken(String token) async {
    try {
      if (token.isEmpty) {
        throw AppExceptions('Invalid FCM token');
      }

      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AppExceptions('User ID not found');
      }

      await _client
          .from('profiles')
          .update({'fcm_token': token}).eq('id', userId);
    } catch (error) {
      throw AppExceptions('Failed to update FCM token: ${error.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw AppExceptions(
          'Failed to send reset password link: ${error.toString()}');
    }
  }
  Future<void> updatePasswordWithToken(String token, String newPassword) async {
  try {
    await _client.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  } catch (error) {
    throw AppExceptions('Failed to update password: ${error.toString()}');
  }
}
}
