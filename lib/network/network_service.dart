import 'dart:convert';
import 'package:http/http.dart' as http;
import 'network_service_protocol.dart';

/// HTTP-based implementation of NetworkServiceProtocol
///
/// Uses the http package to make actual network requests
/// Provides URI building, timeout handling, and response parsing
class NetworkService implements NetworkServiceProtocol {
  @override
  final String baseUrl;

  /// Map of default headers for all requests
  Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// HTTP client instance
  final http.Client _httpClient;

  NetworkService({required this.baseUrl, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  @override
  Future<NetworkResponse> request({
    required String method,
    required String path,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      // Build URI
      final uri = _buildUri(path, params);

      // Merge headers
      final mergedHeaders = {..._defaultHeaders, ...?headers};

      // Execute request
      final response = await _executeRequest(
        method: method,
        uri: uri,
        headers: mergedHeaders,
        data: data,
        timeout: timeout,
      );

      return response;
    } catch (e) {
      throw NetworkException(
        message: 'Network request failed: $e',
        originalError: e,
      );
    }
  }

  /// Build URI from path and query parameters
  Uri _buildUri(String path, Map<String, dynamic>? params) {
    late Uri uri;

    if (path.startsWith('http')) {
      // Full URL provided
      uri = Uri.parse(path);
    } else {
      // Relative path - use base URL
      uri = Uri.parse(baseUrl + path);
    }

    // Add query parameters if provided
    if (params != null && params.isNotEmpty) {
      uri = uri.replace(
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }

    return uri;
  }

  /// Execute HTTP request with appropriate method
  Future<NetworkResponse> _executeRequest({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    dynamic data,
    required Duration timeout,
  }) async {
    http.Response response;

    try {
      // Encode data to JSON if provided
      String? encodedData;
      if (data != null) {
        if (data is String) {
          encodedData = data;
        } else if (data is Map) {
          encodedData = jsonEncode(data);
        } else {
          encodedData = jsonEncode(data);
        }
      }

      // Execute request with timeout
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _httpClient
              .get(uri, headers: headers)
              .timeout(timeout);
          break;

        case 'POST':
          response = await _httpClient
              .post(uri, headers: headers, body: encodedData)
              .timeout(timeout);
          break;

        case 'PUT':
          response = await _httpClient
              .put(uri, headers: headers, body: encodedData)
              .timeout(timeout);
          break;

        case 'DELETE':
          response = await _httpClient
              .delete(uri, headers: headers, body: encodedData)
              .timeout(timeout);
          break;

        case 'PATCH':
          response = await _httpClient
              .patch(uri, headers: headers, body: encodedData)
              .timeout(timeout);
          break;

        default:
          throw NetworkException(message: 'Unsupported HTTP method: $method');
      }

      // Parse response body
      dynamic parsedBody;
      try {
        if (response.body.isEmpty) {
          parsedBody = null;
        } else {
          parsedBody = jsonDecode(response.body);
        }
      } catch (e) {
        // If JSON parsing fails, return raw body
        parsedBody = response.body;
      }

      return NetworkResponse(
        statusCode: response.statusCode,
        body: parsedBody,
        headers: response.headers,
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'HTTP client error: ${e.message}',
        originalError: e,
      );
    }
  }

  @override
  void setHeaders(Map<String, String> headers) {
    _defaultHeaders = headers;
  }

  @override
  void addHeader(String key, String value) {
    _defaultHeaders[key] = value;
  }

  @override
  void removeHeader(String key) {
    _defaultHeaders.remove(key);
  }

  @override
  void clearHeaders() {
    _defaultHeaders.clear();
    // Restore default content-type headers
    _defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Close the HTTP client (cleanup)
  void dispose() {
    _httpClient.close();
  }
}
