import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:relief_sphere/app/services/service_locator.dart';
import 'package:relief_sphere/firebase_options.dart';

Future init() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await dotenv.load(fileName: ".env");
  ServiceLocator serviceLocator = ServiceLocator();
  await serviceLocator.initialize();
}
