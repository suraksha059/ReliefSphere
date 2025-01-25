import 'package:relief_sphere/app/utils/logger_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/enum/enum.dart';
import '../../app/services/service_locator.dart';

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

  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final AuthResponse response =
          await _client.auth.signUp(password: password, email: email);
      if (response.user == null) {
        throw Exception('User not created');
      }
    } catch (error) {
      logger.e(error);
      throw Exception('User not created');
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
