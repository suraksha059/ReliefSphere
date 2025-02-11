import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool allNotifications = true;
  bool requestUpdates = true;
  bool chatMessages = true;
  bool newsUpdates = false;
  bool systemNotifications = true;
  bool sound = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            child: Column(
              children: [
                _buildSwitch(
                  theme,
                  title: 'All Notifications',
                  subtitle: 'Enable or disable all notifications',
                  value: allNotifications,
                  onChanged: (value) {
                    setState(() {
                      allNotifications = value;
                      requestUpdates = value;
                      chatMessages = value;
                      newsUpdates = value;
                      systemNotifications = value;
                    });
                  },
                  icon: Icons.notifications_outlined,
                ),
                const Divider(),
                _buildSwitch(
                  theme,
                  title: 'Request Updates',
                  subtitle: 'Get notified about your request status',
                  value: requestUpdates,
                  onChanged: allNotifications
                      ? (value) => setState(() => requestUpdates = value)
                      : null,
                  icon: Icons.update_outlined,
                ),
                const Divider(),
                _buildSwitch(
                  theme,
                  title: 'Chat Messages',
                  subtitle: 'Receive message notifications',
                  value: chatMessages,
                  onChanged: allNotifications
                      ? (value) => setState(() => chatMessages = value)
                      : null,
                  icon: Icons.chat_outlined,
                ),
                const Divider(),
                _buildSwitch(
                  theme,
                  title: 'News & Updates',
                  subtitle: 'Stay updated with latest news',
                  value: newsUpdates,
                  onChanged: allNotifications
                      ? (value) => setState(() => newsUpdates = value)
                      : null,
                  icon: Icons.newspaper_outlined,
                ),
                const Divider(),
                _buildSwitch(
                  theme,
                  title: 'System Notifications',
                  subtitle: 'Important system alerts',
                  value: systemNotifications,
                  onChanged: allNotifications
                      ? (value) => setState(() => systemNotifications = value)
                      : null,
                  icon: Icons.info_outline,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Preferences',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            child: Column(
              children: [
                _buildSwitch(
                  theme,
                  title: 'Sound',
                  subtitle: 'Play sound for notifications',
                  value: sound,
                  onChanged: (value) => setState(() => sound = value),
                  icon: Icons.volume_up_outlined,
                ),
                const Divider(),
                _buildSwitch(
                  theme,
                  title: 'Vibration',
                  subtitle: 'Vibrate for notifications',
                  value: vibration,
                  onChanged: (value) => setState(() => vibration = value),
                  icon: Icons.vibration_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
