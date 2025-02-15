import '../../model/notification_model.dart';
import '../base_state.dart';

class NotificationState extends BaseState {
  final List<NotificationModel> notifications;
  final int notificationsCount;

  const NotificationState({
    this.notifications = const [],
    this.notificationsCount = 0,
    super.status = Status.initial,
    super.error = '',
  });

  @override
  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? notificationsCount,
    Status? status,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      notificationsCount: notificationsCount ?? this.notificationsCount,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [notifications, notifications, status, error];
}
