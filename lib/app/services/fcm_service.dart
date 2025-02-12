import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:nist_tes/core/apis/auth_api.dart';

class FCMException implements Exception {
  final String message;
  FCMException(this.message);

  @override
  String toString() => 'FCMException: $message';
}

class FCMTokenService {
  static final FCMTokenService _instance = FCMTokenService._internal();
  static const String _tokenKey = 'fcm_token';
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  final _authAPI = AuthenticationAPI();
  String? _cachedToken;

  factory FCMTokenService() => _instance;
  FCMTokenService._internal();

  Future<String?> getStoredToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      _logger.e('Error reading stored FCM token: $e');
      throw FCMException('Failed to read stored FCM token');
    }
  }

  /// Get FCM token, generate if not exists
  Future<String?> getToken() async {
    try {
      // Check cached token first
      if (_cachedToken != null) return _cachedToken;

      // Check stored token
      final storedToken = await _storage.read(key: _tokenKey);
      if (storedToken != null) {
        _cachedToken = storedToken;
        return storedToken;
      }

      // iOS specific handling with retry
      if (Platform.isIOS) {
        return null;
        // ignore: dead_code
        String? apnsToken = await _fcm.getAPNSToken();
      }

      // Generate new token
      final token = await _fcm.getToken();
      if (token != null) {
        await _storage.write(key: _tokenKey, value: token);
        _cachedToken = token;
        _logger.i('New FCM token generated');
      }

      return token;
    } catch (e) {
      _logger.e('Error getting FCM token: $e');
      throw FCMException('Failed to get FCM token');
    }
  }

  /// Initialize FCM service and request permissions
  Future<void> initialize() async {
    try {
      // Request notification permissions
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _logger.i('Notification permissions granted');
        await setupTokenRefresh();
      } else {
        _logger.w('Notification permissions denied');
      }
    } catch (e) {
      _logger.e('Error initializing FCM service: $e');
      throw FCMException('Failed to initialize FCM service');
    }
  }

  /// Send token to server
  Future<void> sendTokenToServer() async {
    try {
      final token = await getToken();
      if (token != null) {
        await _authAPI.updateFCMToken(token);
        _logger.i('FCM token sent to server successfully');
      }
    } catch (e) {
      _logger.e('Error sending FCM token to server: $e');
      throw FCMException('Failed to send FCM token to server');
    }
  }

  /// Setup token refresh listener
  Future<void> setupTokenRefresh() async {
    _fcm.onTokenRefresh.listen((token) async {
      _logger.i('FCM token refreshed');
      await _updateToken(token);
    });
  }

  /// Update token in storage and server
  Future<void> _updateToken(String token) async {
    try {
      // Update local storage
      await _storage.write(key: _tokenKey, value: token);
      _cachedToken = token;

      // Update server
      await _authAPI.updateFCMToken(token);
      _logger.i('FCM token updated successfully');
    } catch (e) {
      _logger.e('Error updating FCM token: $e');
      throw FCMException('Failed to update FCM token');
    }
  }
}
