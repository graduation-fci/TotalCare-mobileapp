import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/exam.dart';
import '../../my_config.dart';
import '../shared/storage.dart';

class MedicineService {
  String? next;
  String? previous;
  int? count;
  Storage storage = Storage();

  Future<Map<String, dynamic>?> getSimpleMeds() async {
    final simpleMedsEndpoint = Uri.parse(Config.simpleMeds);

    final response = await http.get(
      simpleMedsEndpoint,
      headers: {
        "content-type": "application/json",
      },
    );

    final responseData = json.decode(response.body);

    if (responseData['results'] != null) {
      return responseData;
    }
    return responseData;
  }

  Future<Map<String, dynamic>?> filterSimpleMedsData(
      {String? search, String? ordering}) async {
    const baseUrl = Config.simpleMeds;
    final queryParams = <String, String>{};
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    if (search != null) {
      queryParams['search'] = search;
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering;
    }
    final url = Uri.parse('$baseUrl?${_getQueryString(queryParams)}');
    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );
    final responseData = json.decode(response.body);

    return responseData;
  }

  Future<Map<String, dynamic>?> filterCategories({String? search}) async {
    const baseUrl = Config.generalCategories;
    final queryParams = <String, String>{};
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    if (search != null) {
      queryParams['search'] = search;
    }

    final url = Uri.parse('$baseUrl?${_getQueryString(queryParams)}');
    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );
    final responseData = json.decode(response.body);
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
  }

  Future<Map<String, dynamic>?> getNotification(int id) async {
    const baseUrl = Config.interactionNotification;
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
      body: json.encode({"id": id}),
    );
    final responseData = json.decode(response.body);
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
  }

  String _getQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}
