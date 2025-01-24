import 'package:appwrite/appwrite.dart';
import 'package:dio/dio.dart';
import 'package:relief_sphere/app/utils/logger_utils.dart';
import 'package:uuid/uuid.dart';

import '../../app/services/service_locator.dart';

class AuthApi {
  final Account _account;

  AuthApi() : _account = Account(ServiceLocator.appwrite.client);

  Future<void> login(String email, String password) async {
    try {
      final session =
          _account.createEmailPasswordSession(email: email, password: password);
      logger.i(session);
    } on DioException catch (error) {
      logger.e(error);
    } catch (error) {
      logger.e(error);
    }
  }

  Future<void> logout() async {
    // Call the logout API
  }

  Future<void> register(String email, String password) async {
    try {
      final response = _account.create(
          userId: Uuid().v4(), email: email, password: password);

      logger.i(response);
    } catch (error) {
      logger.e(error);
    }
  }
}
