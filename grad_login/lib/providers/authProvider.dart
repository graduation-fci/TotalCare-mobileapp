import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_login/app_state.dart';
import 'package:grad_login/infrastructure/auth/authService.dart';

import '../models/user.dart';
import '../models/exam.dart';

class AuthProvider with ChangeNotifier {
  bool isRegister = false;
  AppState appState = AppState.init;
  AuthService authService = AuthService();
  String? errorMessage;
  Map<String, dynamic>? response;

  Future<void> login(
      {required String username, required String password}) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await authService.login(username, password);
    if (responseData!['detail'] != null) {
      errorMessage = responseData['detail'];
      // print(responseData['detail']);
      appState = AppState.error;
    } else {
      response = responseData;
      // log('$response');
      appState = AppState.done;
    }
    notifyListeners();
  }

  Future<void> register(User user) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await authService.register(user);
    switch (responseData!.keys.first) {
      case 'username':
        errorMessage = responseData['username'][0];
        log(responseData['username'][0]);
        appState = AppState.error;
        break;
      case 'password':
        errorMessage = responseData['password'][0];
        log(responseData['password'][0]);
        appState = AppState.error;
        break;
      default:
        response = responseData;
        log('$response');
        appState = AppState.done;
        break;
      // handle other cases if necessary
    }
    // if (responseData!['username'] != null) {
    //   errorMessage = responseData['username'][0];
    //   log(responseData['username'][0]);
    //   appState = AppState.error;
    // } else {
    //   response = responseData;
    //   log('$response');
    //   appState = AppState.done;
    // }
    notifyListeners();
  }

  // Future<void> loginWithJwt(jwt) async {
  //   await storage.write(key: tokenKey, value: jwt);
  //   print(await storage.read(key: tokenKey));
  // }

  // Future<dynamic> getCurrentUser() async {
  //   final jwt = await storage.read(key: tokenKey);
  //   return json.decode(jwt!);
  // }

  Future<void> logout() {
    return authService.logout();
  }

  // Future<void> refreshJwt() async {
  //   try {
  //     const dynamic apiEndPoint = Config.apiUrl;
  //     final refreshEndPoint = Uri.parse(apiEndPoint + '/auth/jwt/refresh/');

  //     print(await storage.read(key: tokenKey));
  //     storage.delete(key: tokenKey);
  //     String? refToken = await storage.read(key: 'refresh');
  //     print(refToken);

  //     //problem: not sending request to server!
  //     final response = await http.post(
  //       refreshEndPoint,
  //       headers: {
  //         "content-type": "application/json",
  //         "accept": "application/json",
  //       },
  //       body: json.encode(
  //         {'refresh', refToken},
  //       ),
  //     );
  //     print(refToken);

  //     final responseData = json.decode(response.body);
  //     print(responseData['access']);
  //   } catch (error) {}
  // }
}
