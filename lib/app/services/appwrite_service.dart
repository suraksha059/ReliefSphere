import 'package:appwrite/appwrite.dart';
import 'package:relief_sphere/app/const/app_constant.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  late final Client _client;

  factory AppwriteService() => _instance;

  AppwriteService._internal() {
    _client = Client()
        .setEndpoint('${AppConstant.appWriteUrl}/v1')
        .setProject('679360b8afee26dd8e82')
        .setSelfSigned(status: true);
  }

  Client get client => _client;
}
