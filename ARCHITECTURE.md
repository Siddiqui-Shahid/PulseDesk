# PulseDesk - Complete Architecture Guide

This document explains the complete architecture of PulseDesk, including routing, networking, data persistence, and repositories.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Routing System](#routing-system)
3. [Network Layer](#network-layer)
4. [Data Models](#data-models)
5. [Repositories](#repositories)
6. [Local Persistence](#local-persistence)
7. [Complete Example Flow](#complete-example-flow)
8. [Testing & Mocking](#testing--mocking)

---

## Architecture Overview

```
┌─────────────────────────────────────────┐
│          UI Layer (Screens)             │
│  (HomeScreen, DetailsScreen, etc.)      │
└────────────┬──────────────────────────┘
             │
┌────────────▼──────────────────────────┐
│      Router Layer (AppRouter)         │
│  - Route navigation                   │
│  - Data passing between screens       │
└────────────┬──────────────────────────┘
             │
┌────────────▼──────────────────────────┐
│    Repository Layer (Repositories)    │
│  - AuthRepository                     │
│  - UserRepository                     │
│  - PostRepository                     │
└────────────┬──────────────────────────┘
             │
┌────────────▼──────────────────────────┐
│    Network Layer (NetworkManager)     │
│  - HTTP requests                      │
│  - Response parsing                   │
│  - Error handling                     │
└────────────┬──────────────────────────┘
             │
┌────────────▼──────────────────────────┐
│ Network Service (NetworkService)      │
│  - HTTP client (http package)         │
│  - URI building                       │
│  - Request execution                  │
└────────────┬──────────────────────────┘
             │
┌────────────▼──────────────────────────┐
│    Local DB (LocalDatabaseManager)    │
│  - Token caching                      │
│  - User preferences                   │
│  - Post caching                       │
└─────────────────────────────────────────┘
```

---

## Routing System

### Route Definition (Enum-Based)

```dart
enum AppRoute {
  home('/home'),
  details('/details'),
  profile('/profile'),
  settings('/settings'),
  notFound('/not-found');

  final String path;
  const AppRoute(this.path);

  // Convert string to AppRoute
  static AppRoute fromPath(String pathString) { ... }

  // Validate path
  static bool isValidPath(String pathString) { ... }
}
```

### Navigation with Data

```dart
// Simple navigation
appRouter.pushRoute(AppRoute.home);

// Navigation with typed data
final arguments = RouteArguments(
  id: 'product-123',
  title: 'Amazing Product',
  data: {'price': 99.99, 'inStock': true},
);
appRouter.pushRoute(AppRoute.details, data: arguments);

// Replace current screen
appRouter.navigateTo(AppRoute.home);

// Navigate by string path
appRouter.navigateByPath('/details');

// Go back
appRouter.pop();
```

---

## Network Layer

### 3-Tier Network Stack

#### 1. Network Routes Configuration

```dart
// Enum-based, no hardcoded URLs
enum NetworkProtocol { http, https }
enum NetworkBase { production, staging, localhostDevice }
enum NetworkEndpoint { login, user, posts }

// Usage
final url = getNetworkUrl(
  NetworkProtocol.https,
  NetworkBase.production,
  NetworkEndpoint.login,
);
// Result: https://api.pulsedesk.com/auth/login
```

**Benefits:**
- Switch environments without code changes
- Type-safe endpoint access
- Single source of truth for URLs

#### 2. Network Service (HTTP Implementation)

```dart
final networkService = NetworkService(
  baseUrl: 'https://api.pulsedesk.com',
);

final response = await networkService.request(
  method: 'POST',
  path: '/auth/login',
  headers: {'Authorization': 'Bearer token'},
  data: {'email': 'user@example.com', 'password': 'pass'},
  timeout: Duration(seconds: 30),
);

print(response.statusCode);      // 200
print(response.body);             // {token, user}
print(response.isSuccess);        // true
```

#### 3. Network Manager (High-Level Coordinator)

```dart
final networkManager = NetworkManager.create(
  protocol: NetworkProtocol.https,
  base: NetworkBase.production,
);

// Type-safe requests with decoders
final user = await networkManager.get<User>(
  endpoint: NetworkEndpoint.profile,
  decoder: (json) => User.fromJson(json),
);

// Convenience methods
final posts = await networkManager.post<List<Post>>(
  endpoint: NetworkEndpoint.posts,
  data: {'title': 'Hello'},
  decoder: (json) => (json as List).map((p) => Post.fromJson(p)).toList(),
);

// Safe requests that return Result<T>
final result = await networkManager.requestSafe<User>(
  method: HttpMethod.get,
  endpoint: NetworkEndpoint.profile,
  decoder: (json) => User.fromJson(json),
);

if (result.isSuccess) {
  print(result.data);
} else {
  print(result.error);
}
```

### Network Methods

**GET Request:**
```dart
final posts = await networkManager.get<List<Post>>(
  endpoint: NetworkEndpoint.posts,
  params: {'page': 1, 'limit': 10},
  decoder: (json) => _decodePosts(json),
);
```

**POST Request:**
```dart
final user = await networkManager.post<User>(
  endpoint: NetworkEndpoint.signup,
  data: {
    'email': 'user@example.com',
    'password': 'secure123',
    'username': 'johndoe',
  },
  decoder: (json) => User.fromJson(json),
);
```

**PUT Request:**
```dart
final updated = await networkManager.put<User>(
  endpoint: NetworkEndpoint.updateProfile,
  data: {'name': 'John Doe', 'phone': '+1-234-567-8900'},
  decoder: (json) => User.fromJson(json),
);
```

**DELETE Request:**
```dart
await networkManager.delete(
  endpoint: NetworkEndpoint.user,
  params: {'id': 'user-123'},
);
```

---

## Data Models

### Standard API Response

```dart
// API Response Wrapper
final response = ApiResponse.fromJson(jsonData, (data) => User.fromJson(data));

if (response.isSuccess) {
  final user = response.data;
}
```

### User Model

```dart
const user = User(
  id: 1,
  email: 'john@example.com',
  username: 'johndoe',
  name: 'John Doe',
  profileImage: 'https://...',
  phone: '+1-234-567-8900',
  createdAt: DateTime(2024, 1, 15),
);

// Serialization
final json = user.toJson();
final userFromJson = User.fromJson(json);
```

### Authentication Response

```dart
const authResponse = AuthResponse(
  token: 'eyJhbGc...',
  refreshToken: 'refresh_token...',
  user: user,
  expiresAt: DateTime(2024, 1, 16),
);

// Check if token expired
if (authResponse.isTokenExpired) {
  // Refresh token
}
```

### Paginated Response

```dart
final pagedPosts = PaginatedResponse<Post>.fromJson(
  jsonData,
  (item) => Post.fromJson(item),
);

print(pagedPosts.items);        // List of posts
print(pagedPosts.page);         // Current page
print(pagedPosts.hasNextPage);  // Whether more pages exist
```

---

## Repositories

Repositories sit between UI and network layer, handling:
- Network requests
- Caching
- Error handling
- Business logic

### Authentication Repository

```dart
final authRepo = RepositoryLocator.auth;

// Login
try {
  final authResponse = await authRepo.login(
    email: 'user@example.com',
    password: 'password123',
  );
  
  final user = authResponse.user;
  final token = authResponse.token;
  
  // Token is automatically cached and set for future requests
} catch (e) {
  print('Login failed: $e');
}

// Sign up
final newUser = await authRepo.signup(
  email: 'new@example.com',
  username: 'newuser',
  password: 'password123',
);

// Refresh token
final newAuth = await authRepo.refreshToken();

// Logout
await authRepo.logout();  // Clears cached data

// Check authentication
if (authRepo.isAuthenticated()) {
  final user = authRepo.getCachedUser();
}
```

### User Repository

```dart
final userRepo = RepositoryLocator.user;

// Get profile
final profile = await userRepo.getProfile();

// Update profile
final updated = await userRepo.updateProfile(
  name: 'John Doe',
  phone: '+1-234-567-8900',
);

// Get user by ID
final user = await userRepo.getUserById(123);
```

### Post Repository

```dart
final postRepo = RepositoryLocator.post;

// Get paginated posts
final paginatedPosts = await postRepo.getPosts(
  page: 1,
  pageSize: 20,
);

// Cache posts locally
await postRepo.cachePost(post);

// Get cached posts
final cached = postRepo.getCachedPosts();

// Clear cache
await postRepo.clearPostCache();
```

### Repository Locator

Access repositories from anywhere:

```dart
// In screens or business logic
final authRepo = RepositoryLocator.auth;
final userRepo = RepositoryLocator.user;
final postRepo = RepositoryLocator.post;
```

---

## Local Persistence

### Storing and Retrieving Data

```dart
final localDb = LocalDatabaseManager();

// String values
await localDb.setString(LocalDbKey.userPreferences, 'dark_mode');
final pref = localDb.getString(LocalDbKey.userPreferences);

// JSON objects
await localDb.setJson(LocalDbKey.user, user.toJson());
final userJson = localDb.getJson(LocalDbKey.user);

// Lists
await localDb.setJsonList(LocalDbKey.cachedPosts, postJsonList);
final posts = localDb.getJsonList(LocalDbKey.cachedPosts);

// Boolean
await localDb.setBool(LocalDbKey.userPreferences, true);
final isDarkMode = localDb.getBool(LocalDbKey.userPreferences, defaultValue: false);
```

### Token Management

```dart
// Repositories handle this automatically, but you can also:
await localDb.setAuthToken('new_token');
final token = localDb.getAuthToken();

await localDb.setRefreshToken('refresh_token');
final refreshToken = localDb.getRefreshToken();

// Check authentication
if (localDb.isAuthenticated()) {
  // User is logged in
}

// Logout (clear all auth data)
await localDb.clearAuth();
```

### Debug and Cleanup

```dart
// Print all stored data
localDb.printAllData();

// Get storage size
final sizeBytes = localDb.getApproximateSize();

// Check if key exists
if (localDb.hasKey(LocalDbKey.authToken)) {
  // Token is stored
}

// Remove specific key
await localDb.remove(LocalDbKey.userPreferences);

// Remove multiple keys
await localDb.removeMultiple([
  LocalDbKey.authToken,
  LocalDbKey.user,
]);

// Clear everything
await localDb.clearAll();
```

---

## Complete Example Flow

### Login Flow

```dart
// 1. User enters credentials on login screen
final email = 'user@example.com';
final password = 'password123';

// 2. Call repository
final authRepo = RepositoryLocator.auth;
try {
  final authResponse = await authRepo.login(
    email: email,
    password: password,
  );
  
  // 3. Repository handles:
  //    - Network request via NetworkManager
  //    - Token caching via LocalDatabaseManager
  //    - Setting auth headers for future requests
  
  // 4. Navigate to home with user data
  appRouter.navigateTo(
    AppRoute.home,
    data: RouteArguments(
      id: authResponse.user.id.toString(),
      title: 'Welcome ${authResponse.user.name}',
      data: authResponse.user,
    ),
  );
  
} catch (e) {
  // Show error to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Login failed: $e')),
  );
}
```

### Fetching Posts Flow

```dart
// 1. User navigates to posts screen
appRouter.pushRoute(AppRoute.details);

// 2. In the screen's initState or build
@override
void initState() {
  super.initState();
  _loadPosts();
}

void _loadPosts() async {
  final postRepo = RepositoryLocator.post;
  
  try {
    // 3. Repository fetches using NetworkManager
    final paginatedPosts = await postRepo.getPosts(page: 1, pageSize: 20);
    
    // 4. Cache locally
    for (final post in paginatedPosts.items) {
      await postRepo.cachePost(post);
    }
    
    // 5. Update UI
    setState(() {
      _posts = paginatedPosts.items;
    });
    
  } catch (e) {
    // 6. Handle errors
    print('Failed to load posts: $e');
    
    // 7. Try showing cached posts as fallback
    final cached = postRepo.getCachedPosts();
    if (cached.isNotEmpty) {
      setState(() {
        _posts = cached
            .map((json) => Post.fromJson(json))
            .toList();
      });
    }
  }
}
```

### Token Refresh Flow

```dart
// When an unauthorized (401) response is received
Future<void> _handleUnauthorized() async {
  final authRepo = RepositoryLocator.auth;
  
  try {
    // Try to refresh the token
    final newAuth = await authRepo.refreshToken();
    
    // Token is automatically cached and headers updated
    print('Token refreshed successfully');
    
    // Retry the original request
    // (In a real app, implement a request queue for this)
    
  } catch (e) {
    // Refresh failed, logout user
    await authRepo.logout();
    
    // Navigate to login
    appRouter.navigateTo(AppRoute.home);
  }
}
```

---

## Testing & Mocking

### Mock Network Service

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Create a mock Networkservice
class MockNetworkService extends Mock implements NetworkServiceProtocol {
  @override
  Future<NetworkResponse> request({
    required String method,
    required String path,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return NetworkResponse(
      statusCode: 200,
      body: {'user': {'id': 1, 'name': 'John'}},
      headers: {},
    );
  }
}

// Test with mock
void main() {
  test('AuthRepository.login', () async {
    final mockService = MockNetworkService();
    final networkManager = NetworkManager(service: mockService);
    final localDb = LocalDatabaseManager();
    
    final authRepo = AuthRepository(
      networkManager: networkManager,
      localDb: localDb,
    );
    
    final response = await authRepo.login(
      email: 'test@example.com',
      password: 'password',
    );
    
    expect(response.user.id, equals(1));
  });
}
```

### Mock Repositories

```dart
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('Login success', () async {
    final mockAuth = MockAuthRepository();
    
    when(mockAuth.login(
      email: 'test@example.com',
      password: 'password',
    )).thenAnswer((_) async => mockAuthResponse);
    
    final result = await mockAuth.login(
      email: 'test@example.com',
      password: 'password',
    );
    
    expect(result.token, isNotNull);
  });
}
```

---

## Environment Switching

Switch between development, staging, and production without code changes:

```dart
// In main.dart or app initialization
final baseUrl = kDebugMode 
  ? '${NetworkProtocol.http.value}://${NetworkBase.localhostDevice.value}'
  : '${NetworkProtocol.https.value}://${NetworkBase.production.value}';

final networkManager = NetworkManager.create(
  baseUrl: baseUrl,
  protocol: kDebugMode ? NetworkProtocol.http : NetworkProtocol.https,
  base: kDebugMode ? NetworkBase.localhostDevice : NetworkBase.production,
);
```

---

## Best Practices

1. **Always use repositories** - Don't call NetworkManager directly from UI
2. **Handle errors gracefully** - Use `requestSafe<T>()` for better error handling
3. **Cache strategically** - Cache tokens, user data, and frequently accessed data
4. **Set auth headers** - Repositories handle this, but ensure it's always done
5. **Validate models** - Use null-safe factory constructors with defaults
6. **Test with mocks** - Mock network layer for unit tests
7. **Use route arguments** - Pass data strongly-typed through RouteArguments
8. **Initialize early** - Call `LocalDatabaseManager.initialize()` in main()
9. **Environment switching** - Use enums for easy env switching
10. **Clean up connections** - Call `dispose()` on NetworkService when needed

---

## Troubleshooting

### "Request failed: 401 Unauthorized"
**Solution:** Token expired. Call `refreshToken()` or `logout()`.

### "LocalDatabaseManager not initialized"
**Solution:** Call `LocalDatabaseManager.initialize()` before using it.

### "Authorization header not being sent"
**Solution:** Ensure `setAuthToken()` is called on NetworkManager after login.

### "JSON parsing fails"
**Solution:** Ensure your decoder function properly handles the response format.

### "Cached data is stale"
**Solution:** Set cache expiration times or clear cache when needed.

---

For more details, see the main [README.md](README.md) or explore the source code!
