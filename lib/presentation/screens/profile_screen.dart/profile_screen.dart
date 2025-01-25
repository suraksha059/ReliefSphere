import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/model/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserRole userRole;

  const ProfileScreen({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                  // Glassmorphic Effect
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.8),
                      ),
                    ),
                  ),
                  // Profile Content
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.2),
                                    theme.colorScheme.primary.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.person_outline,
                                  size: 50,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'John Doe',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primaryContainer,
                                theme.colorScheme.primary.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Verified User',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ..._buildRoleSpecificSections(context, theme),
                _buildSection(
                  'Account',
                  [
                    _buildListTile(
                      context,
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                      color: theme.colorScheme.primary,
                      onTap: () {},
                    ),
                    _buildListTile(
                      context,
                      title: 'My Requests',
                      icon: Icons.history,
                      color: theme.colorScheme.secondary,
                      onTap: () {},
                    ),
                  ],
                  theme,
                ),
                _buildSection(
                  'Settings',
                  [
                    _buildListTile(
                      context,
                      title: 'Account Settings',
                      icon: Icons.settings_outlined,
                      color: theme.colorScheme.tertiary,
                      onTap: () {},
                    ),
                    _buildListTile(
                      context,
                      title: 'Notifications',
                      icon: Icons.notifications_outlined,
                      color: theme.colorScheme.secondary,
                      onTap: () {},
                    ),
                  ],
                  theme,
                ),
                _buildSection(
                  'Support',
                  [
                    _buildListTile(
                      context,
                      title: 'Help Center',
                      icon: Icons.help_outline,
                      color: theme.colorScheme.tertiary,
                      onTap: () {},
                    ),
                    _buildListTile(
                      context,
                      title: 'About Us',
                      icon: Icons.info_outline,
                      color: theme.colorScheme.secondary,
                      onTap: () {},
                    ),
                    _buildListTile(
                      context,
                      title: 'Logout',
                      icon: Icons.logout,
                      color: theme.colorScheme.error,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                  theme,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
            color: theme.shadowColor.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRoleSpecificSections(
      BuildContext context, ThemeData theme) {
    switch (userRole) {
      case UserRole.admin:
        return [
          _buildSection(
            'Administration',
            [
              _buildListTile(
                context,
                title: 'User Management',
                icon: Icons.people_outline,
                color: theme.colorScheme.primary,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Organization Setup',
                icon: Icons.business_outlined,
                color: theme.colorScheme.secondary,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Analytics Dashboard',
                icon: Icons.analytics_outlined,
                color: theme.colorScheme.tertiary,
                onTap: () {},
              ),
            ],
            theme,
          ),
        ];

      case UserRole.donor:
        return [
          _buildSection(
            'Donations',
            [
              _buildListTile(
                context,
                title: 'Donation History',
                icon: Icons.volunteer_activism,
                color: theme.colorScheme.primary,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Impact Tracking',
                icon: Icons.track_changes,
                color: theme.colorScheme.secondary,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Tax Receipts',
                icon: Icons.receipt_long_outlined,
                color: theme.colorScheme.tertiary,
                onTap: () {},
              ),
            ],
            theme,
          ),
        ];

      case UserRole.admin:
        return [
          _buildSection(
            'Aid Management',
            [
              _buildListTile(
                context,
                title: 'Active Aid Cases',
                icon: Icons.medical_services_outlined,
                color: theme.colorScheme.primary,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Resource Allocation',
                icon: Icons.inventory_2_outlined,
                color: theme.colorScheme.secondary,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Reports',
                icon: Icons.assessment_outlined,
                color: theme.colorScheme.tertiary,
                onTap: () {},
              ),
            ],
            theme,
          ),
        ];

      case UserRole.victim:
        return [
          _buildSection(
            'Aid Requests',
            [
              _buildListTile(
                context,
                title: 'My Requests',
                icon: Icons.history,
                color: theme.colorScheme.primary,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Active Aid Status',
                icon: Icons.track_changes,
                color: theme.colorScheme.secondary,
                onTap: () {},
              ),
            ],
            theme,
          ),
        ];
    }
  }

  Widget _buildSection(String title, List<Widget> children, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer.withOpacity(0.3),
                  theme.colorScheme.primaryContainer.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    // Implementation similar to your existing logout dialog
  }
}
