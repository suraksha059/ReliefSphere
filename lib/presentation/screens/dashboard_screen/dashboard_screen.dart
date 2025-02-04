import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
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
                // Stats Section
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

                // Quick Actions Section
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

                // Recent Activity Section
                SectionTitle(
                  title: 'Recent Activity',
                  onViewAll: () {},
                ),
                const SizedBox(height: 16),
                Column(
                  children: _buildRecentActivity(),
                ),
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
              context.push(AppRoutes.trackAidScreen);
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

  List<Widget> _buildRecentActivity() {
    switch (userRole) {
      case UserRole.victim:
        return [
          ActivityCard(
            title: 'Request Verified',
            subtitle: 'Your food aid request has been approved',
            icon: Icons.check_circle_outline,
            timestamp: '2h ago',
          ),
          ActivityCard(
            title: 'Aid Received',
            subtitle: 'Medicine supplies delivered by NGO',
            icon: Icons.medical_services_outlined,
            timestamp: '1d ago',
          ),
        ];
      case UserRole.donor:
        return [
          ActivityCard(
            title: 'Donation Success',
            subtitle: 'Your donation of \$100 was processed',
            icon: Icons.payments_outlined,
            timestamp: '3h ago',
          ),
          ActivityCard(
            title: 'Impact Update',
            subtitle: 'Your donation helped 3 families',
            icon: Icons.favorite_outline,
            timestamp: '2d ago',
          ),
        ];
      case UserRole.admin:
        return [
          ActivityCard(
            title: 'New Cluster Formed',
            subtitle: '5 requests grouped in Chennai',
            icon: Icons.hub_outlined,
            timestamp: '1h ago',
          ),
          ActivityCard(
            title: 'Fraud Alert',
            subtitle: 'Duplicate requests detected',
            icon: Icons.warning_amber_outlined,
            timestamp: '5h ago',
          ),
        ];
    }
  }

  List<Widget> _buildStatsCards() {
    switch (userRole) {
      case UserRole.victim:
        return [
          StatsCard(
            title: 'Active Requests',
            value: '2',
            icon: Icons.pending_actions,
            color: Colors.blue,
          ),
          StatsCard(
            title: 'Aid Received',
            value: '\$500',
            icon: Icons.volunteer_activism,
            color: Colors.green,
          ),
        ];
      case UserRole.donor:
        return [
          StatsCard(
            title: 'Total Donated',
            value: '\$2,500',
            icon: Icons.favorite,
            color: Colors.red,
          ),
          StatsCard(
            title: 'People Helped',
            value: '15',
            icon: Icons.people,
            color: Colors.orange,
          ),
        ];
      case UserRole.admin:
        return [
          StatsCard(
            title: 'Pending Requests',
            value: '25',
            icon: Icons.assignment_late,
            color: Colors.purple,
          ),
          StatsCard(
            title: 'Active Clusters',
            value: '8',
            icon: Icons.hub,
            color: Colors.teal,
          ),
        ];
    }
  }
}
