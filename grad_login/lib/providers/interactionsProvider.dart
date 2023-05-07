import 'dart:developer';
import 'package:flutter/cupertino.dart';

import '../infrastructure/medicine/interactions_service.dart';

import '../app_state.dart';

class InteractionsProvider with ChangeNotifier {
  AppState appState = AppState.init;
  String? errorMessage;
  InteractionsService interactionsService = InteractionsService();
  int currentPage = 1;
  List _response = [];

  List get response {
    return [..._response];
  }

  Future<void> getInteractions(
      List<Map<String, dynamic>> interactionMeds) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData =
        await interactionsService.medicineInteraction(interactionMeds);
    if (!responseData.containsKey('errorMsg')) {
      _response = responseData['permutations'];
      appState = AppState.done;
    } else {
      errorMessage = responseData['errorMsg'];
      appState = AppState.error;
    }
    // log("$_response");
    notifyListeners();
  }
}
