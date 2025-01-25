import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:relief_sphere/core/model/user_model.dart';

import '../dashboard_screen/widgets/dashboard_app_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  final UserRole userRole;
  const AnalyticsScreen({super.key, required this.userRole});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'Month';
  final List<String> _timePeriods = ['Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          DashboardSliverAppBar(
            userRole: widget.userRole,
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Period Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _timePeriods.map((period) {
                        final isSelected = _selectedPeriod == period;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(period),
                            onSelected: (selected) {
                              setState(() => _selectedPeriod = period);
                            },
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            selectedColor: theme.colorScheme.primaryContainer,
                            labelStyle: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Summary Stats
                  Row(
                    children: [
                      _buildStatCard(
                        theme,
                        icon: Icons.volunteer_activism,
                        title: 'Total Donations',
                        value: '₹2.5M',
                        trend: '+12.5%',
                        isPositive: true,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        theme,
                        icon: Icons.people_outline,
                        title: 'People Helped',
                        value: '1,234',
                        trend: '+8.3%',
                        isPositive: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Main Chart
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surfaceContainerHighest
                              .withAlpha(128),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withAlpha(128),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Donation Trends',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    const FlSpot(0, 3),
                                    const FlSpot(2.6, 2),
                                    const FlSpot(4.9, 5),
                                    const FlSpot(6.8, 3.1),
                                    const FlSpot(8, 4),
                                    const FlSpot(9.5, 3),
                                    const FlSpot(11, 4),
                                  ],
                                  isCurved: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.tertiary,
                                    ],
                                  ),
                                  barWidth: 3,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        theme.colorScheme.primary
                                            .withOpacity(0.2),
                                        theme.colorScheme.surface
                                            .withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category Distribution
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surfaceContainerHighest
                              .withAlpha(128),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withAlpha(128),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aid Distribution',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: [
                                PieChartSectionData(
                                  value: 40,
                                  title: 'Food',
                                  color: theme.colorScheme.primary,
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  value: 30,
                                  title: 'Medical',
                                  color: theme.colorScheme.secondary,
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  value: 30,
                                  title: 'Shelter',
                                  color: theme.colorScheme.tertiary,
                                  radius: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isPositive
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isPositive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isPositive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
