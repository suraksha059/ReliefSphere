import 'package:relief_sphere/core/notifiers/base_state.dart';

class AuthState extends BaseState {
  final bool isLoggedIn;

  const AuthState({
    this.isLoggedIn = false,
    super.status = Status.initial,
    super.error = '',
  });

  @override
  List<Object?> get props => [isLoggedIn, ...super.props];

  @override
  BaseState copyWith({
    bool? isLoggedIn,
    Status? status,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
