import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../my_config.dart';

class UserService with ChangeNotifier {
  final List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> register(User user, BuildContext context) async {
    const dynamic apiEndPoint = Config.apiUrl;
    final registerEndPoint = Uri.parse(apiEndPoint + '/auth/users/');

    try {
      final response = await http.post(
        registerEndPoint,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(
          {
            'username': user.username,
            'password': user.password,
            'email': user.email,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'profile_type': user.profile_type,
            // 'birthdate': user.birthdate,
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newUser = User(
          // id: json.decode(response.body)['name'],
          // birthdate: user.birthdate,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          password: user.password,
          profile_type: user.profile_type,
        );

        _users.add(newUser);
        notifyListeners();
        print(registerEndPoint);
      }
    } catch (error) {
      print(error);
    }
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
