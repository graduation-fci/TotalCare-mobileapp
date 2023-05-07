import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class InteractionsService {
  Storage storage = Storage();

  Future<dynamic> medicineInteraction(
      List<Map<String, dynamic>> interactionMedicines) async {
    final interactionsEndpoint = Uri.parse(Config.interactionMain);
    Map<String, dynamic> responseData = {};
    Map<String, String> error = {};

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.post(
      interactionsEndpoint,
      body: json.encode({'medicine': interactionMedicines}),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "JWT $token",
      },
    );
    if (response.statusCode == 500) {
      error['errorMsg'] = 'You must have 2 medicines or more';
      return error;
    }
    responseData = json.decode(response.body);
    if (responseData.isEmpty) {
      error['errorMsg'] = 'There is no Interactions between your medicines.';
      return error;
    }
    // log('$responseData');
    return responseData;
  }
}
