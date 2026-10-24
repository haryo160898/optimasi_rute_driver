class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends ApiException {
  const NetworkException(super.message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException()
    : super('Sesi berakhir atau token tidak valid.', statusCode: 401);
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

class ValidationException extends ApiException {
  const ValidationException(super.message) : super(statusCode: 400);
}
