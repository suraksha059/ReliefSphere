import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/core/notifiers/notification/notification_notifers.dart';
import 'package:relief_sphere/presentation/screens/notification_screen/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationNotifier>().getNotifications();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: Consumer<NotificationNotifier>(
        builder: (context, notifier, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final notification = notifier.state.notifications[index];
              return NotificationCard(
                  title: notification.title,
                  description: notification.message,
                  time: notification.timestamp,
                  type: notification.type);
            },
            itemCount: notifier.state.notifications.length,
          );
        },
      ),
    );
  }
}
