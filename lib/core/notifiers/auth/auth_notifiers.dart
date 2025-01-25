import 'package:flutter/widgets.dart';
import 'package:relief_sphere/app/enum/enum.dart';
import 'package:relief_sphere/core/apis/auth_api.dart';

import 'auth_state.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();

  AuthState _state = const AuthState();
  bool get isLoading => _state.isLoading;

  Future login(String email, String password) async {
    _updateState(isLoading: true);
    try {
      await _authApi.login(email, password);
      _updateState(isLoading: false, isLoggedIn: true);
    } catch (e) {
      _updateState(isLoading: false, error: e.toString(), isLoggedIn: false);
    } finally {
      _updateState(isLoading: false);
    }
  }

  void logout() {
    _authApi.logout();
  }

  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {
    _updateState(isLoading: true);
    try {
      await _authApi.register(
        name: name,
        email: email,
        password: password,
      );
      _updateState(isLoading: false, isLoggedIn: true);
    } catch (e) {
      _updateState(isLoading: false, error: e.toString());
    } finally {
      _updateState(isLoading: false);
    }
  }

  void socialLogin(SocialLoginType type) {
    _updateState(isLoading: true);
    _authApi.socialLogin(type);
    _updateState(isLoading: false, isLoggedIn: true);
  }

  void _updateState({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
  }) {
    _state = _state.copyWith(
      isLoading: isLoading,
      error: error,
      isLoggedIn: isLoggedIn,
    );
    notifyListeners();
  }
}
