import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../my_config.dart';
import '../infrastructure/shared/storage.dart';

class CatItem with ChangeNotifier {
  int id;
  String name;
  String imgURL;

  CatItem({
    required this.id,
    required this.name,
    required this.imgURL,
  });
}

class Categories with ChangeNotifier {
  Storage storage = Storage();
  List<CatItem> _list = [];
  final loginEndPoint = Uri.parse(Config.categories);

  List<CatItem> get items {
    return [..._list];
  }

  Future<void> fetchCat(int pageNumber) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final List<CatItem> loadedCat = [];
    final url = Uri.parse('${Config.categories}?page=$pageNumber');
    final respone = await http.get(url, headers: {
      'Authorization': 'JWT $token',
    });
    final extractedData = json.decode(respone.body) as Map<String, dynamic>;

    for (var i = 0; i < 10; i++) {
      if (respone.statusCode == 200) {
        loadedCat.add(
          CatItem(
            id: extractedData['results'][i]['id'],
            name: extractedData['results'][i]['name'],
            imgURL: extractedData['results'][i]['image']['image'],
          ),
        );
      } else {}
    }

    _list.addAll(loadedCat);
    notifyListeners();
  }
}
