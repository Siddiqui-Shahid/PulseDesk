/// Network service protocol and models
///
/// Following interface-based design for mockable testing

/// Response model from network requests
class NetworkResponse {
  final int statusCode;
  final dynamic body;
  final Map<String, String> headers;
  final String? errorMessage;

  const NetworkResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
    this.errorMessage,
  });

  /// Check if response was successful (2xx status code)
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Check if response has client error (4xx status code)
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Check if response has server error (5xx status code)
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  @override
  String toString() =>
      'NetworkResponse(status: $statusCode, body: $body, error: $errorMessage)';
}

/// Abstract protocol for network service implementations
///
/// Allows for easy mocking and testing
abstract class NetworkServiceProtocol {
  /// Execute a network request
  ///
  /// Parameters:
  /// - [method]: HTTP method (GET, POST, etc.)
  /// - [path]: Full URL path
  /// - [params]: Query parameters
  /// - [data]: Request body data
  /// - [headers]: Custom headers to add
  /// - [timeout]: Request timeout duration
  ///
  /// Returns:
  /// - [NetworkResponse] with status, body, and headers
  ///
  /// Throws:
  /// - [Exception] on network errors
  Future<NetworkResponse> request({
    required String method,
    required String path,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  });

  /// Get the base URL for the service
  String get baseUrl;

  /// Set new headers for the service
  void setHeaders(Map<String, String> headers);

  /// Add a single header
  void addHeader(String key, String value);

  /// Remove a header
  void removeHeader(String key);

  /// Clear all custom headers
  void clearHeaders();
}

/// Exception thrown for network errors
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  NetworkException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode)';
}

/// Exception thrown for request timeouts
class NetworkTimeoutException implements Exception {
  final String message;
  final Duration timeout;

  NetworkTimeoutException({required this.message, required this.timeout});

  @override
  String toString() => 'NetworkTimeoutException: $message (Timeout: $timeout)';
}

/// Result wrapper for network operations
///
/// Similar to Rust Result type - holds either success data or error
class NetworkResult<T> {
  final T? data;
  final String? error;
  final int? statusCode;
  final bool isSuccess;

  const NetworkResult._({
    required this.isSuccess,
    this.data,
    this.error,
    this.statusCode,
  });

  /// Create a successful result
  factory NetworkResult.success(T data) {
    return NetworkResult._(isSuccess: true, data: data);
  }

  /// Create a failed result
  factory NetworkResult.error({required String error, int? statusCode}) {
    return NetworkResult._(
      isSuccess: false,
      error: error,
      statusCode: statusCode,
    );
  }

  @override
  String toString() =>
      'NetworkResult(success: $isSuccess, data: $data, error: $error, status: $statusCode)';
}
