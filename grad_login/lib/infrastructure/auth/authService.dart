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
    storage.setAccessToken(responseData['access']);
    storage.setRefreshToken(responseData['refresh']);
    log('${responseData['access']}');
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
          'first_name': user.first_name,
          'last_name': user.last_name,
          'profile_type': user.profileType,
        },
      ),
    );
    final responseData = json.decode(response.body);
    log('$responseData');
    switch (responseData.keys.first) {
      case 'username':
        return responseData;
      case 'password':
        return responseData;
      default:
        return responseData;
      // handle other cases if necessary
    }
  }

  Future<void> refreshJwt() async {
    final refreshEndPoint = Uri.parse(Config.refreshJWT);

    //problem: not sending request to server!
    final response = await http.post(
      refreshEndPoint,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: json.encode(
        {'refresh', storage.refToken},
      ),
    );

    final responseData = json.decode(response.body);
    print(responseData['access']);
  }

  Future<void> logout() async {
    await storage.removeToken();
  }
}
