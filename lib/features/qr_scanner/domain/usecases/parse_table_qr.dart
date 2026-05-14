import '../../../../core/errors/exceptions.dart';

class ParseTableQr {
  static final RegExp _pattern = RegExp(r'^ipot:\/\/table\/([A-Za-z0-9_-]+)$');

  String call(String rawValue) {
    final normalized = rawValue.trim();
    final match = _pattern.firstMatch(normalized);
    if (match == null) {
      throw const InvalidQrException(
        'Invalid QR code. Scan a code in the format ipot://table/{tableId}.',
      );
    }

    return match.group(1)!;
  }
}
