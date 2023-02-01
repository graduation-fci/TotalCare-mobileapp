import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var newUser = User(
      username: 'username',
      id: '',
      firstName: 'firstName',
      lastName: 'lastName',
      email: 'email',
      password: 'password',
      profile_Type: 'profile_Type',
      // birthdate: DateTime.now(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login demo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () async => {
              await Provider.of<Users>(context, listen: false)
                  .login('test@test.com', 'hassan')
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(child: Text(newUser.username)),
    );
  }
}
