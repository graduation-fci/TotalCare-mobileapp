import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grad_login/widgets/blood_type_field.dart';
import 'package:grad_login/widgets/date_selector.dart';
import 'package:grad_login/widgets/mobile_number_field.dart';
import 'package:grad_login/widgets/sign_button.dart';

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
  DateTime? selecteddate;

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

    String countryName = appLocalization.countryName;

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
              onPressed: () {},
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BloodTypeInput(
                bloodTypeController: bloodTypeController,
                bloodTypes: bloodTypes,
              ),
              const MobileNumberField(),
              DateSelector(context: context),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20),
          child: SignButton(
            mediaQuery: mediaQuery,
            onPressed: () => onPressed(),
            label: appLocalization.register,
          ),
        ),
      ),
    );
  }

  onPressed() {}
}
