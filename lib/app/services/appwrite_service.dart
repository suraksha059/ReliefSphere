import 'package:appwrite/appwrite.dart';
import 'package:relief_sphere/app/config/env_config.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  late final Client _client;

  factory AppwriteService() => _instance;

  AppwriteService._internal() {
    _client = Client()
        .setEndpoint('${EnvConfig.appwriteUrl}/v1')
        .setProject(EnvConfig.appwriteProjectId)
        .setSelfSigned(status: true);
  }

  Client get client => _client;
}
