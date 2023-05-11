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
  String imgURL;
  //final int catID;

  DrugItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imgURL,
    // required this.catID,
  });
}

class Drugs with ChangeNotifier {
  String? errorMSG;
  Storage storage = Storage();
  List<DrugItem> _list = [];
  List<DrugItem> get items {
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
    });
    final extractedData = json.decode(respone.body) as Map<String, dynamic>;
    for (var i = 0; i < extractedData['count']; i++) {
      if (respone.statusCode == 200) {
        loadedCat.add(
          DrugItem(
            id: extractedData['results'][i]['id'],
            name: extractedData['results'][i]['name'],
            imgURL: extractedData['results'][i]['medicine_images'][0]['image'],
            price: extractedData['results'][i]['price'],
          ),
        );
      } else {
        errorMSG = 'Category has no Drugs!';
      }
    }
    _list = loadedCat;
    notifyListeners();
  }
}
