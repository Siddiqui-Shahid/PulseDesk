import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'router/app_route.dart';
import 'network/network_manager.dart';
import 'network/network_routes.dart';
import 'network/network_service.dart';
import 'database/local_database_manager.dart';
import 'repositories/repositories.dart';

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
    _appRouter.setupRoutes();
    _setupRouteListeners();
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

        // Fallback to not found screen (handled by AppRouter)
        final notFoundBuilder = _appRouter.getRouteBuilder(AppRoute.notFound);
        return MaterialPageRoute(
          builder: notFoundBuilder ?? (context) => const SizedBox(),
          settings: settings,
        );
      },
      // Initial route
      initialRoute: AppRoute.home.path,
    );
  }
}
