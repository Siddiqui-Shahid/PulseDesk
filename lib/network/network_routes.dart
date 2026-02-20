/// Enums for network configuration
///
/// Follows the MediSeen pattern for flexible environment switching
/// without needing code changes

/// Network protocol enumeration
enum NetworkProtocol { http, https }

/// Base URLs for different environments
enum NetworkBase {
  production,
  staging,
  localhostSimulator, // For Android emulator
  localhostDevice, // For physical device
}

/// API endpoints
enum NetworkEndpoint {
  // Example endpoints
  login('/auth/login'),
  signup('/auth/signup'),
  refresh('/auth/refresh'),
  user('/user'),
  profile('/user/profile'),
  updateProfile('/user/profile'),
  posts('/posts'),
  comments('/comments'),
  health('/health');

  final String path;
  const NetworkEndpoint(this.path);
}

/// Extension on NetworkProtocol to get string value
extension NetworkProtocolExt on NetworkProtocol {
  String get value => this == NetworkProtocol.http ? 'http' : 'https';
}

/// Extension on NetworkBase to get URL string
///
/// Allows easy switching between environments
extension NetworkBaseExt on NetworkBase {
  String get value {
    switch (this) {
      case NetworkBase.production:
        return 'api.pulsedesk.com';
      case NetworkBase.staging:
        return 'staging-api.pulsedesk.com';
      case NetworkBase.localhostSimulator:
        // Android emulator uses 10.0.2.2 to access host machine
        return '10.0.2.2:3000';
      case NetworkBase.localhostDevice:
        // Physical device needs the actual machine IP
        return '192.168.0.105:3000';
    }
  }
}

/// Extension on NetworkEndpoint to get path string
extension NetworkEndpointExt on NetworkEndpoint {
  String get value => path;
}

/// HTTP method enumeration
enum HttpMethod { get, post, put, delete, patch }

/// Helper function to construct complete deep links
///
/// Example:
/// ```dart
/// final url = getNetworkUrl(
///   NetworkProtocol.https,
///   NetworkBase.production,
///   NetworkEndpoint.login,
/// );
/// // Result: https://api.pulsedesk.com/auth/login
/// ```
String getNetworkUrl(
  NetworkProtocol protocol,
  NetworkBase base,
  NetworkEndpoint endpoint,
) {
  return '${protocol.value}://${base.value}${endpoint.path}';
}
