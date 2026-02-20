import 'network_service_protocol.dart';
import 'network_service.dart';
import 'network_routes.dart';

/// High-level network coordinator
///
/// Sits between business logic and NetworkService
/// Handles:
/// - Request building with protocol, base, and endpoint
/// - Response parsing and generic typing
/// - Static headers application
/// - Error handling and formatting
class NetworkManager {
  /// Static headers applied to all requests
  static const Map<String, String> staticHeaders = {
    'App-Version': '1.0.0',
    'Platform': 'Flutter',
  };

  /// Underlying network service implementation
  final NetworkServiceProtocol _service;

  /// Current protocol (http/https)
  final NetworkProtocol protocol;

  /// Current base URL
  final NetworkBase base;

  NetworkManager({
    required NetworkServiceProtocol service,
    this.protocol = NetworkProtocol.https,
    this.base = NetworkBase.production,
  }) : _service = service;

  /// Factory constructor for convenience
  factory NetworkManager.create({
    String? baseUrl,
    NetworkProtocol protocol = NetworkProtocol.https,
    NetworkBase base = NetworkBase.production,
  }) {
    final url = baseUrl ?? '${protocol.value}://${base.value}';
    final service = NetworkService(baseUrl: url);
    return NetworkManager(service: service, protocol: protocol, base: base);
  }

  /// Execute a typed network request
  ///
  /// Generic parameter [T] specifies the response type
  ///
  /// Parameters:
  /// - [method]: HTTP method
  /// - [endpoint]: API endpoint
  /// - [params]: Query parameters
  /// - [data]: Request body
  /// - [headers]: Custom headers
  /// - [decoder]: Function to deserialize response body to type T
  ///
  /// Returns:
  /// - Deserialized response of type T
  /// - Null if no decoder provided
  ///
  /// Throws:
  /// - [NetworkException] on HTTP errors
  /// - [Exception] on deserialization errors
  Future<T?> request<T>({
    required HttpMethod method,
    required NetworkEndpoint endpoint,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, String>? headers,
    T Function(dynamic json)? decoder,
  }) async {
    final url = getNetworkUrl(protocol, base, endpoint);

    // Merge headers
    final mergedHeaders = {...staticHeaders, ...?headers};

    // Execute request
    final response = await _service.request(
      method: _httpMethodToString(method),
      path: url,
      params: params,
      data: data,
      headers: mergedHeaders,
    );

    // Handle errors
    if (!response.isSuccess) {
      throw NetworkException(
        message: 'API Error: ${response.errorMessage ?? 'Unknown error'}',
        statusCode: response.statusCode,
      );
    }

    // Decode response if decoder provided
    if (decoder != null && response.body != null) {
      return decoder(response.body);
    }

    return response.body as T?;
  }

  /// Execute a request and return NetworkResult<T>
  ///
  /// Wraps the response in a Result type for easier error handling
  ///
  /// Example:
  /// ```dart
  /// final result = await networkManager.requestSafe<User>(
  ///   method: HttpMethod.get,
  ///   endpoint: NetworkEndpoint.user,
  ///   decoder: (json) => User.fromJson(json),
  /// );
  ///
  /// if (result.isSuccess) {
  ///   final user = result.data;
  /// } else {
  ///   print(result.error);
  /// }
  /// ```
  Future<NetworkResult<T>> requestSafe<T>({
    required HttpMethod method,
    required NetworkEndpoint endpoint,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, String>? headers,
    T Function(dynamic json)? decoder,
  }) async {
    try {
      final result = await request<T>(
        method: method,
        endpoint: endpoint,
        params: params,
        data: data,
        headers: headers,
        decoder: decoder,
      );

      return NetworkResult.success(result as T);
    } on NetworkException catch (e) {
      return NetworkResult.error(error: e.message, statusCode: e.statusCode);
    } catch (e) {
      return NetworkResult.error(error: 'Unexpected error: $e');
    }
  }

  /// Convenience method for GET requests
  Future<T?> get<T>({
    required NetworkEndpoint endpoint,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    T Function(dynamic json)? decoder,
  }) {
    return request<T>(
      method: HttpMethod.get,
      endpoint: endpoint,
      params: params,
      headers: headers,
      decoder: decoder,
    );
  }

  /// Convenience method for POST requests
  Future<T?> post<T>({
    required NetworkEndpoint endpoint,
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    T Function(dynamic json)? decoder,
  }) {
    return request<T>(
      method: HttpMethod.post,
      endpoint: endpoint,
      params: params,
      data: data,
      headers: headers,
      decoder: decoder,
    );
  }

  /// Convenience method for PUT requests
  Future<T?> put<T>({
    required NetworkEndpoint endpoint,
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    T Function(dynamic json)? decoder,
  }) {
    return request<T>(
      method: HttpMethod.put,
      endpoint: endpoint,
      params: params,
      data: data,
      headers: headers,
      decoder: decoder,
    );
  }

  /// Convenience method for DELETE requests
  Future<T?> delete<T>({
    required NetworkEndpoint endpoint,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    T Function(dynamic json)? decoder,
  }) {
    return request<T>(
      method: HttpMethod.delete,
      endpoint: endpoint,
      params: params,
      headers: headers,
      decoder: decoder,
    );
  }

  /// Convenience method for PATCH requests
  Future<T?> patch<T>({
    required NetworkEndpoint endpoint,
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    T Function(dynamic json)? decoder,
  }) {
    return request<T>(
      method: HttpMethod.patch,
      endpoint: endpoint,
      params: params,
      data: data,
      headers: headers,
      decoder: decoder,
    );
  }

  /// Set authorization bearer token
  void setAuthToken(String token) {
    _service.addHeader('Authorization', 'Bearer $token');
  }

  /// Clear authorization header
  void clearAuthToken() {
    _service.removeHeader('Authorization');
  }

  /// Update custom header
  void setHeader(String key, String value) {
    _service.addHeader(key, value);
  }

  /// Remove custom header
  void removeHeader(String key) {
    _service.removeHeader(key);
  }

  /// Convert HttpMethod enum to string
  String _httpMethodToString(HttpMethod method) {
    return method.toString().split('.').last.toUpperCase();
  }

  /// Switch environment
  ///
  /// Example:
  /// ```dart
  /// networkManager.switchEnvironment(
  ///   protocol: NetworkProtocol.http,
  ///   base: NetworkBase.localhostDevice,
  /// );
  /// ```
  void switchEnvironment({NetworkProtocol? protocol, NetworkBase? base}) {
    // In a real app, you might update the service's base URL here
    print(
      '🔄 Switched to: ${protocol?.value ?? this.protocol.value}://${base?.value ?? this.base.value}',
    );
  }
}
