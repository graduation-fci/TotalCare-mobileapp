import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class UserService {
  Storage storage = Storage();

  Future<Map<String, dynamic>> getMyProfile() async {
    final url = Uri.parse(Config.myProfile);
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
    log('$responseData');
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
  }

  Future<Map<String, dynamic>> getMedications() async {
    final url = Uri.parse(Config.userMedications);
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
    log('$responseData');
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
  }
  
  Future<void> deleteMedication(int id) async {
    final url = Uri.parse('${Config.userMedications}$id/');
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.delete(
      url,
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
  }
  
}
