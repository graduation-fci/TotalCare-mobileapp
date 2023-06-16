import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app_state.dart';

class Storage {
  static const storage = FlutterSecureStorage();
  static const accessTokenKey = 'token';
  static const refreshTokenKey = 'refresh';
  static const notificationsKey = 'itemList';
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
      refToken = await storage.read(key: refreshTokenKey);
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

  Future<void> saveItemList(Map<String, dynamic> item) async {
    final encodedList = await storage.read(key: notificationsKey);
    List<dynamic> itemList = [];

    if (encodedList != null) {
      itemList = jsonDecode(encodedList);
    }

    itemList.insert(0, item);
    if (itemList.length > 8) {
      itemList.removeAt(8);
    }
    final updatedList = jsonEncode(itemList);
    await storage.write(key: notificationsKey, value: updatedList);
  }

  Future<List<dynamic>> loadItemList() async {
    final encodedList = await storage.read(key: notificationsKey);
    if (encodedList != null) {
      final decodedList = jsonDecode(encodedList) as List<dynamic>;
      return decodedList;
    }
    return [];
  }
}
