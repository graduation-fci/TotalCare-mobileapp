import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class InteractionsService {
  Storage storage = Storage();

  Future<dynamic> medicineInteraction(
      List<Map<String, dynamic>> interactionMedicines) async {
    Map<String, dynamic> responseData = {};
    final interactionsEndpoint = Uri.parse(Config.interactionMain);
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
      responseData['error'] =
          'You must have 2 medicines or more in your medication profile';
    } else {
      responseData = json.decode(response.body);
      if (responseData.isEmpty) {
        responseData['error'] =
            'There is no Interactions between your medicines.';
      }
    }
    // log('$responseData');
    return responseData;
  }
}
