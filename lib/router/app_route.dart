/// Enum defining all available routes in the application.
/// Each enum value corresponds to a unique route path.
///
/// Pattern: Use the enum value name as the route path (e.g., AppRoute.home -> '/home')
enum AppRoute {
  home('/home'),
  details('/details'),
  profile('/profile'),
  settings('/settings'),
  notFound('/not-found');

  /// The string path associated with this route
  final String path;

  const AppRoute(this.path);

  /// Converts a string path to its corresponding AppRoute enum value
  ///
  /// Returns AppRoute.notFound if the path doesn't match any route
  /// Handles paths with or without leading slash
  static AppRoute fromPath(String pathString) {
    // Normalize the path: ensure it starts with '/'
    final normalizedPath = pathString.startsWith('/')
        ? pathString
        : '/$pathString';

    try {
      return AppRoute.values.firstWhere(
        (route) => route.path == normalizedPath,
        orElse: () => AppRoute.notFound,
      );
    } catch (e) {
      return AppRoute.notFound;
    }
  }

  /// Checks if the path is valid (exists in enum)
  static bool isValidPath(String pathString) {
    return fromPath(pathString) != AppRoute.notFound;
  }
}
