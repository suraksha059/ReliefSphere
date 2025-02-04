import 'package:relief_sphere/core/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/exceptions/exceptions.dart';
import '../../app/services/service_locator.dart';

class ProfileApi {
  final SupabaseClient _client = ServiceLocator.supabase.client;

  Future<UserModel> getUserProfile({String? userId}) async {
    if (userId == null) {
      throw AppExceptions('User ID not found');
    }

    try {
      final response =
          await _client.from('profiles').select('*').eq('id', userId).single();
      return UserModel.fromJson(response);
    } catch (error) {
      throw AppExceptions('Something went wrong');
    }
  }
}
