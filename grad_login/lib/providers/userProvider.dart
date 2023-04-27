import 'package:flutter/material.dart';

import '../infrastructure/user/user_service.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserService userService = UserService();
  final List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<Map<String, dynamic>?> getUserById(int id) {
    return userService.getUserById(id);
  }
}
