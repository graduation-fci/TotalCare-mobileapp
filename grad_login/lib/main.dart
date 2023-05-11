import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'providers/addressProvider.dart';
import 'providers/categoriesProvider.dart';
import 'providers/drugProvider.dart';
import 'providers/userProvider.dart';
import 'providers/categories.dart';
import 'providers/interactionsProvider.dart';
import 'providers/medicineProvider.dart';
import 'providers/authProvider.dart';
import 'screens/tabs_screen.dart';
import 'screens/add_medication.dart';
import 'screens/edit_medication.dart';
import 'screens/user_medications.dart';
import 'screens/show_interactions_results_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/add_address_screen.dart';
import 'screens/edit_address_screen.dart';
import 'screens/edit_user_details_screen.dart.dart';
import 'screens/address_detail_screen.dart';
import 'screens/address_screen.dart';
import 'screens/drug_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/medicine_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
        ChangeNotifierProvider.value(
          value: Drugs(),
        ),
        ChangeNotifierProvider.value(
          value: Address(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
          EditMedicationScreen.routeName: (ctx) => const EditMedicationScreen(),
          AddMedicationScreen.routeName: (ctx) => const AddMedicationScreen(),
          RegisterFormScreen.routeName: (ctx) => const RegisterFormScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          MedicinesScreen.routeName: (context) => const MedicinesScreen(),
          DrugDetailScreen.routeName: (context) => const DrugDetailScreen(),
          AddAddressScreen.routeName: (context) => const AddAddressScreen(),
          EditAddressScreen.routeName: (context) => const EditAddressScreen(),
          AddressScreen.routeName: (context) => const AddressScreen(),
          AddressDetailScreen.routeName: (context) =>
              const AddressDetailScreen(),
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
          fontFamily: 'Heebo',
          color: Color(0xFF003745),
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        elevation: 1,
      ),
    );
  }
}
