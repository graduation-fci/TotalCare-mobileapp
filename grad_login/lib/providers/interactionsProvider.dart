import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../infrastructure/medicine/interactions_service.dart';
import '../models/drug.dart';
import '../models/simple_medicine.dart';

import '../app_state.dart';
import '../models/exam.dart';
import '../my_config.dart';

class InteractionsProvider with ChangeNotifier {
  AppState appState = AppState.init;
  String? errorMessage;
  InteractionsService interactionsService = InteractionsService();
  int currentPage = 1;
  Map<String, dynamic> _response = {};

  Map<String, dynamic> get response {
    return {..._response};
  }

  Future<void> getInteractions(
      List<Map<String, dynamic>> interactionMeds) async {
    // log('$interactionMeds');
    appState = AppState.loading;
    notifyListeners();
    final responseData =
        await interactionsService.medicineInteraction(interactionMeds);
    if (responseData['results'] == null) {
      errorMessage = responseData['results'];
      appState = AppState.error;
    } else {
      appState = AppState.done;
    }
    _response = responseData['permutations'][0];
    log("$_response");
    // log("$response");
    notifyListeners();
  }
}
