import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userService.dart';
import '../providers/authService.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var newUser = User(
    username: 'hassan003',
    // id: 'hassan001',
    firstName: 'Hassan',
    lastName: 'Elsayed',
    email: 'hassanleave03@test.com',
    password: 'Aa012345543210',
    profile_type: 'STD',
    // birthdate: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login demo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () async => {
              // await Provider.of<Users>(context, listen: false)
              //     .login('hassanelsayed009', 'test123123', context)
              // await Provider.of<Users>(context, listen: false).register(
              //   newUser,
              //   context,
              // )
              await Provider.of<AuthService>(context, listen: false).login(
                'hassan003',
                'Aa012345543210',
                context,
              )
              // await Provider.of<AuthService>(context, listen: false).refreshJwt(
              //   context,
              // )
              // await Provider.of<AuthService>(context, listen: false).logout()
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        height: 300,
        child: ListView.builder(
          itemBuilder: (context, item) => Text(
            newUser.username,
          ),
          itemCount: Provider.of<UserService>(context).users.length,
        ),
      ),
    );
  }
}
