import 'package:flutter/material.dart';
import 'package:relief_sphere/app/services/service_locator.dart';

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator serviceLocator = ServiceLocator();
  await serviceLocator.initialize();
}
