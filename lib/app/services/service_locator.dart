import 'package:shared_preferences/shared_preferences.dart';

import '../../app/api_client/api_client.dart';
import 'connectivity_service.dart';
import 'notification_service.dart';
import 'secure_storage_service.dart';
import 'shared_preferences_service.dart';
import 'supabase_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  static ApiClient get apiClient => _instance._apiClient;
  static ConnectivityService get connectivity => _instance._connectivityService;
  static SecureStorageService get secureStorage =>
      _instance._secureStorageService;
  static SharedPreferencesService get sharedPrefs =>
      _instance._sharedPreferencesService;

  static SupabaseService get supabase => _instance._supabaseService;

  late final SecureStorageService _secureStorageService;

  late final ConnectivityService _connectivityService;
  late final ApiClient _apiClient;
  late final SharedPreferencesService _sharedPreferencesService;

  late final SupabaseService _supabaseService;

  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

  Future<void> initialize() async {
    _secureStorageService = SecureStorageService();
    final prefs = await SharedPreferences.getInstance();
    _sharedPreferencesService = SharedPreferencesService(prefs);
    _connectivityService = ConnectivityService();
    _apiClient = ApiClient();
    _supabaseService = SupabaseService();
    await _supabaseService.initialize();
    final notificationService = NotificationService();
    await notificationService.initialize();
  }
}
