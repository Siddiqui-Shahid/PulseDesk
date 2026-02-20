import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'router/app_route.dart';
import 'router/route_models.dart';
import 'network/network_manager.dart';
import 'network/network_routes.dart';
import 'network/network_service.dart';
import 'database/local_database_manager.dart';
import 'repositories/repositories.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/not_found_screen.dart';

void main() async {
  // Initialize local database
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseManager.initialize();

  // Initialize network layer
  final networkService = NetworkService(
    baseUrl: '${NetworkProtocol.https.value}://${NetworkBase.production.value}',
  );
  final networkManager = NetworkManager(
    service: networkService,
    protocol: NetworkProtocol.https,
    base: NetworkBase.production,
  );

  // Initialize repositories
  RepositoryLocator.setup(
    networkManager: networkManager,
    localDb: LocalDatabaseManager(),
  );

  // Check if user is already authenticated
  final isAuthenticated = LocalDatabaseManager().isAuthenticated();

  runApp(MyApp(isAuthenticated: isAuthenticated));
}

/// Main application widget
///
/// Sets up the router system, network layer, and initializes all routes
class MyApp extends StatefulWidget {
  final bool isAuthenticated;

  const MyApp({Key? key, this.isAuthenticated = false}) : super(key: key);
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
    _setupRoutes();
    _setupRouteListeners();
  }

  /// Registers all routes with their corresponding screen builders
  ///
  /// This demonstrates the route registration pattern
  void _setupRoutes() {
    _appRouter.registerRoutes({
      // Home route - entry point
      AppRoute.home: (context) => const HomeScreen(),

      // Details route - receives RouteArguments with product/item data
      AppRoute.details: (context) {
        // Extract arguments from the navigation arguments
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

  /// Sets up listeners to track route changes
  ///
  /// This is useful for analytics, logging, or state management
  void _setupRouteListeners() {
    _appRouter.addRouteListener((route, args) {
      // Log route changes
      debugPrint('📍 Route changed to: ${route.path}');
      if (args != null) {
        debugPrint('   Arguments: $args');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseDesk - Router Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Use the router's navigator key for programmatic navigation
      navigatorKey: _appRouter.navigatorKey,
      // Define named routes for navigation
      onGenerateRoute: (settings) {
        // Parse the route path
        final route = AppRoute.fromPath(settings.name ?? '');

        // Get the builder for the route
        final builder = _appRouter.getRouteBuilder(route);

        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        }

        // Fallback to not found screen
        return MaterialPageRoute(
          builder: (context) => NotFoundScreen(attemptedPath: settings.name),
          settings: settings,
        );
      },
      // Initial route
      initialRoute: AppRoute.home.path,
    );
  }
}
