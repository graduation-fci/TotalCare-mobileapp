import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/infrastructure/medicine/medicine_service.dart';
import 'package:grad_login/infrastructure/shared/storage.dart';

import '../app_state.dart';

class MedicineProvider with ChangeNotifier {
  AppState appState = AppState.init;
  Storage storage = Storage();
  String? errorMessage;
  Map<String, dynamic>? response;
  MedicineService medicineService = MedicineService();
  int currentPage = 1;
  String _notificationsEn = '';
  List<dynamic> _notificationsPermutations = [];
  int notificationsCounter = 0;

  List<dynamic> get notificationsPermutations {
    return [..._notificationsPermutations];
  }

  String get noticationsEn {
    return _notificationsEn;
  }

  Future<void> getMedicines() async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await medicineService.getSimpleMeds();
    if (responseData!['detail'] != null) {
      errorMessage = responseData['detail'];
      appState = AppState.error;
    } else {
      response = responseData;
      // log("$response");
      currentPage += 1;
      appState = AppState.done;
    }
    notifyListeners();
  }

  Future<void> getNotifications(int id) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await medicineService.getNotification(id);
    if (responseData!['notification'] == null) {
      return;
    }
    if (responseData['detail'] != null) {
      errorMessage = responseData['detail'];
      appState = AppState.error;
    } else {
      _notificationsEn = responseData['notification']['en'];
      _notificationsPermutations = responseData['permutations'];
      await storage.saveItemList(responseData);

      notificationsCounter++;
      appState = AppState.done;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getFilteredMedsData({searchQuery, ordering}) {
    return medicineService.filterSimpleMedsData(
        search: searchQuery, ordering: ordering);
  }

  Future<Map<String, dynamic>?> getFilteredCategories({searchQuery}) {
    return medicineService.filterCategories(search: searchQuery);
  }
}
