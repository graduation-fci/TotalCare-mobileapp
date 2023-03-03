import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:grad_login/infrastructure/exam/examService.dart';
import 'package:http/http.dart' as http;

import '../app_state.dart';
import '../models/exam.dart';
import '../my_config.dart';

class ExamProvider with ChangeNotifier {
  AppState appState = AppState.init;
  String? errorMessage;
  Map<String, dynamic>? response;
  ExamService examService = ExamService();
  int currentPage = 1;

  List<Exam> _exams = [];

  List<Exam> get exams {
    return [..._exams];
  }

  Future<void> getExams() async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await examService.getExams(currentPage);
    if (responseData!['detail'] != null) {
      errorMessage = responseData['detail'];
      // print(responseData['detail']);
      appState = AppState.error;
    } else {
      response = responseData;
      List<Exam> loadedData = [];
      for (var examData in responseData['results']) {
        loadedData.add(
          Exam(
            title: examData['title'],
            id: examData['id'],
            subject: examData['subject'],
            starts_at: examData['starts_at'],
            ends_at: examData['ends_at'],
          ),
        );
      }
      _exams = _exams + loadedData;
      currentPage += 1;
      log("$exams");
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
