import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grad_login/my_config.dart';

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
  List<AddressItem> _list = [];

  List<AddressItem> get items {
    return [..._list];
  }

  Future<void> fetchAddress() async {
    final List<AddressItem> loadedCat = [];
    final url = Uri.parse('http://192.168.1.5:8000/users/addresses');
    final respone = await http.get(url, headers: {
      'Authorization':
          'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjA1MzkyLCJqdGkiOiJkNjg2MjkyYjI3OTU0N2FkOWIxZmJiM2YwZjQ3NTNmOSIsInVzZXJfaWQiOjUsInVzZXJuYW1lIjoibmV3dXNlciIsImVtYWlsIjoic0BhYWEuY28iLCJmaXJzdF9uYW1lIjoibmV3IiwibGFzdF9uYW1lIjoidXNlciIsInByb2ZpbGVfdHlwZSI6IlBBVCIsImlzX3N0YWZmIjpmYWxzZX0.SQtcrwJoWcA4yn9jw7XdvMO-QWr94JtIBv1wMA6Vw1k '
    });
    final extractedData = json.decode(respone.body) as List<dynamic>;
    // print(extractedData.runtimeType);
    //print(extractedData);

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
    final url = Uri.parse('http://192.168.1.5:8000/users/addresses/');
    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjA1MzkyLCJqdGkiOiJkNjg2MjkyYjI3OTU0N2FkOWIxZmJiM2YwZjQ3NTNmOSIsInVzZXJfaWQiOjUsInVzZXJuYW1lIjoibmV3dXNlciIsImVtYWlsIjoic0BhYWEuY28iLCJmaXJzdF9uYW1lIjoibmV3IiwibGFzdF9uYW1lIjoidXNlciIsInByb2ZpbGVfdHlwZSI6IlBBVCIsImlzX3N0YWZmIjpmYWxzZX0.SQtcrwJoWcA4yn9jw7XdvMO-QWr94JtIBv1wMA6Vw1k ',
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
    print('Street:$street');
    print('City:$city');
    print('Description:$description');
    print('Phone$phone');
    print('type:$type');
    print('title:$title');
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
    final addressIndex = _list.indexWhere((element) => element.id == id);
    final url = Uri.parse('http://192.168.1.5:8000/users/addresses/$id/');
    try {
      final response = await http.patch(url,
          headers: {
            'Authorization':
                'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjA1MzkyLCJqdGkiOiJkNjg2MjkyYjI3OTU0N2FkOWIxZmJiM2YwZjQ3NTNmOSIsInVzZXJfaWQiOjUsInVzZXJuYW1lIjoibmV3dXNlciIsImVtYWlsIjoic0BhYWEuY28iLCJmaXJzdF9uYW1lIjoibmV3IiwibGFzdF9uYW1lIjoidXNlciIsInByb2ZpbGVfdHlwZSI6IlBBVCIsImlzX3N0YWZmIjpmYWxzZX0.SQtcrwJoWcA4yn9jw7XdvMO-QWr94JtIBv1wMA6Vw1k ',
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
    // print(addressIndex);
    print('street: ${_list[addressIndex].street}');
    print('city: ${_list[addressIndex].city}');
    print('Description: ${_list[addressIndex].description}');
    print('phone: ${_list[addressIndex].phone}');
    print('type: ${type}');
    print('title: ${_list[addressIndex].title}');
    // print(addressItem);
    notifyListeners();
  }

  Future<void> deleteAddress(int id) async {
    //print('Deleting address with ID: $id');

    final addressIndex = _list.indexWhere((element) => element.id == id);
    final url = Uri.parse('http://192.168.1.5:8000/users/addresses/$id/');
    AddressItem? existingProduct = _list[addressIndex];
    _list.removeAt(addressIndex);
    notifyListeners();

    // print('Sending DELETE request to $url');
    final response = await http.delete(
      url,
      headers: {
        'Authorization':
            'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjA1MzkyLCJqdGkiOiJkNjg2MjkyYjI3OTU0N2FkOWIxZmJiM2YwZjQ3NTNmOSIsInVzZXJfaWQiOjUsInVzZXJuYW1lIjoibmV3dXNlciIsImVtYWlsIjoic0BhYWEuY28iLCJmaXJzdF9uYW1lIjoibmV3IiwibGFzdF9uYW1lIjoidXNlciIsInByb2ZpbGVfdHlwZSI6IlBBVCIsImlzX3N0YWZmIjpmYWxzZX0.SQtcrwJoWcA4yn9jw7XdvMO-QWr94JtIBv1wMA6Vw1k ',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      _list.insert(addressIndex, existingProduct);
      notifyListeners();
      throw ('Could not delete product!');
    }

    existingProduct = null;

    // print('Address with ID $id has been successfully deleted.');
  }
}
