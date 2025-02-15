import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/core/model/user_model.dart';
import 'package:relief_sphere/core/notifiers/profile/profile_notifier.dart';
import 'package:relief_sphere/presentation/screens/analytics_screen/analytics_screen.dart';
import 'package:relief_sphere/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:relief_sphere/presentation/screens/map_view_screen/map_view_screen.dart';
import 'package:relief_sphere/presentation/screens/my_request_screen/my_request_screen.dart';
import 'package:relief_sphere/presentation/screens/profile_screen.dart/profile_screen.dart';

import '../../../core/notifiers/home/home_notifier.dart';
import '../../../core/notifiers/notification/notification_notifers.dart';
import '../my_donation_screen/my_donation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileNotifier>().getUserProfile();
      context.read<HomeNotifier>().getDashboardItems();
      context.read<NotificationNotifier>().getNotificationsCount();
      context.read<NotificationNotifier>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Consumer<ProfileNotifier>(builder: (context, notifier, child) {
          if (notifier.state.userModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final userRole = notifier.state.userModel!.userRole;
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              DashboardScreen(userRole: userRole),
              if (userRole == UserRole.victim)
                MyRequestScreen(
                  isHome: true,
                ),
              if (userRole == UserRole.donor) MyDonationScreen(),
              MapViewScreen(),
              if (userRole == UserRole.admin)
                AnalyticsScreen(userRole: userRole),
              ProfileScreen(userRole: userRole),
            ],
          );
        }),
      ),
      bottomNavigationBar:
          Consumer<ProfileNotifier>(builder: (context, notifier, child) {
        if (notifier.state.userModel == null) {
          return const SizedBox();
        }
        final userRole = notifier.state.userModel!.userRole;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerHighest.withAlpha(230),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: GNav(
                selectedIndex: _selectedIndex,
                onTabChange: _onDestinationSelected,
                gap: 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                tabBackgroundColor:
                    theme.colorScheme.primaryContainer.withOpacity(0.3),
                activeColor: theme.colorScheme.primary,
                color: theme.colorScheme.onSurfaceVariant,
                tabBorderRadius: 16,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                tabs: _buildNavigationTabs(userRole, theme),
                rippleColor: theme.colorScheme.primary.withOpacity(0.1),
                hoverColor: theme.colorScheme.primary.withOpacity(0.05),
              ),
            ),
          ),
        );
      }),
    );
  }

  List<GButton> _buildNavigationTabs(UserRole role, ThemeData theme) {
    switch (role) {
      case UserRole.victim:
        return [
          GButton(
            icon: Icons.space_dashboard_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Home',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.receipt_long_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Requests',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.explore_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Explore',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.person_outline,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Profile',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];

      case UserRole.donor:
        return [
          GButton(
            icon: Icons.dashboard_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Home',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.volunteer_activism_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Donations',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.explore_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Explore',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.person_outline,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Profile',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];

      case UserRole.admin:
        return [
          GButton(
            icon: Icons.space_dashboard_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Dashboard',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.explore_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Explore',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.analytics_outlined,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Analytics',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GButton(
            icon: Icons.person_outline,
            iconActiveColor: theme.colorScheme.primary,
            text: 'Profile',
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(
      index,
    );
  }
}
