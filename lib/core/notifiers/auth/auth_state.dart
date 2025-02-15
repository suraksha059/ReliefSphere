import 'package:relief_sphere/core/notifiers/base_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState extends BaseState {
  final bool isLoggedIn;
  final User? user;

  const AuthState({
    this.isLoggedIn = false,
    this.user,
    super.status = Status.initial,
    super.error = '',
  });

  @override
  List<Object?> get props => [isLoggedIn, ...super.props];

  @override
  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    Status? status,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
