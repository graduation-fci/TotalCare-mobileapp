import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_state.dart';
import '../providers/authProvider.dart';
import '../providers/medicineProvider.dart';
import '../screens/tabs_screen.dart';

class LoginButton extends StatelessWidget {
  final AuthProvider authResponse;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final MedicineProvider examResponse;
  final MediaQueryData mediaQuery;

  const LoginButton({
    super.key,
    required this.authResponse,
    required this.nameController,
    required this.passwordController,
    required this.formKey,
    required this.examResponse,
    required this.mediaQuery,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    if (authResponse.appState != AppState.loading) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          fixedSize: Size(
            mediaQuery.size.width * 0.85,
            mediaQuery.size.height * 0.06,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            authResponse
                .login(
                    username: nameController.text,
                    password: passwordController.text)
                .then((_) {
              if (authResponse.appState == AppState.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authResponse.errorMessage!)));
              }
            }).then((_) => {
                      if (authResponse.appState == AppState.done)
                        examResponse.getMedicines(),
                      Navigator.of(context)
                          .pushReplacementNamed(TabsScreen.routeName),
                    });
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Text(
          appLocalization.login,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      );
    }

    return Container();
  }
}
