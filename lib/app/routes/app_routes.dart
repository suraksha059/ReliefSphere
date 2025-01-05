import 'package:go_router/go_router.dart';

final router = GoRouter(
  // Set the initial location
  initialLocation: AppRoutes.homeScreen,
  routes: [
    GoRoute(
      path: AppRoutes.loginScreen,
      // Uncomment the following line to use the LoginScreen widget
      // builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.registerScreen,
      // builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.homeScreen,
      // builder: (context, state) => HomeScreen(),
    ),
  ],
);

abstract class AppRoutes {
  static const loginScreen = '/login';
  static const registerScreen = '/register';
  static const homeScreen = '/home';
}
