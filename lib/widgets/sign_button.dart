import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../providers/authProvider.dart';

class SignButton extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final VoidCallback onPressed;
  final String label;

  const SignButton({
    super.key,
    required this.mediaQuery,
    required this.onPressed, required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
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
        onPressed: onPressed,
        child: Text(
          label,
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
