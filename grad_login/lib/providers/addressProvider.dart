import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grad_login/my_config.dart';

class AddressItem with ChangeNotifier {
  // final int id;
  final String street;
  final String city;
  final String description;

  AddressItem(
      {
      // required this.id,
      required this.street,
      required this.city,
      required this.description});
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
          'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgyOTU2NjI1LCJqdGkiOiJkNDg1Yjg0OGI3YzA0N2MzYmUyMjJmZmNkZGM5YTEzZSIsInVzZXJfaWQiOjUsInVzZXJuYW1lIjoibmV3dXNlciIsImVtYWlsIjoic0BhYWEuY28iLCJmaXJzdF9uYW1lIjoibmV3IiwibGFzdF9uYW1lIjoidXNlciIsInByb2ZpbGVfdHlwZSI6IlBBVCIsImlzX3N0YWZmIjpmYWxzZX0.gCOxvxuIdaV3Vre2Wwkeo8s98BRib3KSdaUSRwagvxE'
    });
    final extractedData = json.decode(respone.body) as List<dynamic>;
    // print(extractedData.runtimeType);
    //print(extractedData);

    if (respone.statusCode == 200) {
      for (var i = 0; i < extractedData.length; i++) {
        loadedCat.add(
          AddressItem(
            // id: extractedData[i]['id'],
            street: extractedData[i]['street'],
            city: extractedData[i]['city'],
            description: extractedData[i]['description'],
          ),
        );
        //   } else {}
        // }
        _list = loadedCat;
      }
      notifyListeners();
    }
  }

  Future<void> addAddress(
      String street, String city, String description) async {
    final url = Uri.parse('http://192.168.1.5:8000/users/addresses/');
    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgyOTU2NjI1LCJqdGkiOiJkNDg1Yjg0OGI3YzA0N2MzYmUyMjJmZmNkZGM5YTEzZSIsInVzZXJfaWQiOjUsInVzZXJuYW1lIjoibmV3dXNlciIsImVtYWlsIjoic0BhYWEuY28iLCJmaXJzdF9uYW1lIjoibmV3IiwibGFzdF9uYW1lIjoidXNlciIsInByb2ZpbGVfdHlwZSI6IlBBVCIsImlzX3N0YWZmIjpmYWxzZX0.gCOxvxuIdaV3Vre2Wwkeo8s98BRib3KSdaUSRwagvxE',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'street': street,
          'city': city,
          'description': description,
        },
      ),
    );
    print(street);
    print(city);
    print(description);
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newAddress = AddressItem(
          // id: responseData['id'],
          street: responseData['street'],
          city: responseData['city'],
          description: responseData['description']);
      _list.add(newAddress);
      notifyListeners();
    } else {
      throw Exception('Failed to create address: ${response.statusCode}');
    }
  }
}
