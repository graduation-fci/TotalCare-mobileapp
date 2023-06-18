import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import '../infrastructure/shared/storage.dart';
import '../my_config.dart';

import 'package:flutter/material.dart';

class Wish with ChangeNotifier {
  String? errorMSG;

  Storage storage = Storage();
  List<dynamic> _list = [];

  List<dynamic> get items {
    return [..._list];
  }

  Future<void> getWishID() async {
    String? token = await storage.getToken();
    log(token.toString());
    final url = Uri.parse(Config.wishList);
    final response = await http.get(url, headers: {
      'Authorization': 'JWT $token',
    });
    final extractedData = json.decode(response.body) as List<dynamic>;
    log(extractedData[0].toString());
    _list = extractedData[0]['items'];
    notifyListeners();
  }

  Future<void> addWish(int id, drugID) async {
    String? token = await storage.getToken();
    final url = Uri.parse('${Config.wishList}$id/items/');
    log('accessed');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {'product_id': drugID},
      ),
    );

    if (response.statusCode == 201) {
      log('Added');
      notifyListeners();
    } else {
      errorMSG = 'Failed to add address, Please try again later!';
    }
    getWishID();
    notifyListeners();
  }

  Future<void> deleteWish(int id, drugID) async {
    log(id.toString());
    log(drugID.toString());
    String? token = await storage.getToken();
    final url = Uri.parse('${Config.wishList}$id/items/$drugID/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json',
      },
    );
    log('Deleted!');
    getWishID();
    notifyListeners();
    log(response.statusCode.toString());
  }

  Future<void> deleteFavWish(int id, drugID) async {
    log(id.toString());
    log(drugID.toString());
    String? token = await storage.getToken();

    log('items:::$items');
    final prodID = await items.firstWhere((element) {
      log('elements:::::$element');
      return element['product']['id'] == drugID;
    });
    log('Product::${prodID.toString()}');

    final url = Uri.parse('${Config.wishList}$id/items/${prodID['id']}/');
    log(url.toString());
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json',
      },
    );
    log('Deleted!');
    getWishID();
    notifyListeners();
    // log(response.statusCode.toString());
  }
}
