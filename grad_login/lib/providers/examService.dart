import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/exam.dart';

class ExamService with ChangeNotifier {
  // Function examUrl(id) {
  //   return ''
  // }

  List<Exam> _exams = [];

  List<Exam> get exams {
    return [..._exams];
  }

  Future<void> getExams(BuildContext context) async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/my_config.json');
    final dynamic apiEndPoint = jsonDecode(jsonString)['apiUrl'];
    final examsEndPoint = Uri.parse(apiEndPoint + '/exam/exams/');
    final response = await http.get(examsEndPoint);
    final fetchedData =
        json.decode(response.body)['exam'] ;

    List<Exam> loadedData = [];
    if (fetchedData == null) return;
    fetchedData.forEach((id, examData) {
      loadedData.add(
        Exam(
          title: examData['title'],
          id: examData['id'],
          subject: examData['subject'],
          starts_at: examData['starts_at'],
          ends_at: examData['ends_at'],
        ),
      );
    });
    _exams = loadedData;
    notifyListeners();
  }

  Future<void> getSingleExam(BuildContext context) async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/my_config.json');
    final dynamic apiEndPoint = jsonDecode(jsonString)['apiUrl'];
    final examsEndPoint = Uri.parse(apiEndPoint + '/exam/exams/');

    await http.get(examsEndPoint);
  }
}
