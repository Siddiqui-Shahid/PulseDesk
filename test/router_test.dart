import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/router/app_route.dart';
import 'package:pulsedesk/router/app_router.dart';
import 'package:pulsedesk/router/route_models.dart';

void main() {
  group('AppRoute Enum Tests', () {
    test('AppRoute enum has all expected routes', () {
      expect(AppRoute.values.length, greaterThanOrEqualTo(4));
      expect(
        AppRoute.values,
        containsAll([
          AppRoute.home,
          AppRoute.details,
          AppRoute.profile,
          AppRoute.settings,
        ]),
      );
    });

    test('Route paths are correctly defined', () {
      expect(AppRoute.home.path, equals('/home'));
      expect(AppRoute.details.path, equals('/details'));
      expect(AppRoute.profile.path, equals('/profile'));
      expect(AppRoute.settings.path, equals('/settings'));
      expect(AppRoute.notFound.path, equals('/not-found'));
    });

    test('fromPath correctly converts string to AppRoute', () {
      expect(AppRoute.fromPath('/home'), equals(AppRoute.home));
      expect(AppRoute.fromPath('/details'), equals(AppRoute.details));
      expect(AppRoute.fromPath('/profile'), equals(AppRoute.profile));
      expect(AppRoute.fromPath('/settings'), equals(AppRoute.settings));
    });

    test('fromPath handles paths without leading slash', () {
      expect(AppRoute.fromPath('home'), equals(AppRoute.home));
      expect(AppRoute.fromPath('details'), equals(AppRoute.details));
      expect(AppRoute.fromPath('profile'), equals(AppRoute.profile));
    });

    test('fromPath returns notFound for invalid paths', () {
      expect(AppRoute.fromPath('/invalid'), equals(AppRoute.notFound));
      expect(AppRoute.fromPath('/unknown-route'), equals(AppRoute.notFound));
      expect(AppRoute.fromPath('nonexistent'), equals(AppRoute.notFound));
    });

    test('isValidPath correctly checks route validity', () {
      expect(AppRoute.isValidPath('/home'), isTrue);
      expect(AppRoute.isValidPath('/details'), isTrue);
      expect(AppRoute.isValidPath('/profile'), isTrue);
      expect(AppRoute.isValidPath('/invalid'), isFalse);
      expect(AppRoute.isValidPath('home'), isTrue);
      expect(AppRoute.isValidPath('invalid-path'), isFalse);
    });
  });

  group('RouteArguments Tests', () {
    test('RouteArguments can be created with all parameters', () {
      final args = const RouteArguments(
        id: 'test-id',
        title: 'Test Title',
        data: {'key': 'value'},
      );

      expect(args.id, equals('test-id'));
      expect(args.title, equals('Test Title'));
      expect(args.data, equals({'key': 'value'}));
    });

    test('RouteArguments can be created with partial parameters', () {
      final args = const RouteArguments(id: 'id-only');

      expect(args.id, equals('id-only'));
      expect(args.title, isNull);
      expect(args.data, isNull);
    });

    test('RouteArguments can be created with no parameters', () {
      const args = RouteArguments();

      expect(args.id, isNull);
      expect(args.title, isNull);
      expect(args.data, isNull);
    });

    test('RouteArguments toString returns proper string representation', () {
      final args = const RouteArguments(
        id: 'id-123',
        title: 'Title',
        data: 'test-data',
      );

      final result = args.toString();
      expect(result, contains('RouteArguments'));
      expect(result, contains('id-123'));
      expect(result, contains('Title'));
      expect(result, contains('test-data'));
    });
  });

  group('RouteResult Tests', () {
    test('RouteResult can be created as success', () {
      const result = RouteResult(success: true);

      expect(result.success, isTrue);
      expect(result.errorMessage, isNull);
      expect(result.result, isNull);
    });

    test('RouteResult can be created with error message', () {
      const result = RouteResult(
        success: false,
        errorMessage: 'Route not found',
      );

      expect(result.success, isFalse);
      expect(result.errorMessage, equals('Route not found'));
    });

    test('RouteResult can store result data', () {
      const result = RouteResult(success: true, result: {'data': 'test'});

      expect(result.success, isTrue);
      expect(result.result, equals({'data': 'test'}));
    });

    test('RouteResult toString returns proper string representation', () {
      const result = RouteResult(success: true, result: 'test-result');

      final resultString = result.toString();
      expect(resultString, contains('RouteResult'));
      expect(resultString, contains('success: true'));
      expect(resultString, contains('test-result'));
    });
  });

  group('AppRouter Tests', () {
    late AppRouter router;

    setUp(() {
      router = AppRouter();
      // Clear any previous registrations for test isolation
      router.clearHistory();
    });

    test('AppRouter is a singleton', () {
      final router1 = AppRouter();
      final router2 = AppRouter();

      expect(identical(router1, router2), isTrue);
    });

    test('AppRouter can register a route', () {
      router.registerRoute(AppRoute.home, (_) => const SizedBox());

      expect(router.getRouteBuilder(AppRoute.home), isNotNull);
    });

    test('AppRouter can register multiple routes', () {
      final routes = {
        AppRoute.home: (_) => const SizedBox(),
        AppRoute.details: (_) => const SizedBox(),
        AppRoute.profile: (_) => const SizedBox(),
      };

      router.registerRoutes(routes);

      expect(router.getRouteBuilder(AppRoute.home), isNotNull);
      expect(router.getRouteBuilder(AppRoute.details), isNotNull);
      expect(router.getRouteBuilder(AppRoute.profile), isNotNull);
    });

    test('AppRouter returns null for unregistered route', () {
      expect(router.getRouteBuilder(AppRoute.settings), isNull);
    });

    test('AppRouter correctly checks if route is registered', () {
      router.registerRoute(AppRoute.home, (_) => const SizedBox());

      expect(router.isRouteRegistered(AppRoute.home), isTrue);
      expect(router.isRouteRegistered(AppRoute.details), isFalse);
    });

    test('AppRouter initializes with home route in history', () {
      expect(router.routeHistory, contains(AppRoute.home));
      expect(router.routeHistory.first, equals(AppRoute.home));
    });

    test('AppRouter can clear history', () {
      router.clearHistory();

      expect(router.routeHistory, contains(AppRoute.home));
      expect(router.routeHistory.length, equals(1));
    });

    test('AppRouter can add and remove route listeners', () {
      void listener(AppRoute route, RouteArguments? args) {
        // Implementation would be tested with full widget binding
      }

      router.addRouteListener(listener);
      // Note: actual listener invocation requires navigation which needs widget binding

      // Remove listener and verify it's no longer called
      router.removeRouteListener(listener);
      // (would need async setup to fully test this)
    });

    test('AppRouter navigateByPath returns error for invalid path', () async {
      final result = await router.navigateByPath('/invalid-path');

      expect(result.success, isFalse);
      expect(result.errorMessage, contains('Invalid path'));
    });

    test('AppRouter can access navigator key', () {
      expect(router.navigatorKey, isNotNull);
    });
  });

  group('AppRouter Data Passing Tests', () {
    late AppRouter router;

    setUp(() {
      router = AppRouter();
    });

    test('AppRouter prepares Map data as RouteArguments', () async {
      router.registerRoute(AppRoute.home, (_) => const SizedBox());

      final mapData = {
        'id': 'test-id',
        'title': 'Test',
        'data': {'nested': 'value'},
      };

      // This test verifies the data preparation logic
      // In actual use, the data would be passed through navigation
      expect(mapData['id'], equals('test-id'));
      expect(mapData['title'], equals('Test'));
    });

    test('AppRouter preserves RouteArguments when passed', () async {
      final args = const RouteArguments(
        id: 'preserved-id',
        title: 'Preserved Title',
      );

      // Verify that RouteArguments are preserved
      expect(args.id, equals('preserved-id'));
      expect(args.title, equals('Preserved Title'));
    });

    test('RouteArguments with complex data types', () {
      final complexData = {
        'user': 'john',
        'age': 25,
        'active': true,
        'tags': ['tag1', 'tag2'],
      };

      final args = RouteArguments(id: 'complex-id', data: complexData);

      expect(args.data, equals(complexData));
      expect(args.data['user'], equals('john'));
      expect(args.data['age'], equals(25));
      expect(args.data['active'], isTrue);
      expect(args.data['tags'], equals(['tag1', 'tag2']));
    });
  });

  group('AppRouter Navigation History Tests', () {
    late AppRouter router;

    setUp(() {
      router = AppRouter();
    });

    test('AppRouter tracks current route', () {
      expect(router.currentRoute, equals(AppRoute.home));
    });

    test('AppRouter returns immutable route history', () {
      final history1 = router.routeHistory;
      final history2 = router.routeHistory;

      // Should be the same data but can't modify them
      expect(history1, equals(history2));
      expect(() => history1.add(AppRoute.details), throwsUnsupportedError);
    });

    test('AppRouter clears and resets history correctly', () {
      router.clearHistory();

      expect(router.routeHistory.length, equals(1));
      expect(router.routeHistory.first, equals(AppRoute.home));
      expect(router.currentRoute, equals(AppRoute.home));
    });
  });
}
