import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static final AppConfig instance = AppConfig._();

  String _baseUrl = 'https://mock.ipot.local';

  String get baseUrl => _baseUrl;

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // The project ships a checked-in .env, so falling back is enough here.
    }

    final configuredBaseUrl = dotenv.env['BASE_URL'];
    if (configuredBaseUrl != null && configuredBaseUrl.trim().isNotEmpty) {
      instance._baseUrl = configuredBaseUrl.trim();
    }
  }
}
