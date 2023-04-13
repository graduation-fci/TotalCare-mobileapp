import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class UserService {
  var apiEndPoint = Config.simpleMeds;
  Storage storage = Storage();

  Future<Map<String, dynamic>?> fetchData(
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
        // "Authorization": "JWT $token",
      },
    );
    final responseData = json.decode(response.body);
    log('${json.decode(response.body)}');
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
}
