import 'package:flutter/material.dart';
import '../view_models/home_view_model.dart';

/// Custom Widget for Welcome Header Section
///
/// Displays the welcome icon, title, and subtitle
class WelcomeHeaderWidget extends StatelessWidget {
  final WelcomeData data;

  const WelcomeHeaderWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(data.icon, size: 80, color: Colors.blue),
        const SizedBox(height: 24),
        Text(
          data.title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          data.subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

/// Custom Widget for Navigation Buttons Section
///
/// Displays all navigation buttons in a column layout
class NavigationButtonsWidget extends StatelessWidget {
  final List<NavigationItem> items;

  const NavigationButtonsWidget({Key? key, required this.items})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        items.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _NavigationButtonItem(item: items[index]),
        ),
      ),
    );
  }
}

/// Individual Navigation Button Widget
///
/// Represents a single navigation button with icon and label
class _NavigationButtonItem extends StatelessWidget {
  final NavigationItem item;

  const _NavigationButtonItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => item.onTap(context),
      icon: Icon(item.icon),
      label: Text(item.label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: item.color,
        foregroundColor: Colors.white,
      ),
    );
  }
}
