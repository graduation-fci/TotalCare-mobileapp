import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/exam.dart';
import '../../my_config.dart';
import '../shared/storage.dart';

class MedicineService {
  List<Exam> _exams = [];

  List<Exam> get exams {
    return [..._exams];
  }

  String? next;
  String? previous;
  int? count;
  Storage storage = Storage();

  Future<Map<String, dynamic>?> getSimpleMeds() async {
    final simpleMedsEndpoint = Uri.parse(Config.simpleMeds);

    // String? token;
    // await storage.getToken().then((value) {
    //   token = value;
    // });

    final response = await http.get(
      simpleMedsEndpoint,
      headers: {
        "content-type": "application/json",
        // "Authorization": "JWT $token",
      },
    );

    final responseData = json.decode(response.body);

    // if (responseData['results'] != null) {
    //   return responseData;
    // }
    return responseData;
  }
}
