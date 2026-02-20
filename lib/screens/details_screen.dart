import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';
import '../router/route_models.dart';

/// Details screen - demonstrates receiving passed data
///
/// This screen receives RouteArguments and displays the data
class DetailsScreen extends StatefulWidget {
  /// The arguments passed during navigation
  final RouteArguments? arguments;

  const DetailsScreen({Key? key, this.arguments}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    // Check if we received any arguments
    final hasData =
        widget.arguments != null &&
        (widget.arguments!.id != null ||
            widget.arguments!.title != null ||
            widget.arguments!.data != null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
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
            const Icon(Icons.info, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Details Screen',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (hasData) ...[
              _buildDataSection(),
            ] else ...[
              const Text(
                'No data was passed to this screen.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 48),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the section displaying passed data
  Widget _buildDataSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Received Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.arguments!.id != null) ...[
              _buildDataRow('ID', widget.arguments!.id!),
              const SizedBox(height: 8),
            ],
            if (widget.arguments!.title != null) ...[
              _buildDataRow('Title', widget.arguments!.title!),
              const SizedBox(height: 8),
            ],
            if (widget.arguments!.data != null) ...[
              const Text(
                'Additional Data:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildDataDetails(widget.arguments!.data),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a single data row
  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  /// Builds detailed data display (handles various data types)
  Widget _buildDataDetails(dynamic data) {
    if (data is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in data.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• ${entry.key}: ${entry.value}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
        ],
      );
    } else {
      return Text(
        data.toString(),
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      );
    }
  }

  /// Builds navigation buttons
  Widget _buildNavigationButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to profile, replacing details screen
            final profileData = RouteArguments(
              id: 'user-profile-detail',
              title: 'User Profile',
              data: {'username': 'john_doe', 'status': 'active'},
            );

            _appRouter.navigateTo(AppRoute.profile, data: profileData);
          },
          icon: const Icon(Icons.person),
          label: const Text('Go to Profile (Replace)'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Go back to home
            _appRouter.navigateTo(AppRoute.home);
          },
          icon: const Icon(Icons.home),
          label: const Text('Go to Home (Replace)'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
