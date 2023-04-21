import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../../models/simple_medicine.dart';
import '../shared/storage.dart';

class InteractionsService {
  var apiEndPoint = Config.simpleMeds;
  Storage storage = Storage();

  Future<Map<String, dynamic>?> fetchInteractionSearchData(
      {String? search, String? ordering}) async {
    const baseUrl = Config.simpleMeds;
    final queryParams = <String, String>{};
    // String? token;
    // await storage.getToken().then((value) {
    //   token = value;
    // });
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
        // "Authorization": "JWT $token",
      },
    );
    final responseData = json.decode(response.body);

    // if (responseData['details'] == null) {
    //   return responseData;
    // }
    return responseData;
  }

  String _getQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }

  Future<Map<String, dynamic>> medicineInteraction(
      List<Map<String, dynamic>> interactionMedicines) async {
    final interactionsEndpoint = Uri.parse(Config.interactionMain);
  
    final response = await http.post(
      interactionsEndpoint,
      body: json.encode({'medicine': interactionMedicines}),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = json.decode(response.body);
    // log('$response');
    return responseData;
  }
}
