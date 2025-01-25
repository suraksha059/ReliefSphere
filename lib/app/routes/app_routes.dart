import 'package:go_router/go_router.dart';
import 'package:relief_sphere/core/model/user_model.dart';
import 'package:relief_sphere/presentation/screens/add_cluster_screen/add_cluster_screen.dart';
import 'package:relief_sphere/presentation/screens/donate_now_screen/donate_now_screen.dart';
import 'package:relief_sphere/presentation/screens/donate_screen/donate_screen.dart';
import 'package:relief_sphere/presentation/screens/manage_clusters_screen/manage_clusters_screen.dart';
import 'package:relief_sphere/presentation/screens/map_screen/map_screen.dart';
import 'package:relief_sphere/presentation/screens/profile_creation_screen/profile_creation_screen.dart';
import 'package:relief_sphere/presentation/screens/request_screen/request_screen.dart';
import 'package:relief_sphere/presentation/screens/signup_screen/signup_screen.dart';
import 'package:relief_sphere/presentation/screens/track_aid_screen/track_aid_screen.dart';

import '../../presentation/screens/home_screen/home_screen.dart';
import '../../presentation/screens/location_picker_screen/location_picker_screen.dart';
import '../../presentation/screens/login_screen/login_screen.dart';
import '../../presentation/screens/notification_screen/notification_screen.dart';

final router = GoRouter(
  // Set the initial location

  initialLocation: AppRoutes.loginScreen,
  routes: [
    GoRoute(
      path: AppRoutes.loginScreen,
      // Uncomment the following line to use the LoginScreen widget
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.registerScreen,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.homeScreen,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
        path: AppRoutes.newRequestScreen,
        builder: (context, state) => RequestScreen()),
    GoRoute(
      path: AppRoutes.locationPicker,
      builder: (context, state) => const LocationPickerScreen(),
    ),
    GoRoute(
      path: AppRoutes.trackAidScreen,
      builder: (context, state) => TrackAidScreen(),
    ),
    //notificationScreen
    GoRoute(
      path: AppRoutes.notificationScreen,
      builder: (context, state) => NotificationScreen(),
    ),

    GoRoute(
      path: AppRoutes.donerMapScreen,
      builder: (context, state) => MapScreen(),
    ),
    GoRoute(
        path: AppRoutes.donateScreen,
        builder: (context, state) {
          final role = state.extra as UserRole;
          return DonateScreen(
            userRole: role,
          );
        }),

    GoRoute(
      path: AppRoutes.donateNowScreen,
      builder: (context, state) => DonateNowScreen(
        requestTitle: "Request Title",
        requesterId: "Requester ID",
        targetAmount: 23000,
        raisedAmount: 2000,
      ),
    ),
    //manageclusters
    GoRoute(
      path: AppRoutes.manageClusters,
      builder: (context, state) => ManageClustersScreen(),
    ),
    GoRoute(
      path: AppRoutes.addClusterScreen,
      builder: (context, state) => AddClusterScreen(),
    ),
    GoRoute(
      path: AppRoutes.profileSetupScreen,
      builder: (context, state) => ProfileCreationScreen(),
    ),
  ],
);

abstract class AppRoutes {
  static const loginScreen = '/login';
  static const registerScreen = '/register';
  static const profileSetupScreen = '/profile_setup';
  static const homeScreen = '/home';
  static const newRequestScreen = '/new_request';

  static const locationPicker = '/location_picker';
  static const trackAidScreen = '/track_aid';
  static const notificationScreen = '/notification';
  static const donateScreen = '/donate';

  static const donateNowScreen = '/donate_now';

  static const donerMapScreen = '/doner_map';
  static const manageClusters = '/manage_clusters';
  static const addClusterScreen = '/add_cluster';
}
