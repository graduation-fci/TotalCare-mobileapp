import 'dart:developer';

import 'package:flutter/material.dart';

import '../infrastructure/auth/authService.dart';
import '../models/user.dart';
import '../app_state.dart';

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
      case 'email':
        errorMessage = responseData['email'][0];
        // log(responseData['email'][0]);
        appState = AppState.error;
        break;
      case 'username':
        errorMessage = responseData['username'][0];
        // log(responseData['username'][0]);
        appState = AppState.error;
        break;
      case 'password':
        errorMessage = responseData['password'][0];
        // log(responseData['password'][0]);
        appState = AppState.error;
        break;
      default:
        response = responseData;
        log('$response');
        appState = AppState.done;
        break;
    }
    notifyListeners();
  }

  Future<void> contRegister(User user) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await authService.continueRegistration(user);
    appState = AppState.done;
    notifyListeners();
  }

  Future<void> logout() {
    return authService.logout();
  }
}
