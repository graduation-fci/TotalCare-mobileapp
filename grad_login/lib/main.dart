import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'first demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 22, 36, 66),
          secondary: const Color.fromRGBO(167, 252, 132, 0.7),
        )),
        home: const LoginScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          RegisterFormScreen.routeName: (ctx) => RegisterFormScreen(),
          ExamsScreen.routeName: (ctx) => const ExamsScreen(),
        },
      ),
    );
  }
}
