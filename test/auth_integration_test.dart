import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/network/network_manager.dart';
import 'package:pulsedesk/network/network_routes.dart';
import 'package:pulsedesk/network/network_service.dart';
import 'package:pulsedesk/repositories/repositories.dart';
import 'package:pulsedesk/database/local_database_manager.dart';

void main() {
  group('Authentication Integration Tests', () {
    late NetworkManager networkManager;
    late AuthRepository authRepository;

    setUpAll(() async {
      // Initialize local database
      await LocalDatabaseManager.initialize();

      // Create network manager pointing to localhost backend
      final networkService = NetworkService(
        baseUrl:
            '${NetworkProtocol.http.value}://${NetworkBase.localhostDevice.value}',
      );
      networkManager = NetworkManager(
        service: networkService,
        protocol: NetworkProtocol.http,
        base: NetworkBase.localhostDevice,
      );

      // Create auth repository
      authRepository = AuthRepository(
        networkManager: networkManager,
        localDb: LocalDatabaseManager(),
      );
    });

    test('Signup creates a new user successfully', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testUser = 'testuser_$timestamp';
      final testEmail = 'test_$timestamp@example.com';
      final testPassword = 'testpass123';

      // Call signup
      final user = await authRepository.signup(
        email: testEmail,
        username: testUser,
        password: testPassword,
      );

      // Verify response
      expect(user, isNotNull);
      expect(user.email, equals(testEmail));
      expect(user.username, equals(testUser));
      expect(user.id, isNotEmpty);
      expect(user.createdAt, isNotNull);
    });

    test('Signup fails with duplicate email', () async {
      const testEmail = 'duplicate@example.com';
      const testPassword = 'testpass123';

      // Create first user
      await authRepository.signup(
        email: testEmail,
        username: 'user1',
        password: testPassword,
      );

      // Try to create second user with same email
      expect(
        () => authRepository.signup(
          email: testEmail,
          username: 'user2',
          password: testPassword,
        ),
        throwsException,
      );
    });
  });
}
