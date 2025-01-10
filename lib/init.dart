import 'package:flutter_starter_kit/app/services/service_locator.dart';

Future init() async {
  ServiceLocator serviceLocator = ServiceLocator();
  serviceLocator.initialize();
}
