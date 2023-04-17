import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../infrastructure/medicine/interactions_service.dart';
import '../models/user.dart';
import '../my_config.dart';

class UserProvider with ChangeNotifier {
  InteractionsService userService = InteractionsService();
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

  Future<Map<String,dynamic>?> getFilteredData({searchQuery, ordering}) {
    return userService.fetchInteractionSearchData(
        search: searchQuery, ordering: ordering);
  }

  Future<void> handleOrder(String searchQuery, {ordering}) {
    return userService.fetchInteractionSearchData(
        search: searchQuery, ordering: ordering);
  }
}
