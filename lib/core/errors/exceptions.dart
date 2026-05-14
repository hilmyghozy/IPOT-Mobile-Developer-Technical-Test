class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AssetDataException extends AppException {
  const AssetDataException(super.message);
}

class InvalidQrException extends AppException {
  const InvalidQrException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}
