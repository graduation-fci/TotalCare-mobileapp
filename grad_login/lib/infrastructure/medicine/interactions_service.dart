import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class InteractionsService {
  Storage storage = Storage();

  Future<Map<String, dynamic>> medicineInteraction(
      List<Map<String, dynamic>> interactionMedicines) async {
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
    final responseData = json.decode(response.body);
    // log('$responseData');
    return responseData;
  }
}
