import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:grad_login/infrastructure/medicine/medicine_service.dart';
import 'package:http/http.dart' as http;

import '../app_state.dart';
import '../models/exam.dart';
import '../my_config.dart';

class MedicineProvider with ChangeNotifier {
  AppState appState = AppState.init;
  String? errorMessage;
  Map<String, dynamic>? response;
  MedicineService medicineService = MedicineService();
  int currentPage = 1;

  List<Exam> _exams = [];

  List<Exam> get exams {
    return [..._exams];
  }

  Future<void> getMedicines() async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await medicineService.getSimpleMeds();
    if (responseData!['detail'] != null) {
      errorMessage = responseData['detail'];
      // print(responseData['detail']);
      appState = AppState.error;
    } else {
      response = responseData;
      List<Exam> loadedData = [];
      // for (var medicineData in responseData['results']) {
      //   loadedData.add(
      //     Exam(
      //       title: medicineData['title'],
      //       id: medicineData['id'],
      //       subject: medicineData['subject'],
      //       startsAt: medicineData['starts_at'],
      //       endsAt: medicineData['ends_at'],
      //     ),
      //   );
      // }
      log("$response");
      _exams = _exams + loadedData;
      currentPage += 1;
      // log('$response');
      appState = AppState.done;
    }
    notifyListeners();
  }

  Future<void> getSingleExam() async {
    const dynamic apiEndPoint = Config.apiUrl;
    final examsEndPoint = Uri.parse(apiEndPoint + '/exam/exams/');

    await http.get(examsEndPoint);
  }
}
