import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  late final Client _client;

  factory AppwriteService() => _instance;

  AppwriteService._internal() {
    _client = Client()
        .setEndpoint('http://localhost:8000/v1')
        .setProject('679360b8afee26dd8e82')
        .setSelfSigned(status: true);
  }

  Client get client => _client;
}
