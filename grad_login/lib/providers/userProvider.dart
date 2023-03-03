import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grad_login/infrastructure/user/userService.dart';
import 'package:grad_login/providers/examProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../my_config.dart';

class UserProvider with ChangeNotifier {
  UserService userService = UserService();
  final List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> getUser() async {
    const dynamic apiEndPoint = Config.apiUrl;
    final registerEndPoint = Uri.parse(apiEndPoint + '/auth/users/me/');
    await http.get(registerEndPoint);
  }

  Future<void> getUserResult(BuildContext context) async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/my_config.json');
    final dynamic apiEndPoint = jsonDecode(jsonString)['apiUrl'];
    final registerEndPoint = Uri.parse(apiEndPoint + '/exam/results/');
    await http.get(registerEndPoint);
  }

  Future<void> getSearchedData(String searchQuery) {
    return userService.getSearchedData(searchQuery);
  }

  Future<void> ascendingOrder() {
    return userService.ascendingOrder();
  }

  Future<void> descendingOrder() {
    return userService.descendingOrder();
  }

  // Future<void> fetchUsers(BuildContext context) async {
  //   final jsonString = await DefaultAssetBundle.of(context)
  //       .loadString('assets/my_config.json');
  //   final dynamic jsonMap = jsonDecode(jsonString)['apiUrl'];
  //   final apiUrl = Uri.https(jsonMap, '/users');
  //   try {
  //     final response = await http.get(apiUrl);
  //     final fetchedData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<User> loadedData = [];

  //     fetchedData.forEach((userId, userData) {
  //       loadedData.add(
  //         User(
  //           // id: userId,
  //           // birthdate: userData['birthdate'],
  //           username: userData['username'],
  //           firstName: userData['firstName'],
  //           lastName: userData['lastName'],
  //           email: userData['email'],
  //           password: userData['password'],
  //           profile_type: userData['rePassword'],
  //         ),
  //       );
  //     });
  //     _users = loadedData;
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
