import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AidStatusScreen extends StatelessWidget {
  const AidStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aid Status'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Aid Request Card
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'In Progress',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '#AID123',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Medical Supplies Request',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Requested on April 15, 2024',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Timeline
          _buildTimeline(
            theme,
            title: 'Request Received',
            subtitle: 'Your request has been submitted successfully',
            time: '9:30 AM',
            isFirst: true,
            isComplete: true,
          ),
          _buildTimeline(
            theme,
            title: 'Request Approved',
            subtitle: 'Your request has been approved by admin',
            time: '11:45 AM',
            isComplete: true,
          ),
          _buildTimeline(
            theme,
            title: 'Aid Preparation',
            subtitle: 'Your aid package is being prepared',
            time: '2:15 PM',
            isComplete: true,
          ),
          _buildTimeline(
            theme,
            title: 'Out for Delivery',
            subtitle: 'Aid is on the way to your location',
            time: 'In Progress',
            isComplete: false,
          ),
          _buildTimeline(
            theme,
            title: 'Delivered',
            subtitle: 'Aid has been delivered successfully',
            time: 'Pending',
            isLast: true,
            isComplete: false,
          ),

          const SizedBox(height: 32),

          // Contact Support Button
          FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.support_agent),
            label: const Text('Contact Support'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required String time,
    bool isFirst = false,
    bool isLast = false,
    bool isComplete = false,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isComplete
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant,
      ),
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        indicator: Container(
          decoration: BoxDecoration(
            color: isComplete
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: isComplete
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: 2,
            ),
          ),
          child: Icon(
            isComplete ? Icons.check : Icons.circle,
            size: 16,
            color: isComplete
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.outline,
          ),
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isComplete
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
