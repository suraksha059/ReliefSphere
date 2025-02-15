import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/core/notifiers/home/home_notifier.dart';
import 'package:relief_sphere/core/notifiers/notification/notification_notifers.dart';
import 'package:relief_sphere/presentation/screens/dashboard_screen/widgets/dashboard_app_bar.dart';

import '../../../core/model/user_model.dart';
import 'widgets/activity_card.dart';
import 'widgets/section_title.dart';
import 'widgets/stats_card.dart';

class DashboardScreen extends StatelessWidget {
  final UserRole userRole;

  const DashboardScreen({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          DashboardSliverAppBar(
            userRole: userRole,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  padding: const EdgeInsets.all(16),
                  children: _buildStatsCards(),
                ),
                const SizedBox(height: 24),
                SectionTitle(
                  title: 'Quick Actions',
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: _buildQuickActions(context),
                  ),
                ),
                const SizedBox(height: 24),
                SectionTitle(
                  title: 'Recent Activity',
                  onViewAll: () {},
                ),
                const SizedBox(height: 16),
                Consumer<NotificationNotifier>(
                    builder: (context, notifier, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final notification = notifier.state.notifications[index];
                      return ActivityCard(
                        title: notification.title,
                        subtitle: notification.message,
                        timestamp: notification.timestamp,
                        icon: Icons.check_circle_outline,
                      );
                    },
                    itemCount: notifier.state.notifications.length,
                  );
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest.withAlpha(128),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withAlpha(128),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildQuickActions(BuildContext context) {
    final actions = <Widget>[];

    switch (userRole) {
      case UserRole.victim:
        actions.addAll([
          _buildActionButton(
            context,
            'New Request',
            Icons.add_circle_outline,
            () {
              context.push(AppRoutes.newRequestScreen);
            },
          ),
          _buildActionButton(
            context,
            'Track Aid',
            Icons.track_changes,
            () {
              context.push(AppRoutes.myRequestScreen);
            },
          ),
        ]);
        break;
      case UserRole.donor:
        actions.addAll([
          _buildActionButton(
            context,
            'Donate',
            Icons.volunteer_activism,
            () {
              context.push(AppRoutes.donateScreen, extra: userRole);
            },
          ),
          _buildActionButton(
            context,
            'View Map',
            Icons.map_outlined,
            () {
              context.push(AppRoutes.donerMapScreen);
            },
          ),
        ]);
        break;
      case UserRole.admin:
        actions.addAll([
          _buildActionButton(
            context,
            'Verify Requests',
            Icons.verified_user_outlined,
            () {
              context.push(AppRoutes.donateScreen, extra: userRole);
            },
          ),
          _buildActionButton(
            context,
            'Manage Clusters',
            Icons.hub_outlined,
            () {
              context.push(AppRoutes.manageClusters);
            },
          ),
        ]);
        break;
    }
    return actions;
  }

  List<Widget> _buildStatsCards() {
    switch (userRole) {
      case UserRole.victim:
        return [
          Consumer<HomeNotifier>(builder: (context, notifier, child) {
            return StatsCard(
              title: 'Active Requests',
              value: '${notifier.state.activeRequests}',
              icon: Icons.pending_actions,
              color: Colors.blue,
            );
          }),
          Consumer<HomeNotifier>(builder: (context, notifier, child) {
            return StatsCard(
              title: 'Aid Received',
              value: '${notifier.state.aidReceived}',
              icon: Icons.volunteer_activism,
              color: Colors.green,
            );
          }),
        ];
      case UserRole.donor:
        return [
          StatsCard(
            title: 'Total Donated',
            value: 'Rs1000',
            icon: Icons.favorite,
            color: Colors.red,
          ),
          StatsCard(
            title: 'People Helped',
            value: '1',
            icon: Icons.people,
            color: Colors.orange,
          ),
        ];
      case UserRole.admin:
        return [
          Consumer<HomeNotifier>(builder: (context, notifier, child) {
            return StatsCard(
              title: 'Pending Requests',
              value: '${notifier.state.pendingRequests}',
              icon: Icons.assignment_late,
              color: Colors.purple,
            );
          }),
          StatsCard(
            title: 'Active Clusters',
            value: '2',
            icon: Icons.hub,
            color: const Color.fromARGB(255, 79, 104, 101),
          ),
        ];
    }
  }
}
