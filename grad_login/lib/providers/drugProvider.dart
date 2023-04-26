import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DrugItem with ChangeNotifier {
  final int id;
  final String name;
  final double price;
  final String imgURL;
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
  List<DrugItem> _list = [];
  List<DrugItem> get items {
    return [..._list];
  }
/*
  Future<void> fetchDrug(int categoryID) async {
    //print('catID:${catID}');
    final url = Uri.parse(
        'http://192.168.1.5:8000/medicine/products/?category=$categoryID');
    final respone = await http.get(url);
    final extractedData = json.decode(respone.body)['results'] as Map<String,dynamic>;
    print('extracted:$extractedData');
    // final pageCount = (extractedData / 10).ceil();
    // //print(pageCount);
    // final List<DrugItem> loadedCat = [];
    // //رجعه تاني $pagecount لما تخلص
    // for (var z = 1; z <= pageCount; z++) {
    //   print('Processing page $z of $pageCount');
    //   final url =
    //       Uri.parse('http://192.168.1.5:8000/medicine/products/?page=$z');
    //   final respone = await http.get(url);
    //   final extractedData = json.decode(respone.body) as Map<String, dynamic>;
    //   // print(extractedData);

    //   for (var i = 0; i < extractedData['results'].length; i++) {
    //     if (respone.statusCode == 200) {
    //       print('Processing page ${i + 1} of 10');
    //       final imgURL =
    //           extractedData['results'][0]['medicine_images'][0]['image'];
    //       final catID = extractedData['results'][i]['category'] != null
    //           ? extractedData['results'][i]['category'][0]['id']
    //           : 0;

    //       print('catID: $catID');
    //       if (catID == categoryID) {
    //         if (imgURL != null) {
    //           loadedCat.add(
    //             DrugItem(
    //               id: extractedData['results'][i]['id'],
    //               name: extractedData['results'][i]['name'],
    //               price: extractedData['results'][i]['price'],
    //               //اسأل فيهم بدل ما هما 0
    //               imgURL: imgURL,
    //               catID: catID,
    //             ),
    //           );
    //         }
    //       }
    //     }
    //   }
    //print(_list[0].catID);
    // print(_list[1].name);
    // print(_list[0].imgURL);
    // print(_list.length);
    // print(_list[3].imgURL);
    //_list = loadedCat;
    // print('List items are:${_list}');
  }

  //print('Done');
  //print(_list.length);
  @override
  notifyListeners();
  //return _list;
}
*/

  Future<void> fetchDrug(int catID) async {
    //final url =
    //  Uri.parse('http://192.168.1.5:8000/medicine/categories/?page=1');
    // final respone = await http.get(url);
    // final extractedData = json.decode(respone.body)['count'];
    // final pageCount = (extractedData / 10).ceil();
    //print(pageCount);
    final List<DrugItem> loadedCat = [];
    // for (var z = 1; z <= pageCount; z++) {
    final url =
        Uri.parse('http://192.168.1.5:8000/medicine/products/?category=$catID');
    final respone = await http.get(url);
    final extractedData = json.decode(respone.body) as Map<String, dynamic>;
    //print('Extracted Data: $extractedData');

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
      } else {}
    }
    _list = loadedCat;
    // print(_list[0].id);
    // print(_list[0].name);
    // print(_list[0].imgURL);
    // print(_list.length);
    // print(_list[3].imgURL);
    notifyListeners();
  }
}
