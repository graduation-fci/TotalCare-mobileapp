import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:grad_login/my_config.dart';
import 'package:grad_login/models/user.dart';
import '../shared/storage.dart';

class AuthService {
  Storage storage = Storage();

  Future<Map<String, dynamic>?> login(
    String username,
    String password,
  ) async {
    // final loginEndPoint = getEndPoint(context, '/auth/jwt/create/');
    final loginEndPoint = Uri.parse(Config.login);

    final response = await http.post(
      loginEndPoint,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: json.encode(
        {'username': username, 'password': password},
      ),
    );

    final responseData = json.decode(response.body);
    if (responseData['detail'] != null) {
      return responseData;
    }
    storage.setToken(responseData['access']);
    return responseData;
  }

  Future<Map<String, dynamic>?> register(User user) async {
    final registerEndPoint = Uri.parse(Config.register);

    final response = await http.post(
      registerEndPoint,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: json.encode(
        {
          'username': user.username,
          'password': user.password,
          'email': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'profile_type': user.profile_type,
          // 'birthdate': user.birthdate,
        },
      ),
    );
    final responseData = json.decode(response.body);
    if (responseData['detail'] != null) {
      return responseData;
    }
    return responseData;
  }

  Future<void> logout() async {
    await storage.removeToken();
  }
}
