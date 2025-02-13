import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

import '../utils/logger_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.e('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'tes_main_channel',
    'TES Academic Notifications',
    description:
        'Receive notifications about classes, assignments, and announcements.',
    importance: Importance.max, // Change to max
    playSound: true,
    enableVibration: true,
    enableLights: true,
    showBadge: true,
  );
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();
  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> initialize() async {
    try {
      await _setupNotificationPermissions();
      await _setupNotificationChannels();
      await _initializeLocalNotifications();
      await _setupForegroundNotificationHandler();
      await _setupBackgroundNotificationHandler();
      await _setupNotificationTapHandler();

      _logger.i('Notification service initialized successfully');
    } catch (e) {
      _logger.e('Error initializing notification service: $e');
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void _handleFCMNotificationTap(RemoteMessage message) {
    _logger.i('FCM notification tapped with data: ${message.data}');
    // Handle FCM notification navigation
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true, // Enable heads-up
            ticker: notification.title,
            styleInformation: BigTextStyleInformation(
              notification.body ?? '',
              htmlFormatBigText: true,
              contentTitle: notification.title,
              htmlFormatContentTitle: true,
            ),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.active, // Enable banner
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      _logger.i('Local notification tapped with payload: ${response.payload}');
      // Handle local notification navigation
    }
  }

  Future<void> _initializeLocalNotifications() async {
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        // Add these settings
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
        notificationCategories: [
          DarwinNotificationCategory(
            'tes_category',
            options: {
              DarwinNotificationCategoryOption.allowAnnouncement,
            },
          ),
        ],
      ),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );
  }

  Future<void> _setupBackgroundNotificationHandler() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _setupForegroundNotificationHandler() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> _setupNotificationChannels() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _setupNotificationPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.i('Notification permissions granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      _logger.i('Provisional notification permissions granted');
    } else {
      _logger.w('Notification permissions declined');
    }
  }

  Future<void> _setupNotificationTapHandler() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleFCMNotificationTap);
  }
}
