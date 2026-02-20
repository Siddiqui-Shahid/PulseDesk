import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Keys for local storage
enum LocalDbKey {
  authToken('auth_token'),
  refreshToken('refresh_token'),
  user('user'),
  userPreferences('user_preferences'),
  appSettings('app_settings'),
  lastSyncTime('last_sync_time'),
  cachedPosts('cached_posts');

  final String key;
  const LocalDbKey(this.key);
}

/// Local database manager
///
/// Wrapper around SharedPreferences for persistent storage
/// Follows singleton pattern from MediSeen
///
/// Handles:
/// - String values (tokens, settings)
/// - JSON serialization (objects, lists)
/// - Type-safe getters with defaults
/// - Cleanup methods
class LocalDatabaseManager {
  static final LocalDatabaseManager _instance =
      LocalDatabaseManager._internal();

  factory LocalDatabaseManager() {
    return _instance;
  }

  LocalDatabaseManager._internal();

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  ///
  /// Must be called once during app startup
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Check if initialized
  static bool get isInitialized => _prefs != null;

  /// Get SharedPreferences instance
  ///
  /// Throws if not initialized
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError(
        'LocalDatabaseManager not initialized. Call initialize() first.',
      );
    }
    return _prefs!;
  }

  // ==================== Auth Storage ====================

  /// Save auth token
  Future<bool> setAuthToken(String token) async {
    return prefs.setString(LocalDbKey.authToken.key, token);
  }

  /// Get auth token
  String? getAuthToken() {
    return prefs.getString(LocalDbKey.authToken.key);
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return getAuthToken() != null;
  }

  /// Save refresh token
  Future<bool> setRefreshToken(String token) async {
    return prefs.setString(LocalDbKey.refreshToken.key, token);
  }

  /// Get refresh token
  String? getRefreshToken() {
    return prefs.getString(LocalDbKey.refreshToken.key);
  }

  // ==================== User Storage ====================

  /// Save user as JSON string
  Future<bool> setUser(Map<String, dynamic> userJson) async {
    final jsonString = jsonEncode(userJson);
    return prefs.setString(LocalDbKey.user.key, jsonString);
  }

  /// Get user as JSON
  Map<String, dynamic>? getUser() {
    final userJson = prefs.getString(LocalDbKey.user.key);
    if (userJson == null) return null;

    try {
      return jsonDecode(userJson) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding user: $e');
      return null;
    }
  }

  /// Get specific user field
  dynamic getUserField(String field) {
    final user = getUser();
    return user?[field];
  }

  // ==================== Generic String Methods ====================

  /// Save string value
  Future<bool> setString(LocalDbKey key, String value) async {
    return prefs.setString(key.key, value);
  }

  /// Get string value
  String? getString(LocalDbKey key, {String? defaultValue}) {
    return prefs.getString(key.key) ?? defaultValue;
  }

  /// Save boolean value
  Future<bool> setBool(LocalDbKey key, bool value) async {
    return prefs.setBool(key.key, value);
  }

  /// Get boolean value
  bool getBool(LocalDbKey key, {bool defaultValue = false}) {
    return prefs.getBool(key.key) ?? defaultValue;
  }

  /// Save integer value
  Future<bool> setInt(LocalDbKey key, int value) async {
    return prefs.setInt(key.key, value);
  }

  /// Get integer value
  int getInt(LocalDbKey key, {int defaultValue = 0}) {
    return prefs.getInt(key.key) ?? defaultValue;
  }

  /// Save double value
  Future<bool> setDouble(LocalDbKey key, double value) async {
    return prefs.setDouble(key.key, value);
  }

  /// Get double value
  double getDouble(LocalDbKey key, {double defaultValue = 0.0}) {
    return prefs.getDouble(key.key) ?? defaultValue;
  }

  // ==================== JSON Methods ====================

  /// Save JSON object
  Future<bool> setJson(LocalDbKey key, Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);
    return prefs.setString(key.key, jsonString);
  }

  /// Get JSON object
  Map<String, dynamic>? getJson(LocalDbKey key) {
    final jsonString = prefs.getString(key.key);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding JSON for key ${key.key}: $e');
      return null;
    }
  }

  /// Save JSON list
  Future<bool> setJsonList(LocalDbKey key, List<dynamic> list) async {
    final jsonString = jsonEncode(list);
    return prefs.setString(key.key, jsonString);
  }

  /// Get JSON list
  List<dynamic>? getJsonList(LocalDbKey key) {
    final jsonString = prefs.getString(key.key);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (e) {
      print('Error decoding JSON list for key ${key.key}: $e');
      return null;
    }
  }

  // ==================== Cleanup Methods ====================

  /// Remove specific key
  Future<bool> remove(LocalDbKey key) async {
    return prefs.remove(key.key);
  }

  /// Remove multiple keys
  Future<bool> removeMultiple(List<LocalDbKey> keys) async {
    for (final key in keys) {
      await prefs.remove(key.key);
    }
    return true;
  }

  /// Clear auth-related data
  Future<bool> clearAuth() async {
    return removeMultiple([
      LocalDbKey.authToken,
      LocalDbKey.refreshToken,
      LocalDbKey.user,
    ]);
  }

  /// Clear all data
  Future<bool> clearAll() async {
    return prefs.clear();
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return prefs.getKeys();
  }

  /// Check if key exists
  bool hasKey(LocalDbKey key) {
    return prefs.containsKey(key.key);
  }

  // ==================== Debug Methods ====================

  /// Print all stored data (for debugging)
  void printAllData() {
    print('=== LocalDatabase Content ===');
    for (final key in prefs.getKeys()) {
      final value = prefs.get(key);
      print('$key: $value');
    }
    print('=============================');
  }

  /// Get total stored size (approximate)
  int getApproximateSize() {
    int size = 0;
    for (final key in prefs.getKeys()) {
      final value = prefs.get(key);
      if (value is String) {
        size += value.length;
      } else {
        size += value.toString().length;
      }
    }
    return size;
  }
}
