import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'infrastructure/shared/storage.dart';
import 'providers/addressProvider.dart';
import 'providers/cartProvider.dart';
import 'providers/categoriesProvider.dart';
import 'providers/drugProvider.dart';
import 'providers/userProvider.dart';
import 'providers/interactionsProvider.dart';
import 'providers/medicineProvider.dart';
import 'providers/authProvider.dart';
import 'providers/orders_provider.dart';
import 'providers/wishProvider.dart';

import 'screens/cart_screen.dart';
import 'screens/product_search_screen.dart';
import 'screens/sub_categories_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/add_medication.dart';
import 'screens/edit_medication.dart';
import 'screens/user_medications.dart';
import 'screens/show_interactions_results_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/add_address_screen.dart';
import 'screens/edit_address_screen.dart';
import 'screens/address_detail_screen.dart';
import 'screens/address_screen.dart';
import 'screens/drug_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/medicine_screen.dart';
import 'screens/show_medication_profile_details.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/my_orders_screen.dart';
import 'screens/continue_register_screen.dart';
import 'screens/wish_list_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/singe_order_screen.dart';
import 'widgets/language_Constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  final storage = Storage();
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

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
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: OrdersProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Wish(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        title: 'TotalCare',
        theme: _buildThemeData(),
        home: FutureBuilder(
          future: storage.getToken(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              List<String> parts = snapshot.data!.split('.');
              String payload = parts[1];
              while (payload.length % 4 != 0) {
                payload += '=';
              }
              Map<String, dynamic> data =
                  json.decode(utf8.decode(base64Url.decode(payload)));

              Provider.of<UserProvider>(context).userProfileData = data;
              return const TabsScreen();
            } else {
              // User is not logged in, navigate to the login screen
              return const LoginScreen();
            }
          },
        ),
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
          ShowMedicationProfile.routeName: (ctx) =>
              const ShowMedicationProfile(),
          Profiles.routeName: (ctx) => const Profiles(),
          EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
          MyOrdersScreen.routeName: (context) => const MyOrdersScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          ContinueRegisterScreen.routeName: (context) =>
              const ContinueRegisterScreen(),
          SingleOrderScreen.routeName: (context) => const SingleOrderScreen(),
          SubCategoriesScreen.routeName: (context) =>
              const SubCategoriesScreen(),
          WishListScreen.routeName: (context) => const WishListScreen(),
          ProductSearchScreen.routeName: (context) =>
              const ProductSearchScreen(),
          NotificationsScreen.routeName: (context) =>
              const NotificationsScreen(),
        },
      ),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      fontFamily: 'Heebo',
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFFC5EEFF),
        secondary: const Color(0xFF003745),
      ),
      primaryTextTheme: TextTheme(
        titleLarge: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
        ),
        bodySmall: TextStyle(
          color: Colors.grey.shade800,
        ),
      ),
      textTheme: const TextTheme(
        button: TextStyle(
          fontFamily: 'NotoSans',
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
          color: Color(0xFF003745),
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        elevation: 1,
      ),
    );
  }
}
