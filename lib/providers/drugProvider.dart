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
  String? _nextPageEndPoint;

  String? _previousPageEndPoint;
  List<dynamic> get items {
    return [..._list];
  }

  String? get nextPageEndPoint {
    return _nextPageEndPoint;
  }

  String? get previousPageEndPoint {
    return _previousPageEndPoint;
  }

  Future<void> fetchDrug({String? catID, String? searchQuery}) async {
    Map<String, String> queryParams = {};
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    if (searchQuery != null) {
      queryParams['search'] = searchQuery;
    }
    if (catID != null) {
      queryParams['category'] = catID;
    }
    final url = Uri.parse(
        '${Config.drugs}?${_getQueryString(queryParams)}');
    final respone = await http.get(url, headers: {
      'Authorization': 'JWT $token',
      "Accept-Language": "ar",
    });
    final extractedData =
        json.decode(utf8.decode(respone.bodyBytes)) as Map<String, dynamic>;
    _list = extractedData['results'];
    _nextPageEndPoint = extractedData['next'];
    _previousPageEndPoint = extractedData['previous'];
    notifyListeners();
  }

  Future<void> fetchNextDrug(String nextUrl) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final url = Uri.parse(nextUrl);
    final respone = await http.get(
      url,
      headers: {'Authorization': 'JWT $token', "Accept-Language": "ar"},
    );
    final extractedData = json.decode(utf8.decode(respone.bodyBytes));
    _list.addAll(extractedData['results']);
    _nextPageEndPoint = extractedData['next'];
    _previousPageEndPoint = extractedData['previous'];
    notifyListeners();
  }

  Future<void> fetchPreviousDrug(String previousUrl) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final url = Uri.parse(previousUrl);
    final respone = await http.get(
      url,
      headers: {'Authorization': 'JWT $token', "Accept-Language": "ar"},
    );
    final extractedData = json.decode(utf8.decode(respone.bodyBytes));
    _list = extractedData['results'];
    _nextPageEndPoint = extractedData['next'];
    _previousPageEndPoint = extractedData['previous'];
    notifyListeners();
  }

  String _getQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}
