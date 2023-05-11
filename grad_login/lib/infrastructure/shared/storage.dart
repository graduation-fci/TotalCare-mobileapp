import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app_state.dart';

class Storage {
  static const storage = FlutterSecureStorage();
  static const accessTokenKey = 'token';
  static const refreshTokenKey = 'ref-token';
  String? refToken;

  Future<AppState> setAccessToken(String value) async {
    try {
      await storage.write(key: accessTokenKey, value: value);
      return AppState.done;
    } catch (_) {
      return AppState.error;
    }
  }

  Future<AppState> setRefreshToken(String value) async {
    try {
      await storage.write(key: refreshTokenKey, value: value);
      return AppState.done;
    } catch (_) {
      return AppState.error;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: accessTokenKey);
  }

  Future<void> removeToken() async {
    await storage.delete(key: accessTokenKey);
  }

  Future<void> refreshToken() async {
    await storage.read(key: accessTokenKey);
    storage.delete(key: accessTokenKey);
    refToken = await storage.read(key: refreshTokenKey);
    print(refToken);
  }
}
