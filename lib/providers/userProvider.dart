import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../infrastructure/user/user_service.dart';
import '../models/medication.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserService userService = UserService();
  String? errorMessage;
  Map<String, dynamic> jwtUserData = {};
  Map<String, dynamic> userPatientData = {};
  Map<String, dynamic> userProfileData = {};
  AppState appState = AppState.init;
  final List _userMedications = [];
  final List<int> _medicationIds = [];
  String _userImage = '';
  int? _imageId;

  List get userMedications {
    return [..._userMedications];
  }

  String get userImage {
    return _userImage;
  }

  int? get imageId {
    return _imageId;
  }

  Future<void> getUserData() async {
    appState = AppState.loading;
    notifyListeners();
    final patientData = await userService.getPatientData();
    final userData = await userService.getUserData();
    userPatientData = patientData;
    userProfileData = userData;
    if (patientData['image'] != null) {
      _userImage = userPatientData['image']['image'];
      _imageId = userPatientData['image']['id'];
    }
    // log(patientData.toString());
    appState = AppState.done;
    notifyListeners();
  }

  Future<void> editPatientData(User userDate) async {
    appState = AppState.loading;
    notifyListeners();
    final patientData = await userService.editPatientData(userDate);
    userPatientData = patientData;
    if (patientData['image'] != null) {
      _userImage = userPatientData['image']['image'];
      _imageId = userPatientData['image']['id'];
    }
    log(userPatientData.toString());
    appState = AppState.done;

    notifyListeners();
  }

  Future<void> editUserData(User userDate) async {
    appState = AppState.loading;
    notifyListeners();
    final userData = await userService.editUserData(userDate);
    userProfileData = userData;
    log(userProfileData.toString());
    appState = AppState.done;

    notifyListeners();
  }

  Future<void> uploadProfileImage(File userImage) async {
    appState = AppState.loading;
    notifyListeners();
    log(_imageId.toString());
    final responseData = await userService.uploadProfileImage(userImage);
    _imageId = responseData['id'];
    log(responseData.toString());

    notifyListeners();
  }

  Future<void> addUserImage(int id) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await userService.addUserImage(id);
    _imageId = responseData['image_file'];
    getUserData();
  }

  Future<void> deleteUserImage(int id) async {
    appState = AppState.loading;
    notifyListeners();
    await userService.deleteUserImage(id);
    _imageId = null;
    _userImage = '';
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
    // log("$responseData");
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
      responseData['results']
          .map((element) => _medicationIds.contains(element['id'])
              ? null
              : _medicationIds.add(element['id']))
          .toList();
      if (_userMedications.isNotEmpty) {
        _userMedications
            .removeWhere((element) => _medicationIds.contains(element['id']));
      }
      _userMedications.addAll(responseData['results']);
      appState = AppState.done;
    }
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
