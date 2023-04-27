import 'dart:developer';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../infrastructure/user/user_service.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserService userService = UserService();
  String? errorMessage;
  Map<String, dynamic>? response;
  AppState appState = AppState.init;
  final List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> getUserProfile() async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await userService.getMyProfile();
    if (responseData['detail'] != null) {
      errorMessage = responseData['detail'];
      appState = AppState.error;
    } else {
      appState = AppState.done;
    }
    response = responseData;
    log("$response");
    notifyListeners();
  }
}
