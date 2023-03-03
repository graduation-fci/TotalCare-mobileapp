import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../models/exam.dart';
import '../../my_config.dart';
import '../shared/storage.dart';

class UserService {
  // String? search;
  // String? orderBy;
  // String? subjectId;

  // Map<String, dynamic> queryParameters = {
  //   'search': '',
  //   'ordering': '',
  //   'subject_id': '',
  // };

  Storage storage = Storage();

  Future<Map<String, dynamic>?> getSearchedData(String searchQuery) async {
    // search = searchQuery;
    // final apiEndPoint = Uri.https(Config.apiUrl, '/${Config.exams}', {
    //   'search': search,
    //   'ordering': orderBy,
    //   'subject_id': subjectId,
    // });

    final apiEndPoint = Uri.parse('${Config.exams}?search=$searchQuery');

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final response = await http.get(
      apiEndPoint,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );

    // final responseData = json.decode(response.body);
    log('${json.decode(response.body)}');
    // if (responseData['details'] == null) {
    //   return responseData;
    // }
    // return responseData;
    // print(response);
  }

  Future<Map<String, dynamic>?> ascendingOrder() async {
    final apiEndPoint = Uri.parse('${Config.exams}?ordering=starts_at');
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final response = await http.get(
      apiEndPoint,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );

    final responseData = json.decode(response.body);
    log('$responseData');
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
    // print(response);
  }

  Future<Map<String, dynamic>?> descendingOrder() async {
    final apiEndPoint = Uri.parse('${Config.exams}?ordering=-starts_at');
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final response = await http.get(
      apiEndPoint,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );

    final responseData = json.decode(response.body);
    log('$responseData');
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
    // print(response);
  }
}
