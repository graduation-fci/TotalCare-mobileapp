import 'package:flutter/material.dart';
import 'package:grad_login/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';

import './register_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/sign-in';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return !Provider.of<AuthProvider>(context).isRegister
        ? const LoginScreen()
        : const RegisterFormScreen();
  }
}
