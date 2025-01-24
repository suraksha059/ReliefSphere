import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get appwriteProjectId => dotenv.env['APPWRITEPROJECTID'] ?? '';
  static String get appwriteUrl => dotenv.env['APPWRITEURL'] ?? '';
}
