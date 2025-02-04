import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/exceptions/exceptions.dart';
import '../../app/services/service_locator.dart';
import '../model/notification_model.dart';

class NotificationApi {
  final SupabaseClient _client = ServiceLocator.supabase.client;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _client
          .from('notifications')
          .select('*')
          .order('time_stamp', ascending: false);

      return (response as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw AppExceptions('Failed to fetch notifications: ${error.toString()}');
    }
  }

  Future<NotificationModel> markAsRead(String notificationId) async {
    try {
      final response = await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId)
          .select()
          .single();

      if (response == null) {
        throw AppExceptions('Notification not found');
      }

      return NotificationModel.fromJson(response);
    } catch (error) {
      throw AppExceptions(
          'Failed to mark notification as read: ${error.toString()}');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _client.from('notifications').delete().eq('id', notificationId);
    } catch (error) {
      throw AppExceptions('Failed to delete notification: ${error.toString()}');
    }
  }
}
