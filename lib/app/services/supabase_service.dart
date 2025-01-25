import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() => _instance;

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        pkceAsyncStorage: SharedPreferencesGotrueAsyncStorage(),
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(
        retryAttempts: 10,
      ),
    );
  }
}
