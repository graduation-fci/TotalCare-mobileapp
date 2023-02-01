import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final String profile_Type;
  final email;
  // final DateTime birthdate;

  User({
    required this.username,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.profile_Type,
    // required this.birthdate,
  });
}

class Users with ChangeNotifier {
  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> register(User user, BuildContext context) async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/my_config.json');
    final dynamic jsonMap = jsonDecode(jsonString)['apiUrl'];
    final apiEndpoint = Uri.https(jsonMap, '/users');
    final response = await http.post(apiEndpoint,
        body: json.encode({
          'username': user.username,
          'password': user.password,
          'email': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'profile_type': user.profile_Type,
          // 'birthdate': user.birthdate,
        }));

    print(response.body);

    final newUser = User(
      id: json.decode(response.body)['name'],
      // birthdate: user.birthdate,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      profile_Type: user.profile_Type,
    );

    _users.add(newUser);
    notifyListeners();
  }

  Future<void> fetchUsers(BuildContext context) async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/my_config.json');
    final dynamic jsonMap = jsonDecode(jsonString)['apiUrl'];
    final apiUrl = Uri.https(jsonMap, '/users');
    try {
      final response = await http.get(apiUrl);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<User> loadedData = [];

      fetchedData.forEach((userId, userData) {
        loadedData.add(
          User(
            id: userId,
            // birthdate: userData['birthdate'],
            username: userData['username'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            email: userData['email'],
            password: userData['password'],
            profile_Type: userData['rePassword'],
          ),
        );
      });
      _users = loadedData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<http.Response> login(
    String email,
    String password,
  ) async {
    // final jsonString = await DefaultAssetBundle.of(context)
    //     .loadString('assets/my_config.json');
    // final dynamic jsonMap = jsonDecode(jsonString)['apiUrl'];
    // final profileEndPoint = Uri.https(jsonMap, '/auth/users/me');
    final apiEndpoint = Uri.parse('http://192.168.1.3:8000/auth/users');

    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDomO8FT2S3VRo5l6fAhjzBJJH2xwX0yMo');
    // print(apiEndpoint);
    return await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
          // 'username': username,
          // 'password': password,
          // 'email': email,
          // 'first_name': first_name,
          // 'last_name': last_name,
          // 'profile_type': profile_type,
        },
      ),
    );
    // final response = await http.get(profileEndPoint);
    // print(response);
    // print(json.decode(response.body));
  }
}
