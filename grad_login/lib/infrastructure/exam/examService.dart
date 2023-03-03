import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/exam.dart';
import '../../my_config.dart';
import '../shared/storage.dart';

class ExamService {
  List<Exam> _exams = [];

  List<Exam> get exams {
    return [..._exams];
  }

  String? next;
  String? previous;
  int? count;
  Storage storage = Storage();

  Future<Map<String, dynamic>?> getExams(int currentPage) async {
    final examsEndpoint = Uri.parse(Config.exams);

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.get(
      examsEndpoint,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );

    final responseData = json.decode(response.body);

    
    if (responseData['detail'] != null) {
      return responseData;
    }
    return responseData;
  }
}
