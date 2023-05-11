import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class OrdersService {
  Storage storage = Storage();
  Map<String, String> error = {};

  Future<Map<String, dynamic>> placeOrder(int addressId, String cartId) async {
    final url = Uri.parse(Config.orders);
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
      body: json.encode(
        {
          "cart_id": cartId,
          "address_id": addressId,
        },
      ),
    );

    final responseData = json.decode(response.body);
    return responseData;
  }

  Future<Map<String, dynamic>> getOrdersList() async {
    final url = Uri.parse(Config.orders);
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
    if (responseData['results'].isEmpty || responseData['results'] == null) {
      error['errorMsg'] = 'You have no orders yet';
    log('${error['errorMsg']}');
      return error;
    }
    return responseData;
  }
}
