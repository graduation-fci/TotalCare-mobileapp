import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grad_login/providers/categories.dart';

import 'providers/interactionsProvider.dart';
import 'providers/medicineProvider.dart';
import 'providers/authProvider.dart';
import 'providers/userProvider.dart';
import 'screens/tabs_screen.dart';
import 'screens/user_medications.dart';
import 'screens/show_interactions_results_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

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
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: MedicineProvider(),
        ),
        ChangeNotifierProvider.value(
          value: InteractionsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Categories(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'first demo',
        theme: _buildThemeData(),
        home: const LoginScreen(),
        routes: {
          ShowInteractionsResultsScreen.routeName: (ctx) =>
              const ShowInteractionsResultsScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          UserMedicationsScreen.routeName: (ctx) =>
              const UserMedicationsScreen(),
          RegisterFormScreen.routeName: (ctx) => const RegisterFormScreen(),
          TabsScreen.routeName: (ctx) => const TabsScreen(),
        },
      ),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFFC5EEFF),
        secondary: const Color(0xFF003745),
      ),
      primaryTextTheme: TextTheme(
        titleLarge: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 32,
        ),
        titleMedium: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        bodySmall: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 12,
        ),
      ),
      textTheme: const TextTheme(
        button: TextStyle(
          fontFamily: 'NotoSans',
          fontSize: 14,
          color: Color(0xFF003B4A),
        ),
        headlineLarge: TextStyle(
          fontFamily: 'NotoSans',
          fontSize: 16,
          color: Color(0xFF003B4A),
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'Anton-Regular',
          color: Color(0xFF003745),
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        elevation: 1,
      ),
    );
  }
}
