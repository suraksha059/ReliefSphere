import 'package:relief_sphere/app/services/fcm_service.dart';

import '../../../app/services/secure_storage_service.dart';
import '../../../app/services/service_locator.dart';
import '../../apis/auth_api.dart';
import '../../model/user_model.dart';
import '../base_notifier.dart';
import 'auth_state.dart';

class AuthNotifier extends BaseNotifier<AuthState> {
  final AuthApi _authApi = AuthApi();

  final SecureStorageService _secureStorage = ServiceLocator.secureStorage;

  AuthNotifier() : super(const AuthState());

  bool get isLoggedIn => state.isLoggedIn;

  Future<void> login(String email, String password) async {
    await handleAsyncOperation(() async {
      final userId = await _authApi.login(email, password);
      await _secureStorage.saveUserId(userId);

      final fcmService = FCMTokenService();
      await fcmService.sendTokenToServer();
      state = state.copyWith(isLoggedIn: true) as AuthState;
    });
  }

  Future<void> logout() async {
    await handleAsyncOperation(() async {
      _secureStorage.deleteAll();
      await _authApi.logout();
      state = state.copyWith(isLoggedIn: false) as AuthState;
    });
  }

  Future<void> profileSetup({
    required String name,
    required String phoneNumber,
    required UserRole userRole,
  }) async {
    await handleAsyncOperation(() async {
      await _authApi.profileSetup(
        userId: await _secureStorage.getUserId(),
        name: name,
        phoneNumber: phoneNumber,
        userRole: userRole,
      );
    });
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await handleAsyncOperation(() async {
      final userId = await _authApi.register(
        email: email,
        password: password,
      );
      await _secureStorage.saveUserId(userId);
      state = state.copyWith(isLoggedIn: true) as AuthState;
    });
  }
}
