/// Represents a standardized error response from the backend API
class ApiError {
  final String code;
  final String message;
  final List<String>? details;
  final String? hint;

  ApiError({
    required this.code,
    required this.message,
    this.details,
    this.hint,
  });

  /// Factory constructor to parse JSON error response from backend
  factory ApiError.fromJson(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>?;
    
    if (error == null) {
      // Fallback for non-standard error responses
      return ApiError(
        code: 'UNKNOWN_ERROR',
        message: json['message'] ?? json['error'] ?? 'An unexpected error occurred',
      );
    }

    return ApiError(
      code: error['code'] ?? 'UNKNOWN_ERROR',
      message: error['message'] ?? 'An unexpected error occurred',
      details: error['details'] != null
          ? List<String>.from(error['details'] as List)
          : null,
      hint: error['hint'] as String?,
    );
  }

  /// Get formatted error message with optional details
  String getFormattedMessage() {
    final buffer = StringBuffer(message);
    
    if (details != null && details!.isNotEmpty) {
      buffer.writeln();
      for (final detail in details!) {
        buffer.writeln('• $detail');
      }
    }
    
    if (hint != null && hint!.isNotEmpty) {
      buffer.writeln();
      buffer.write('💡 Tip: $hint');
    }
    
    return buffer.toString();
  }

  /// Get a user-friendly error description
  String getUserMessage() {
    switch (code) {
      case 'PASSWORD_WEAK':
        return 'Password is too weak. Please ensure it has uppercase, lowercase, a number, and is at least 8 characters long.';
      case 'USER_EXISTS':
        return hint ?? 'This email or username is already registered.';
      case 'INVALID_PASSWORD':
      case 'INVALID_CREDENTIALS':
        return hint ?? 'Email or password is incorrect. Remember passwords are case-sensitive.';
      case 'MISSING_FIELDS':
        return 'Please fill in all required fields.';
      case 'SERVER_ERROR':
        return 'Server error. Please try again later.';
      case 'NOT_FOUND':
        return 'The requested resource was not found.';
      default:
        return message;
    }
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message, details: $details, hint: $hint)';
  }
}
