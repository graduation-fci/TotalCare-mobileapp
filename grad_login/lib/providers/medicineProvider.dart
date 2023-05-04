import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/infrastructure/medicine/medicine_service.dart';

import '../app_state.dart';

class MedicineProvider with ChangeNotifier {
  AppState appState = AppState.init;
  String? errorMessage;
  Map<String, dynamic>? response;
  MedicineService medicineService = MedicineService();
  int currentPage = 1;

  Future<void> getMedicines() async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await medicineService.getSimpleMeds();
    if (responseData!['detail'] != null) {
      errorMessage = responseData['detail'];
      appState = AppState.error;
    } else {
      response = responseData;
      log("$response");
      currentPage += 1;
      appState = AppState.done;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getFilteredMedsData({searchQuery, ordering}) {
    return medicineService.filterSimpleMedsData(
        search: searchQuery, ordering: ordering);
  }
}
