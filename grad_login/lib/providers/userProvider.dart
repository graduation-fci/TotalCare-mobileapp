import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/models/medication.dart';

import '../app_state.dart';
import '../infrastructure/user/user_service.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserService userService = UserService();
  String? errorMessage;
  Map<String, dynamic> userProfileData = {};
  Map<String, dynamic> userMedications = {};
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
    userProfileData = responseData;
    // log("$userProfileData");
    notifyListeners();
  }

  Future<void> addUserMedication(Medication med) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await userService.addMedicationProfile(med);
    if (responseData['detail'] != null) {
      errorMessage = responseData['detail'];
      appState = AppState.error;
    } else {
      appState = AppState.done;
    }
    log("$responseData");
    notifyListeners();
  }

  Future<void> getUserMedications() async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await userService.getMedications();
    if (responseData['detail'] != null) {
      errorMessage = responseData['detail'];
      appState = AppState.error;
    } else {
      appState = AppState.done;
    }
    userMedications = responseData;
    // log("$userMedications");
    notifyListeners();
  }

  Future<void> delMedication(int id) async {
    appState = AppState.loading;
    notifyListeners();
    await userService.deleteMedication(id);
    appState = AppState.done;
    notifyListeners();
  }
}
