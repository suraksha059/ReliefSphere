import 'package:go_router/go_router.dart';
import 'package:relief_sphere/core/model/user_model.dart';
import 'package:relief_sphere/presentation/screens/add_cluster_screen/add_cluster_screen.dart';
import 'package:relief_sphere/presentation/screens/analytics_screen/analytics_screen.dart';
import 'package:relief_sphere/presentation/screens/donate_now_screen/donate_now_screen.dart';
import 'package:relief_sphere/presentation/screens/donate_screen/donate_screen.dart';
import 'package:relief_sphere/presentation/screens/help_center_screen/help_center_screen.dart';
import 'package:relief_sphere/presentation/screens/manage_clusters_screen/manage_clusters_screen.dart';
import 'package:relief_sphere/presentation/screens/map_screen/map_screen.dart';
import 'package:relief_sphere/presentation/screens/my_donation_screen/my_donation_screen.dart';
import 'package:relief_sphere/presentation/screens/my_request_screen/my_request_screen.dart';
import 'package:relief_sphere/presentation/screens/profile_creation_screen/profile_creation_screen.dart';
import 'package:relief_sphere/presentation/screens/request_screen/request_screen.dart';
import 'package:relief_sphere/presentation/screens/signup_screen/signup_screen.dart';
import 'package:relief_sphere/presentation/screens/track_aid_screen/track_aid_screen.dart';

import '../../core/model/request_model.dart';
import '../../presentation/screens/about_us_screen/about_us_screen.dart';
import '../../presentation/screens/account_setting_screen/account_setting_screen.dart';
import '../../presentation/screens/aid_status_screen/aid_status_screen.dart';
import '../../presentation/screens/home_screen/home_screen.dart';
import '../../presentation/screens/impact_tracking_screen/impact_tracking_screen.dart';
import '../../presentation/screens/location_picker_screen/location_picker_screen.dart';
import '../../presentation/screens/login_screen/login_screen.dart';
import '../../presentation/screens/notification_screen/notification_screen.dart';
import '../../presentation/screens/organization_setup_screen/organization_setup_screen.dart';
import '../../presentation/screens/personal_info_screen/personal_info_screen.dart';
import '../../presentation/screens/notification_setting_screen/notification_setting_screen.dart';
import '../../presentation/screens/user_management_screen/user_management_screen.dart';

final router = GoRouter(
  initialLocation: AppRoutes.loginScreen,
  routes: [
    GoRoute(
      path: AppRoutes.loginScreen,
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
      builder: (context, state) =>
          TrackAidScreen(request: state.extra as RequestModel),
    ),
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
        request: state.extra as RequestModel,
      ),
    ),
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
    GoRoute(
      path: AppRoutes.aboutUsScreen,
      builder: (context, state) => AboutUsScreen(),
    ),
    GoRoute(
      path: AppRoutes.myRequestScreen,
      builder: (context, state) => MyRequestScreen(
        isHome: false,
      ),
    ),
    GoRoute(
      path: AppRoutes.personalInfoScreen,
      builder: (context, state) => PersonalInfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.accountSetttingScreen,
      builder: (context, state) => AccountSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpCenterScreen,
      builder: (context, state) => HelpCenterScreen(),
    ),
    GoRoute(
        path: AppRoutes.analyticsScreen,
        builder: (context, state) {
          final role = state.extra as UserRole;
          return AnalyticsScreen(
            userRole: role,
          );
        }),
    GoRoute(
      path: AppRoutes.notificationSettingsScreen,
      builder: (context, state) => NotificationSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.aidStatusScreen,
      builder: (context, state) => AidStatusScreen(),
    ),
    GoRoute(
      path: AppRoutes.myDonationScreen,
      builder: (context, state) => MyDonationScreen(),
    ),
    GoRoute(
      path: AppRoutes.userManagementScreen,
      builder: (context, state) => UserManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.organizationSetupScreen,
      builder: (context, state) => OrganizationSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.impactTrackingScreen,
      builder: (context, state) => ImpactTrackingScreen(),
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
  static const aboutUsScreen = '/about_us';
  static const myRequestScreen = '/my_request';
  static const personalInfoScreen = '/personal_info';
  static const accountSetttingScreen = '/account_setting';
  static const helpCenterScreen = '/help_center';
  static const notificationSettingsScreen = '/notification_setting';
  static const aidStatusScreen = '/aid_status';
  static const myDonationScreen = '/my_donation';
  static const userManagementScreen = '/user_management';
  static const organizationSetupScreen = '/organization_setup';
  static const analyticsScreen = '/analytics';
  static const impactTrackingScreen = '/impact_tracking';
}
