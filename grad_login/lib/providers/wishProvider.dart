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
    // String? token;
    // await storage.getToken().then((value) {
    //   token = value;
    // });
    // log(token.toString());
    final url = Uri.parse(Config.wishList);
    final respone = await http.get(url, headers: {
      'Authorization':
          'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg2MjQ2NTI5LCJpYXQiOjE2ODYxNjAxMjksImp0aSI6IjdiMzIzNzI2MjdhMjQyYWY4NDJmYWM3Y2E3MTBkYTI3IiwidXNlcl9pZCI6MywidXNlcm5hbWUiOiIzYmRlbG1ha3NvdWQiLCJlbWFpbCI6ImFiZGVsbWFrc291ZGVsc3llZDFAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6IkFobWVkIiwibGFzdF9uYW1lIjoiQWJkZWxtYXFzb3VkIiwicHJvZmlsZV90eXBlIjoiUEFUIiwiaXNfc3RhZmYiOmZhbHNlfQ.3UQxTAX-NAvylCvQ2_vzsy8yUDZ5gCVM20JhGK-OYlk',
    });
    final extractedData = json.decode(respone.body) as List<dynamic>;
    _list = extractedData[0]['items'];
    // log(extractedData[0]['items'].toString());
    // log(extractedData[0]['id'].toString());
    // log(_list.toString());
    notifyListeners();
  }

  Future<void> addWish(int id, drugID) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
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
      // getWishID();
      log('Added');
      notifyListeners();
    } else {
      errorMSG = 'Failed to add address, Please try again later!';
    }
    notifyListeners();
  }

  Future<void> deleteWish(int id, drugID) async {
    log(id.toString());
    log(drugID.toString());
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final url = Uri.parse('${Config.wishList}$id/items/$drugID/');

    // log(_list.toString());
    // log(url.toString());
    final response = await http.delete(
      url,
      headers: {
        'Authorization':
            'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg2MjQ2NTI5LCJpYXQiOjE2ODYxNjAxMjksImp0aSI6IjdiMzIzNzI2MjdhMjQyYWY4NDJmYWM3Y2E3MTBkYTI3IiwidXNlcl9pZCI6MywidXNlcm5hbWUiOiIzYmRlbG1ha3NvdWQiLCJlbWFpbCI6ImFiZGVsbWFrc291ZGVsc3llZDFAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6IkFobWVkIiwibGFzdF9uYW1lIjoiQWJkZWxtYXFzb3VkIiwicHJvZmlsZV90eXBlIjoiUEFUIiwiaXNfc3RhZmYiOmZhbHNlfQ.3UQxTAX-NAvylCvQ2_vzsy8yUDZ5gCVM20JhGK-OYlk',
        'Content-Type': 'application/json',
      },
    );
    log('Deleted!');
    getWishID();
    notifyListeners();
    log(response.statusCode.toString());

    // if (response.statusCode >= 400) {
    //   addWish(id, drugID);
    //   notifyListeners();
    //   errorMSG = 'Failed to delete item, try again later!';
    // }
    // log('Deleted !');
  }
}
