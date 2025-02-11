import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          SearchBar(
            hintText: 'Search help articles...',
            leading: Icon(Icons.search, color: theme.colorScheme.primary),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const SizedBox(height: 24),

          // Help Topics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildTopicCard(
                theme,
                icon: Icons.person_outline,
                title: 'Account',
                color: Colors.blue,
              ),
              _buildTopicCard(
                theme,
                icon: Icons.payment_outlined,
                title: 'Payments',
                color: Colors.green,
              ),
              _buildTopicCard(
                theme,
                icon: Icons.security_outlined,
                title: 'Security',
                color: Colors.orange,
              ),
              _buildTopicCard(
                theme,
                icon: Icons.help_outline,
                title: 'General',
                color: Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Popular Articles
          Text(
            'Popular Articles',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildArticlesList(theme),

          const SizedBox(height: 32),

          // Contact Support Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need more help?',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('Contact Support'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesList(ThemeData theme) {
    final articles = [
      'How to reset password',
      'Change email address',
      'Delete account',
      'Payment methods',
    ];

    return Column(
      children: articles.map((article) {
        return ListTile(
          title: Text(article),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        );
      }).toList(),
    );
  }
}
