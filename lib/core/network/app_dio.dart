import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/app_config.dart';

class AppDio {
  const AppDio(this._config);

  final AppConfig _config;

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _config.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: false),
      );
    }

    return dio;
  }
}
