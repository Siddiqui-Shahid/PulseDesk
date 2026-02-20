import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';

/// Settings screen - simple screen without data passing
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _appRouter.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.settings, size: 80, color: Colors.purple),
            const SizedBox(height: 24),
            const Text(
              'Settings Screen',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Configure your application preferences',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildSettingsList(),
            const SizedBox(height: 48),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the settings list
  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildSettingTile(
          icon: Icons.dark_mode,
          title: 'Dark Mode',
          value: false,
        ),
        _buildSettingTile(
          icon: Icons.notifications,
          title: 'Notifications',
          value: true,
        ),
        _buildSettingTile(
          icon: Icons.language,
          title: 'Language',
          value: 'English',
        ),
      ],
    );
  }

  /// Builds a single setting tile
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required dynamic value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.purple),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value is bool ? (value ? 'ON' : 'OFF') : value.toString(),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds navigation buttons
  Widget _buildNavigationButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Back to home (replace the settings screen)
            _appRouter.navigateTo(AppRoute.home);
          },
          icon: const Icon(Icons.home),
          label: const Text('Back to Home'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
