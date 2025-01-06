import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  // Write data to secure storage
  static putString(String key, String? value) async {
    try {
      final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
      await storage.write(key: key, value: value);
    } catch (e) {
      print(e.toString());
    }
  }

  // Read data from secure storage
  static Future<String?> getString(String key) async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    final token = await storage.read(key: key);
    return token;
  }

  // Save a map to secure storage
  static putMap(String key, Map<String, dynamic>? map) async {
    final json = jsonEncode(map);
    await putString(key, json);
  }

  // Read a map from secure storage
  static Future<Map<String, dynamic>?> getMap(String key) async {
    final json = await getString(key);
    if (json != null) {
      return jsonDecode(json);
    }
    return null;
  }

  SecureStorageHelper._();
}
