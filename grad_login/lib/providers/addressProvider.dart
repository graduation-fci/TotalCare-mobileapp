import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grad_login/my_config.dart';
import '../infrastructure/shared/storage.dart';

class AddressItem with ChangeNotifier {
  int id;
  String street;
  String city;
  String description;
  String phone;
  String type;
  String title;

  AddressItem(
      {required this.id,
      required this.street,
      required this.city,
      required this.description,
      required this.phone,
      required this.type,
      required this.title});
}

class Address with ChangeNotifier {
  Storage storage = Storage();
  List<AddressItem> _list = [];

  List<AddressItem> get items {
    return [..._list];
  }

  Future<void> fetchAddress() async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final List<AddressItem> loadedCat = [];
    final url = Uri.parse(Config.addresses);
    final respone = await http.get(url, headers: {
      'Authorization': 'JWT $token',
    });
    final extractedData = json.decode(respone.body) as List<dynamic>;

    if (respone.statusCode == 200) {
      for (var i = 0; i < extractedData.length; i++) {
        loadedCat.add(
          AddressItem(
              id: extractedData[i]['id'],
              street: extractedData[i]['street'],
              city: extractedData[i]['city'],
              description: extractedData[i]['description'],
              phone: extractedData[i]['phone'],
              type: extractedData[i]['type'],
              title: extractedData[i]['title']),
        );
        //   } else {}
        // }
        _list = loadedCat;
      }
      notifyListeners();
    }
  }

  Future<void> addAddress(String street, String city, String description,
      String phone, String type, String title) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final url = Uri.parse(Config.addresses);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'street': street,
          'city': city,
          'description': description,
          'phone': phone,
          'type': type,
          'title': title,
        },
      ),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newAddress = AddressItem(
        id: responseData['id'],
        street: responseData['street'],
        city: responseData['city'],
        description: responseData['description'],
        phone: responseData['phone'],
        type: responseData['type'],
        title: responseData['title'],
      );
      _list.add(newAddress);
      notifyListeners();
    } else {
      throw Exception('Failed to create address: ${response.statusCode}');
    }
  }

  AddressItem findByID(int id) {
    return _list.firstWhere((element) => element.id == id);
  }

  Future<void> updateAddress(
      int id, AddressItem addressItem, String type) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final addressIndex = _list.indexWhere((element) => element.id == id);
    final url = Uri.parse('${Config.addresses}$id/');
    try {
      final response = await http.patch(url,
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'street': addressItem.street,
            'city': addressItem.city,
            'description': addressItem.description,
            'phone': addressItem.phone,
            'type': type,
            'title': addressItem.title
          }));
      if (response.statusCode == 200) {
        print('Address updated successfully');
      } else {
        print('Failed to update address, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating address: $e');
    }
    _list[addressIndex] = addressItem;
    notifyListeners();
  }

  Future<void> deleteAddress(int id) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final addressIndex = _list.indexWhere((element) => element.id == id);
    final url = Uri.parse('${Config.addresses}$id/');
    AddressItem? existingProduct = _list[addressIndex];
    _list.removeAt(addressIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      _list.insert(addressIndex, existingProduct);
      notifyListeners();
      throw ('Could not delete product!');
    }

    existingProduct = null;
  }
}
