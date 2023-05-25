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
    return responseData;
  }

  Future<Map<String, dynamic>?> continueRegistration(User user) async {
    final registerEndPoint = Uri.parse(Config.contRegister);
    Map<String, dynamic> body = {};
    if (user.birthDate != null) {
      body['birth_date'] = user.birthDate;
    }
    if (user.phoneNumber != null) {
      body['phone'] = user.phoneNumber;
    }
    if (user.bloodType != null) {
      body['bloodType'] = user.bloodType;
    }

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.patch(
      registerEndPoint,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": "JWT $token",
      },
      body: json.encode(body),
    );
    final responseData = json.decode(response.body);
    return responseData;
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
