import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:relief_sphere/core/notifiers/auth/auth_notifiers.dart';
import 'package:relief_sphere/core/notifiers/profile/profile_notifier.dart';
import 'package:relief_sphere/core/notifiers/request/request_notifier.dart';
import '../../core/notifiers/notification/notification_notifers.dart';
import '../../core/notifiers/theme/theme_notifiers.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => ThemeNotifier()),
    ChangeNotifierProvider(create: (context) => AuthNotifier()),
    ChangeNotifierProvider(create: (context) => ProfileNotifier()),
    ChangeNotifierProvider(create: (context) => NotificationNotifier()),
    ChangeNotifierProvider(create: (context) => RequestNotifier()),
  ];
}
