import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grad_login/app_state.dart';

class Storage {
  static const storage = FlutterSecureStorage();
  static const tokenKey = 'token';
  String? token;

  Future<AppState> setToken(String value) async {
    try {
      await storage.write(key: tokenKey, value: value);
      return AppState.done;
    } catch (_) {
      return AppState.error;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: tokenKey).then((value) => token = value);
  }
}
