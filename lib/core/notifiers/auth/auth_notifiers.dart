import 'package:flutter/widgets.dart';
import 'package:relief_sphere/app/enum/enum.dart';
import 'package:relief_sphere/core/apis/auth_api.dart';

import 'auth_state.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();

  AuthState _state = const AuthState();
  bool get isLoading => _state.isLoading;
  void login(String email, String password) {
    _updateState(isLoading: true);
    _authApi.login(email, password);
    _updateState(isLoading: false, isLoggedIn: true);
  }

  void logout() {
    _updateState(isLoading: true);
    _authApi.logout();
    _updateState(isLoading: false, isLoggedIn: false);
  }

  void register(
      {required String name, required String email, required String password}) {
    _updateState(isLoading: true);
    _authApi.register(
      name: name,
      email: email,
      password: password,
    );
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

  void socialLogin(SocialLoginType type) {
    _updateState(isLoading: true);
    _authApi.socialLogin(type);
    _updateState(isLoading: false, isLoggedIn: true);
    
  }
}
