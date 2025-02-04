import 'package:relief_sphere/core/apis/notification_api.dart';
import 'package:relief_sphere/core/notifiers/base_notifier.dart';
import 'package:relief_sphere/core/notifiers/notification/notification_state.dart';
import '../base_state.dart';

class NotificationNotifier extends BaseNotifier<NotificationState> {
  final NotificationApi _notificationApi = NotificationApi();

  NotificationNotifier() : super(NotificationState());

  void getNotifications() async {
    await handleAsyncOperation(() async {
      final notifications = await _notificationApi.getNotifications();
      state =
          state.copyWith(notifications: notifications, status: Status.success);
    });
  }
}
