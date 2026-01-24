class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class NetworkException extends AppException {
  NetworkException([super.message = 'No internet connection'])
      : super(code: 'NETWORK_ERROR');
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException([super.message = 'Server error occurred', this.statusCode])
      : super(code: 'SERVER_ERROR');
}

class AuthException extends AppException {
  AuthException([super.message = 'Authentication failed'])
      : super(code: 'AUTH_ERROR');
}

class CacheException extends AppException {
  CacheException([super.message = 'Cache error'])
      : super(code: 'CACHE_ERROR');
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(super.message, {this.fieldErrors})
      : super(code: 'VALIDATION_ERROR');
}

class TimeoutException extends AppException {
  TimeoutException([super.message = 'Request timed out'])
      : super(code: 'TIMEOUT_ERROR');
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Resource not found'])
      : super(code: 'NOT_FOUND');
}
