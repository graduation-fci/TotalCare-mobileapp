import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class UserService {
  Storage storage = Storage();

  Future<Map<String, dynamic>> getUserById(int id) async {
    final url = Uri.parse('${Config.getUserById}$id');
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );

    final responseData = json.decode(response.body);
    log(responseData);
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
  }
}
