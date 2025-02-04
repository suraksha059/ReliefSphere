import '../../model/notification_model.dart';
import '../base_state.dart';

class NotificationState extends BaseState {
  final List<NotificationModel> notifications;
  
  const NotificationState({
    this.notifications = const [],
    super.status = Status.initial,
    super.error = '',
  });

  @override
  NotificationState copyWith({
    List<NotificationModel>? notifications,
    Status? status,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [notifications, status, error];
}