import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/models/medication.dart';

import '../app_state.dart';
import '../infrastructure/user/user_service.dart';

class UserProvider with ChangeNotifier {
  UserService userService = UserService();
  String? errorMessage;
  Map<String, dynamic> userProfileData = {};
  AppState appState = AppState.init;
  final List _userMedications = [];
  final List<int> _medicationIds = [];

  List get userMedications {
    return [..._userMedications];
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
    // log('${med.medicineIds}');
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

  Future<void> editUserMedication(Medication med, int id) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await userService.editMedicationProfile(med, id);
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
    responseData['results']
        .map((element) => _medicationIds.contains(element['id'])
            ? null
            : _medicationIds.add(element['id']))
        .toList();
    log("$_medicationIds");
    if (_userMedications.isNotEmpty) {
      _userMedications
          .removeWhere((element) => _medicationIds.contains(element['id']));
    }
    _userMedications.addAll(responseData['results']);
    log("$userMedications");
    notifyListeners();
  }

  Future<void> delMedication(int id) async {
    appState = AppState.loading;
    notifyListeners();
    await userService.deleteMedication(id);
    _userMedications.removeWhere((element) => element['id'] == id);
    appState = AppState.done;
    notifyListeners();
  }
}
