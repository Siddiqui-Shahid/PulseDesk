import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';
import '../router/route_models.dart';

/// Profile screen - another example of receiving and displaying data
class ProfileScreen extends StatefulWidget {
  final RouteArguments? arguments;

  const ProfileScreen({Key? key, this.arguments}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    final hasData =
        widget.arguments != null &&
        (widget.arguments!.id != null ||
            widget.arguments!.title != null ||
            widget.arguments!.data != null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
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
            const Icon(Icons.person, size: 100, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              'Profile Screen',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (hasData) ...[
              _buildProfileCard(),
            ] else ...[
              const Text(
                'No user data available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 48),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the profile card with user information
  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.arguments!.title != null)
              Text(
                widget.arguments!.title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (widget.arguments!.id != null) ...[
              const SizedBox(height: 8),
              Text(
                'ID: ${widget.arguments!.id}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            if (widget.arguments!.data is Map) ...[
              ..._buildProfileDetails(
                widget.arguments!.data as Map<String, dynamic>,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds individual profile detail rows
  List<Widget> _buildProfileDetails(Map<String, dynamic> data) {
    return [
      for (final entry in data.entries) ...[
        _buildDetailRow(entry.key, entry.value.toString()),
        const SizedBox(height: 12),
      ],
    ];
  }

  /// Builds a single detail row
  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Builds action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to settings
            _appRouter.pushRoute(AppRoute.settings);
          },
          icon: const Icon(Icons.settings),
          label: const Text('Go to Settings'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Back to home
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
