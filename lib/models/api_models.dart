/// API Response Models with JSON serialization
///
/// Follows the MediSeen pattern of factory constructors + toJson()
/// Handles null-safety with default values

/// Generic API Response wrapper
///
/// Most APIs return this structure:
/// ```json
/// {
///   "status": "success",
///   "message": "Operation successful",
///   "data": {...},
///   "timestamp": "2024-01-15T10:30:00Z"
/// }
/// ```
class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final String timestamp;

  const ApiResponse({
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
  });

  /// Check if response was successful
  bool get isSuccess => status.toLowerCase() == 'success';

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataDecoder,
  ) {
    return ApiResponse(
      status: json['status'] ?? 'unknown',
      message: json['message'] ?? '',
      data: json['data'] != null ? dataDecoder?.call(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() =>
      'ApiResponse(status: $status, message: $message, data: $data)';
}

/// User model for authentication and profile
class User {
  final int id;
  final String email;
  final String username;
  final String? name;
  final String? profileImage;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.name,
    this.profileImage,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      name: json['name'],
      profileImage: json['profileImage'],
      phone: json['phone'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'profileImage': profileImage,
      'phone': phone,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'User(id: $id, email: $email, username: $username)';
}

/// Login request model
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

/// Authentication response with token
class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;
  final DateTime expiresAt;

  const AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : _emptyUser(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user.toJson(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  bool get isTokenExpired => DateTime.now().isAfter(expiresAt);

  @override
  String toString() => 'AuthResponse(token: $token, user: $user)';

  static User _emptyUser() {
    return const User(id: 0, email: '', username: '');
  }
}

/// Post/Article model
class Post {
  final int id;
  final String title;
  final String content;
  final User author;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] != null
          ? User.fromJson(json['author'])
          : _emptyAuthor(),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author.toJson(),
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static User _emptyAuthor() {
    return const User(id: 0, email: '', username: 'Unknown');
  }
}

/// Paginated response model
class PaginatedResponse<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? itemDecoder,
  ) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final decodedItems = itemsList
        .map((item) => itemDecoder?.call(item))
        .whereType<T>()
        .toList();

    return PaginatedResponse(
      items: decodedItems,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'page': page,
      'pageSize': pageSize,
      'total': total,
      'totalPages': totalPages,
    };
  }
}

/// Generic error response
class ErrorResponse {
  final String message;
  final String? code;
  final Map<String, dynamic>? errors;
  final int statusCode;

  const ErrorResponse({
    required this.message,
    this.code,
    this.errors,
    this.statusCode = 500,
  });

  factory ErrorResponse.fromJson(
    Map<String, dynamic> json, {
    int statusCode = 500,
  }) {
    return ErrorResponse(
      message: json['message'] ?? 'An error occurred',
      code: json['code'],
      errors: json['errors'],
      statusCode: statusCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'errors': errors,
      'statusCode': statusCode,
    };
  }

  @override
  String toString() => 'ErrorResponse(message: $message, code: $code)';
}
