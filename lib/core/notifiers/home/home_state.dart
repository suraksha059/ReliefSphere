import 'package:relief_sphere/core/notifiers/base_state.dart';

class HomeState extends BaseState {
  final int activeRequests;
  final int aidReceived;
  final int pendingRequests;

  const HomeState({
    this.activeRequests = 0,
    this.aidReceived = 0,
    this.pendingRequests = 0,
    super.status = Status.initial,
    super.error = '',
  });

  @override
  HomeState copyWith({
    int? activeRequests,
    int? aidReceived,
    int? pendingRequests,
    Status? status,
    String? error,
  }) {
    return HomeState(
      activeRequests: activeRequests ?? this.activeRequests,
      aidReceived: aidReceived ?? this.aidReceived,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [activeRequests, aidReceived, pendingRequests, status, error];
}
