import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../infrastructure/shared/storage.dart';

import '../my_config.dart';

class DrugItem with ChangeNotifier {
  int id;
  String name;
  double price;
  List imgURL;
  List drugsList;
  //final int catID;

  DrugItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imgURL,
    required this.drugsList,
  });
}

class Drugs with ChangeNotifier {
  String? errorMSG;
  Storage storage = Storage();
  List<dynamic> _list = [];
  List<dynamic> get items {
    return [..._list];
  }

  Future<void> fetchDrug(int catID) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final List<DrugItem> loadedCat = [];
    final url = Uri.parse('${Config.drugs}?category=$catID');
    print(url);
    final respone = await http.get(url, headers: {
      'Authorization': 'JWT $token',
      "Accept-Language": "ar",
    });
    final extractedData =
        json.decode(utf8.decode(respone.bodyBytes)) as Map<String, dynamic>;
    log('$extractedData');
    _list = extractedData['results'];
    notifyListeners();
  }
}
