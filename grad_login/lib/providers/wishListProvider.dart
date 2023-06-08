// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../my_config.dart';
// import '../infrastructure/shared/storage.dart';

// class WishItem with ChangeNotifier {
//   int id;
//   String street;
//   String city;
//   String description;
//   String phone;
//   String type;
//   String title;

//   WishItem(
//       {required this.id,
//       required this.street,
//       required this.city,
//       required this.description,
//       required this.phone,
//       required this.type,
//       required this.title});
// }

// class Wish with ChangeNotifier {
//   String? errorMSG;

//   Storage storage = Storage();
//   List<WishItem> _list = [];

//   List<WishItem> get items {
//     return [..._list];
//   }

//   Future<void> getWishID() async {
//     String? token;
//     await storage.getToken().then((value) {
//       token = value;
//       log(token.toString());
//     });
//     final List<WishItem> loadedCat = [];
//     final url = Uri.parse(Config.wishList);
//     final respone = await http.get(url, headers: {
//       'Authorization': 'JWT $token',
//     });
//     final extractedData = json.decode(respone.body) as Map<String, dynamic>;
//     log(extractedData.toString());
//   }

//   Future<void> addWish(String street, String city, String description,
//       String phone, String type, String title) async {
//     String? token;
//     await storage.getToken().then((value) {
//       token = value;
//     });
//     final url = Uri.parse(Config.wishList);
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'JWT $token',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(
//         {
//           'street': street,
//           'city': city,
//           'description': description,
//           'phone': phone,
//           'type': type,
//           'title': title,
//         },
//       ),
//     );

//     if (response.statusCode == 201) {
//       final responseData = json.decode(response.body);
//       final newWish = WishItem(
//         id: responseData['id'],
//         street: responseData['street'],
//         city: responseData['city'],
//         description: responseData['description'],
//         phone: responseData['phone'],
//         type: responseData['type'],
//         title: responseData['title'],
//       );
//       _list.add(newWish);
//       notifyListeners();
//     } else {
//       errorMSG = 'Failed to add Wish, Please try again later!';
//     }
//   }

//   WishItem findByID(int id) {
//     return _list.firstWhere((element) => element.id == id);
//   }

//   Future<void> updateWish(int id, WishItem WishItem, String type) async {
//     String? token = await storage.getToken();
//     final WishIndex = _list.indexWhere((element) => element.id == id);
//     final url = Uri.parse('${Config.wishList}$id/');

//     final response = await http.patch(
//       url,
//       headers: {
//         'Authorization': 'JWT $token',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'street': WishItem.street,
//         'city': WishItem.city,
//         'description': WishItem.description,
//         'phone': WishItem.phone,
//         'type': type,
//         'title': WishItem.title
//       }),
//     );
//     print(response.body);
//     if (response.statusCode == 200) {
//       _list[WishIndex] = WishItem;
//     } else {
//       errorMSG = 'Failed to update Wish, try again later!';
//     }

//     notifyListeners();
//   }

//   Future<void> deleteWish(int id) async {
//     String? token;
//     await storage.getToken().then((value) {
//       token = value;
//     });
//     final WishIndex = _list.indexWhere((element) => element.id == id);
//     final url = Uri.parse('${Config.wishList}$id/');
//     WishItem? existingProduct = _list[WishIndex];
//     _list.removeAt(WishIndex);
//     notifyListeners();
//     final response = await http.delete(
//       url,
//       headers: {
//         'Authorization': 'JWT $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode >= 400) {
//       _list.insert(WishIndex, existingProduct);
//       notifyListeners();
//       errorMSG = 'Failed to delete Wish, try again later!';
//     }

//     existingProduct = null;
//   }
// }
