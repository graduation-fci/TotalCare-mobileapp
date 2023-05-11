import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../providers/userProvider.dart';
import '../providers/authProvider.dart';
import '../screens/tabs_screen.dart';
import 'error_dialog_box.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final MediaQueryData mediaQuery;

  const LoginButton({
    super.key,
    required this.nameController,
    required this.passwordController,
    required this.formKey,
    required this.mediaQuery,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.appState != AppState.loading) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          fixedSize: Size(
            mediaQuery.size.width * 0.85,
            mediaQuery.size.height * 0.06,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            await authProvider
                .login(
                    username: nameController.text,
                    password: passwordController.text)
                .then((_) {
              if (authProvider.appState == AppState.error) {
                showAlertDialog(
                  context: context,
                  content: authProvider.errorMessage!,
                  confirmButtonText: 'Dismiss',
                );
                return;
              }
            }).then((_) async {
              if (authProvider.appState == AppState.done) {
                await userProvider.getUserProfile().then((value) {
                  userProvider.getUserMedications();
                  Navigator.of(context).pushReplacementNamed(
                    TabsScreen.routeName,
                  );
                });
              }
            });
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Text(
          appLocalization.login,
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(fontSize: mediaQuery.size.width * 0.038),
        ),
      );
    }

    return Container();
  }
}
