import '../network/network_manager.dart';
import '../network/network_routes.dart';
import '../network/network_service_protocol.dart';
import '../models/api_models.dart';
import '../database/local_database_manager.dart';

/// Repository for authentication operations
///
/// Sits between UI and network layer
/// Handles:
/// - Network requests via NetworkManager
/// - Local caching via LocalDatabaseManager
/// - Business logic (token management, etc.)
class AuthRepository {
  final NetworkManager _networkManager;
  final LocalDatabaseManager _localDb;

  AuthRepository({
    required NetworkManager networkManager,
    required LocalDatabaseManager localDb,
  }) : _networkManager = networkManager,
       _localDb = localDb;

  /// Login with email and password
  ///
  /// Returns:
  /// - [AuthResponse] with token and user data on success
  /// - Throws [NetworkException] on failure
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final loginRequest = LoginRequest(email: email, password: password);

    final response = await _networkManager.post<AuthResponse>(
      endpoint: NetworkEndpoint.login,
      data: loginRequest.toJson(),
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          return AuthResponse.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );

    if (response != null) {
      // Cache tokens and user
      await _localDb.setAuthToken(response.token);
      await _localDb.setRefreshToken(response.refreshToken);
      await _localDb.setUser(response.user.toJson());

      // Set auth header for future requests
      _networkManager.setAuthToken(response.token);

      return response;
    }

    throw Exception('Login failed');
  }

  /// Sign up new user
  Future<User> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    final signupData = {
      'email': email,
      'username': username,
      'password': password,
    };

    final response = await _networkManager.post<User>(
      endpoint: NetworkEndpoint.signup,
      data: signupData,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          return User.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );

    if (response != null) {
      return response;
    }
    throw Exception('Signup failed');
  }

  /// Refresh authentication token
  Future<AuthResponse> refreshToken() async {
    final currentRefreshToken = _localDb.getRefreshToken();

    if (currentRefreshToken == null) {
      throw Exception('No refresh token available');
    }

    final refreshData = {'refreshToken': currentRefreshToken};

    final response = await _networkManager.post<AuthResponse>(
      endpoint: NetworkEndpoint.refresh,
      data: refreshData,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          return AuthResponse.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );

    if (response != null) {
      // Update cached tokens
      await _localDb.setAuthToken(response.token);
      await _localDb.setRefreshToken(response.refreshToken);
      _networkManager.setAuthToken(response.token);

      return response;
    }

    throw Exception('Token refresh failed');
  }

  /// Logout user
  Future<void> logout() async {
    // Clear local cache
    await _localDb.clearAuth();

    // Clear auth header
    _networkManager.clearAuthToken();
  }

  /// Check if user is authenticated
  bool isAuthenticated() => _localDb.isAuthenticated();

  /// Get cached user
  User? getCachedUser() {
    final userJson = _localDb.getUser();
    if (userJson != null) {
      return User.fromJson(userJson);
    }
    return null;
  }

  /// Get cached auth token
  String? getCachedToken() => _localDb.getAuthToken();
}

/// Repository for user operations
class UserRepository {
  final NetworkManager _networkManager;
  final LocalDatabaseManager _localDb;

  UserRepository({
    required NetworkManager networkManager,
    required LocalDatabaseManager localDb,
  }) : _networkManager = networkManager,
       _localDb = localDb;

  /// Get current user profile
  Future<User> getProfile() async {
    final response = await _networkManager.get<User>(
      endpoint: NetworkEndpoint.profile,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          return User.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );

    if (response != null) {
      await _localDb.setUser(response.toJson());
      return response;
    }
    throw Exception('Failed to fetch profile');
  }

  /// Update user profile
  Future<User> updateProfile({required String name, String? phone}) async {
    final updateData = {'name': name, if (phone != null) 'phone': phone};

    final response = await _networkManager.put<User>(
      endpoint: NetworkEndpoint.updateProfile,
      data: updateData,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          return User.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );

    if (response != null) {
      await _localDb.setUser(response.toJson());
      return response;
    }

    throw Exception('Failed to update profile');
  }

  /// Get user by ID
  Future<User> getUserById(int userId) async {
    final response = await _networkManager.get<User>(
      endpoint: NetworkEndpoint.user,
      params: {'id': userId},
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          return User.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );

    if (response != null) {
      return response;
    }
    throw Exception('User not found');
  }
}

/// Repository for posts/content
class PostRepository {
  final NetworkManager _networkManager;
  final LocalDatabaseManager _localDb;

  PostRepository({
    required NetworkManager networkManager,
    required LocalDatabaseManager localDb,
  }) : _networkManager = networkManager,
       _localDb = localDb;

  /// Get paginated posts
  Future<PaginatedResponse<Post>> getPosts({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _networkManager.get<PaginatedResponse<Post>>(
      endpoint: NetworkEndpoint.posts,
      params: {'page': page, 'pageSize': pageSize},
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          return PaginatedResponse.fromJson(
            json,
            (item) => Post.fromJson(item as Map<String, dynamic>),
          );
        }
        throw Exception('Invalid response format');
      },
    );

    if (response != null) {
      return response;
    }
    throw Exception('Failed to fetch posts');
  }

  /// Cache posts locally
  Future<bool> cachePost(Post post) async {
    final posts = getCachedPosts();
    posts.add(post.toJson());
    return _localDb.setJsonList(LocalDbKey.cachedPosts, posts);
  }

  /// Get cached posts
  List<Map<String, dynamic>> getCachedPosts() {
    final cached = _localDb.getJsonList(LocalDbKey.cachedPosts);
    return cached?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Clear post cache
  Future<bool> clearPostCache() async {
    return _localDb.remove(LocalDbKey.cachedPosts);
  }
}

/// Repository for comments
class CommentRepository {
  final NetworkManager networkManager;

  CommentRepository({required this.networkManager});

  /// Get comments (implement as needed)
  // Future<List<Comment>> getComments(int postId) async { ... }
}

/// Locator/Service Locator Pattern
///
/// Centralizes repository access throughout the app
class RepositoryLocator {
  static late AuthRepository _authRepo;
  static late UserRepository _userRepo;
  static late PostRepository _postRepo;
  static late CommentRepository _commentRepo;

  /// Initialize all repositories
  static void setup({
    required NetworkManager networkManager,
    required LocalDatabaseManager localDb,
  }) {
    _authRepo = AuthRepository(
      networkManager: networkManager,
      localDb: localDb,
    );
    _userRepo = UserRepository(
      networkManager: networkManager,
      localDb: localDb,
    );
    _postRepo = PostRepository(
      networkManager: networkManager,
      localDb: localDb,
    );
    _commentRepo = CommentRepository(networkManager: networkManager);
  }

  static AuthRepository get auth => _authRepo;
  static UserRepository get user => _userRepo;
  static PostRepository get post => _postRepo;
  static CommentRepository get comment => _commentRepo;
}
