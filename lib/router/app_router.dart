import 'package:flutter/material.dart';
import 'app_route.dart';
import 'route_models.dart';
import '../screens/home_screen.dart';
import '../screens/details_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/not_found_screen.dart';

/// Central router class that manages all navigation in the application.
///
/// Inspired by patterns from go_router, auto_route, and Navigator 2.0.
/// This implementation provides:
/// - Route registration and management
/// - Strong typing for route arguments
/// - String-to-enum path conversion
/// - Navigation methods (navigateTo, pushRoute)
/// - Error handling for invalid routes
class AppRouter {
  // Singleton instance
  static final AppRouter _instance = AppRouter._internal();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._internal();

  // Global navigator key for accessing Navigator state outside of context
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Route registry: maps AppRoute enum to the corresponding screen builder
  final Map<AppRoute, WidgetBuilder> _routeRegistry = {};

  // Stack to track navigation history
  final List<AppRoute> _routeHistory = [AppRoute.home];

  // Callbacks for route changes (useful for logging, analytics, etc.)
  final List<Function(AppRoute route, RouteArguments? args)> _routeListeners =
      [];

  /// Registers a route with its corresponding screen builder
  ///
  /// Example:
  /// ```dart
  /// appRouter.registerRoute(
  ///   AppRoute.home,
  ///   (context) => const HomeScreen(),
  /// );
  /// ```
  void registerRoute(AppRoute route, WidgetBuilder builder) {
    _routeRegistry[route] = builder;
  }

  /// Registers multiple routes at once
  ///
  /// Useful for setting up all routes in one place during app initialization
  void registerRoutes(Map<AppRoute, WidgetBuilder> routes) {
    _routeRegistry.addAll(routes);
  }

  /// Gets the builder for a specific route
  ///
  /// Returns null if the route is not registered
  WidgetBuilder? getRouteBuilder(AppRoute route) {
    return _routeRegistry[route];
  }

  /// Adds a listener that gets called whenever navigation occurs
  void addRouteListener(
    Function(AppRoute route, RouteArguments? args) listener,
  ) {
    _routeListeners.add(listener);
  }

  /// Removes a route listener
  void removeRouteListener(
    Function(AppRoute route, RouteArguments? args) listener,
  ) {
    _routeListeners.remove(listener);
  }

  /// Notifies all listeners of a route change
  void _notifyListeners(AppRoute route, RouteArguments? args) {
    for (final listener in _routeListeners) {
      listener(route, args);
    }
  }

  /// Navigates to a route, replacing the current screen
  ///
  /// This is like Navigator.of(context).pushReplacementNamed()
  ///
  /// Parameters:
  /// - [route]: The target AppRoute enum
  /// - [data]: Optional data to pass to the target screen
  ///
  /// Returns:
  /// - RouteResult indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await appRouter.navigateTo(
  ///   AppRoute.details,
  ///   data: RouteArguments(id: '123', title: 'Product'),
  /// );
  /// ```
  Future<RouteResult> navigateTo(AppRoute route, {dynamic data}) async {
    try {
      final builder = _routeRegistry[route];

      if (builder == null) {
        return RouteResult(
          success: false,
          errorMessage: 'Route ${route.path} is not registered',
        );
      }

      // Store the arguments in a way the destination can access them
      final arguments = _prepareArguments(data);

      // Update history
      if (_routeHistory.isNotEmpty) {
        _routeHistory.removeLast();
      }
      _routeHistory.add(route);

      // Notify listeners
      _notifyListeners(route, arguments);

      // Navigate using the navigator key
      await navigatorKey.currentState?.pushReplacementNamed(
        route.path,
        arguments: arguments,
      );

      return RouteResult(success: true);
    } catch (e) {
      return RouteResult(success: false, errorMessage: 'Navigation error: $e');
    }
  }

