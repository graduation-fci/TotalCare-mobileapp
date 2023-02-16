import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../screens/login_style.dart';
import '../screens/register.dart';
import '../screens/exams_screen.dart';
import './providers/examService.dart';
import './providers/userService.dart';
import './providers/authService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UserService(),
        ),
        ChangeNotifierProvider.value(
          value: AuthService(),
        ),
        ChangeNotifierProvider.value(
          value: ExamService(),
        ),
      ],
      child: MaterialApp(
        title: 'first demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(2, 0, 105, 0.85),
          secondary: const Color.fromRGBO(167, 252, 132, 0.7),
        )),
        home: Login(),
        routes: {
          Login.routeName: (ctx) => const Login(),
          RegisterFormScreen.routeName: (ctx) => RegisterFormScreen(),
          ExamsScreen.routeName: (ctx) => const ExamsScreen(),
        },
      ),
    );
  }
}
