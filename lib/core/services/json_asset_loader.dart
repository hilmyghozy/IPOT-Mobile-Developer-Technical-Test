import 'dart:convert';

import 'package:flutter/services.dart';

import '../errors/exceptions.dart';

class JsonAssetLoader {
  const JsonAssetLoader();

  Future<Map<String, dynamic>> loadObject(String path) async {
    try {
      final rawJson = await rootBundle.loadString(path);
      final decoded = jsonDecode(rawJson);
      return Map<String, dynamic>.from(decoded as Map);
    } catch (_) {
      throw AssetDataException('Unable to load mock data from $path.');
    }
  }
}