  /// Pushes a new route onto the navigation stack
  ///
  /// This is like Navigator.of(context).pushNamed()
  /// The previous screen remains in the stack and can be returned to.
  ///
  /// Parameters:
  /// - [route]: The target AppRoute enum
  /// - [data]: Optional data to pass to the target screen
  ///
  /// Returns:
  /// - Future that resolves when the screen is popped (if anything is returned)
  /// - RouteResult indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await appRouter.pushRoute(
  ///   AppRoute.profile,
  ///   data: RouteArguments(id: 'user123'),
  /// );
  /// ```
  Future<RouteResult> pushRoute(AppRoute route, {dynamic data}) async {
    try {
      final builder = _routeRegistry[route];

      if (builder == null) {
        return RouteResult(
          success: false,
          errorMessage: 'Route ${route.path} is not registered',
        );
      }

      // Store the arguments in a way the destination can access them
      final arguments = _prepareArguments(data);

      // Update history
      _routeHistory.add(route);

      // Notify listeners
      _notifyListeners(route, arguments);

      // Navigate using the navigator key
      await navigatorKey.currentState?.pushNamed(
        route.path,
        arguments: arguments,
      );

      return RouteResult(success: true);
    } catch (e) {
      return RouteResult(success: false, errorMessage: 'Navigation error: $e');
    }
  }

  /// Pops the current route from the stack
  ///
  /// Returns to the previous screen
  ///
  /// Example:
  /// ```dart
  /// appRouter.pop();
  /// ```
  void pop<T>([T? result]) {
    if (_routeHistory.isNotEmpty) {
      _routeHistory.removeLast();
    }
    navigatorKey.currentState?.pop(result);
  }

  /// Converts a string path to its AppRoute enum and navigates to it
  ///
  /// Useful when you have a dynamic path string
  ///
  /// Example:
  /// ```dart
  /// await appRouter.navigateByPath('/details');
  /// ```
  Future<RouteResult> navigateByPath(String pathString, {dynamic data}) async {
    final route = AppRoute.fromPath(pathString);

    if (route == AppRoute.notFound) {
      return RouteResult(
        success: false,
        errorMessage: 'Invalid path: $pathString',
      );
    }

    return navigateTo(route, data: data);
  }

  /// Gets the current route at the top of the stack
  AppRoute? get currentRoute =>
      _routeHistory.isNotEmpty ? _routeHistory.last : null;

  /// Gets the complete route history
  List<AppRoute> get routeHistory => List.unmodifiable(_routeHistory);

  /// Checks if a route is registered
  bool isRouteRegistered(AppRoute route) {
    return _routeRegistry.containsKey(route);
  }

  /// Gets the Navigator state
  NavigatorState? get navigatorState => navigatorKey.currentState;

  /// Clears the route history (useful for app initialization)
  void clearHistory() {
    _routeHistory.clear();
    _routeHistory.add(AppRoute.home);
  }

  /// Prepares arguments for navigation
  ///
  /// Converts different types of data into RouteArguments
  RouteArguments _prepareArguments(dynamic data) {
    if (data == null) {
      return const RouteArguments();
    }

    if (data is RouteArguments) {
      return data;
    }

    // If it's a Map, assume it's named parameters
    if (data is Map<String, dynamic>) {
      return RouteArguments(
        id: data['id'],
        title: data['title'],
        data: data['data'],
      );
    }

    // Otherwise, wrap it as generic data
    return RouteArguments(data: data);
  }

  /// Registers all application routes with their screen builders
  ///
  /// This method sets up the route registry with all available screens.
  /// Call this during app initialization to prepare the router.
  ///
  /// Example:
  /// ```dart
  /// _appRouter.setupRoutes();
  /// ```
  void setupRoutes() {
    registerRoutes({
      // Home route - entry point
      AppRoute.home: (context) => const HomeScreen(),

      // Details route - receives RouteArguments with product/item data
      AppRoute.details: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        return DetailsScreen(arguments: args is RouteArguments ? args : null);
      },

      // Profile route - receives user profile data
      AppRoute.profile: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        return ProfileScreen(arguments: args is RouteArguments ? args : null);
      },

      // Settings route - simple screen without data
      AppRoute.settings: (context) => const SettingsScreen(),

      // Not found route - fallback for invalid paths
      AppRoute.notFound: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        return NotFoundScreen(attemptedPath: args is String ? args : null);
      },
    });
  }
}
