import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:relief_sphere/app/services/service_locator.dart';

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  ServiceLocator serviceLocator = ServiceLocator();
  await serviceLocator.initialize();
}
