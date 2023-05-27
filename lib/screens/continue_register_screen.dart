import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/user.dart';
import '../widgets/blood_type_field.dart';
import '../widgets/date_selector.dart';
import '../widgets/error_dialog_box.dart';
import '../widgets/mobile_number_field.dart';
import '../widgets/sign_button.dart';
import '../providers/userProvider.dart';
import '../providers/authProvider.dart';
import '../screens/home_screen.dart';
import '../screens/tabs_screen.dart';

class ContinueRegisterScreen extends StatefulWidget {
  static const String routeName = 'cont-registeration';
  const ContinueRegisterScreen({super.key});

  @override
  State<ContinueRegisterScreen> createState() => _ContinueRegisterScreenState();
}

class _ContinueRegisterScreenState extends State<ContinueRegisterScreen> {
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  Color containerFillColor = Colors.grey.shade200;
  Color labelColor = Colors.grey;
  FocusNode countryFocus = FocusNode();
  String? selectedDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    bloodTypeController.dispose();
    phoneNumberController.dispose();
    birthDateController.dispose();
    countryController.dispose();
    super.dispose();
  }

  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appLocalization = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userData = ModalRoute.of(context)!.settings.arguments as User;

    void onPressed(authProvider, userProvider) async {
      if (_formKey.currentState!.validate()) {
        await authProvider.patientProfile(userData).then((_) {
          if (authProvider.appState == AppState.error) {
            showAlertDialog(
              context: context,
              content: authProvider.errorMessage!,
              confirmButtonText: 'Dismiss',
              onConfirmPressed: () => Navigator.pop(context),
              title: 'Oops something went wrong...',
            );
            return;
          }
        }).then((_) async {
          if (authProvider.appState == AppState.done) {
            userProvider.getUserMedications();
            Navigator.of(context).pushReplacementNamed(
              TabsScreen.routeName,
            );
          }
        });
      }
      FocusManager.instance.primaryFocus?.unfocus();
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Finish up Registration',
            style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                  fontSize: 18,
                ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BloodTypeInput(
                  bloodTypeController: bloodTypeController,
                  bloodTypes: bloodTypes,
                  user: userData,
                ),
                MobileNumberField(
                  countryController: countryController,
                  phoneController: phoneNumberController,
                  user: userData,
                  validator: (value) {
                    if (value != null) {
                      userData.phoneNumber = countryController.text + value;
                    }
                    return null;
                  },
                ),
                DateSelector(
                  userData: userData,
                  context: context,
                  selectdate: selectedDate,
                  dateController: birthDateController,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20),
          child: SignButton(
            mediaQuery: mediaQuery,
            onPressed: () => onPressed(authProvider, userProvider),
            label: appLocalization.register,
          ),
        ),
      ),
    );
  }
}
