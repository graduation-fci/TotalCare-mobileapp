import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grad_login/my_config.dart';

class CatItem with ChangeNotifier {
  final int id;
  final String name;
  final String imgURL;

  CatItem({
    required this.id,
    required this.name,
    required this.imgURL,
  });
}

class Categories with ChangeNotifier {
  List<CatItem> _list = [];
  final loginEndPoint = Uri.parse(Config.categories);

  List<CatItem> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((element) => element.isFavourite).toList();
    // }
    return [..._list];
  }

  Future<void> fetchCat() async {
    final url =
        Uri.parse('http://192.168.1.5:8000/medicine/categories/?page=1');
    final respone = await http.get(url);
    final extractedData = json.decode(respone.body)['count'];
    final pageCount = (extractedData / 10).round();
    //print(pageCount);
    final List<CatItem> loadedCat = [];
    for (var z = 1; z <= pageCount; z++) {
      final url =
          Uri.parse('http://192.168.1.5:8000/medicine/categories/?page=$z');
      final respone = await http.get(url);
      final extractedData = json.decode(respone.body) as Map<String, dynamic>;
      //print(extractedData);

      for (var i = 0; i < extractedData['results'].length; i++) {
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
      _list = loadedCat;
      //print(_list[0].id);
      // print(_list[1].name);
      // print(_list[0].imgURL);
      // print(_list.length);
      // print(_list[3].imgURL);
      notifyListeners();
    }
  }
}
