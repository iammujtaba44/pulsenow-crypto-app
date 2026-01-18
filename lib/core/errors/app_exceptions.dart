class AppException implements Exception {
  final String message;
  final String? details;

  const AppException(this.message, {this.details});

  @override
  String toString() => details == null ? message : '$message ($details)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.details});
}

class ApiException extends AppException {
  final int? statusCode;

  const ApiException(super.message, {this.statusCode, super.details});
}

class CacheException extends AppException {
  const CacheException(super.message, {super.details});
}
