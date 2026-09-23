enum AppErrorCode {
  network,
  timeout,
  unauthorized,
  validation,
  invalidImage,
  noResults,
  rateLimit,
  server,
  unavailable,
  unknown,
}

class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.statusCode,
  });

  final AppErrorCode code;
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
