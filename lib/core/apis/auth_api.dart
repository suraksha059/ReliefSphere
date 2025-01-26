import 'package:relief_sphere/app/exceptions/exceptions.dart';
import 'package:relief_sphere/app/utils/location_utils.dart';
import 'package:relief_sphere/app/utils/logger_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/enum/enum.dart';
import '../../app/services/service_locator.dart';
import '../model/user_model.dart';

class AuthApi {
  final SupabaseClient _client = ServiceLocator.supabase.client;

  Future<void> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      logger.i(response);
    } on AuthException catch (error) {
      logger.e(error);
      rethrow;
    } catch (error) {
      logger.e(error);
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
      final location = [userLocation.longitude, userLocation.latitude];
      final userData = {
        'id': userId,
        'name': name,
        'phone_number': phoneNumber,
        'role': userRole.name,
        'lat': userLocation.latitude,
        'long': userLocation.longitude,
        
      };
      final response =
          await _client.from('users').upsert(userData).select().single();
      return;
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

  Future<void> socialLogin(SocialLoginType type) async {
    await _client.auth.signInWithOAuth(
      type == SocialLoginType.google
          ? OAuthProvider.google
          : OAuthProvider.facebook,
    );
  }
}
