// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../infrastructure/shared/storage.dart';
import '../app_state.dart';
import '../providers/userProvider.dart';
import '../providers/medicineProvider.dart';
import '../providers/authProvider.dart';

import 'continue_register_screen.dart';
import 'login_screen.dart';

import '../models/user.dart';

import '../widgets/error_dialog_box.dart';
import '../widgets/sign_button.dart';
import '../widgets/input_field.dart';

class RegisterFormScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final User _userData = User(
    username: '',
    first_name: '',
    last_name: '',
    email: '',
    password: '',
    profileType: 'PAT',
  );
  Locale? locale;
  Storage storage = Storage();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode rePasswordFocus = FocusNode();

  MaterialStateTextStyle labelStyle() {
    return MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
      return const TextStyle(
        fontSize: 14,
      );
    });
  }

  bool passwordVisible = true;
  bool rePasswordVisible = true;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appLocalization = AppLocalizations.of(context)!;
    final authResponse = Provider.of<AuthProvider>(context);
    final medicineResponse = Provider.of<MedicineProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.05,
                  vertical: mediaQuery.size.height * 0.08,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/TotalCare.png',
                        height: mediaQuery.size.height * 0.2,
                        width: mediaQuery.size.height * 0.2,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InputField(
                      labelText: appLocalization.username,
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        Icons.person_add_alt_1,
                        color: Colors.grey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.usernameNotEmpty;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userData.username = value!;
                      },
                      focusNode: userNameFocus,
                      nextFocusNode: firstNameFocus,
                      textInputAction: TextInputAction.next,
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InputField(
                      labelText: appLocalization.firstName,
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(
                        Icons.account_box,
                        color: Colors.grey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.firstNameNotEmpty;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userData.first_name = value!;
                      },
                      focusNode: firstNameFocus,
                      nextFocusNode: lastNameFocus,
                      textInputAction: TextInputAction.next,
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InputField(
                      labelText: appLocalization.lastName,
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(
                        Icons.account_box,
                        color: Colors.grey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.lastNameNotEmpty;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userData.last_name = value!;
                      },
                      focusNode: lastNameFocus,
                      nextFocusNode: emailFocus,
                      textInputAction: TextInputAction.next,
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InputField(
                      labelText: appLocalization.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        MdiIcons.email,
                        color: Colors.grey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.emailNotEmpty;
                        } else if (value.contains(r'\w+@\w+.\w+')) {
                          return appLocalization.invalidEmail;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userData.email = value!;
                      },
                      focusNode: emailFocus,
                      nextFocusNode: passwordFocus,
                      textInputAction: TextInputAction.next,
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InputField(
                      labelText: appLocalization.password,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          print(value);
                          return appLocalization.passwordNotEmpty;
                        }
                        final passwordRegex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                        if (!passwordRegex.hasMatch(value)) {
                          String errorMessage = '';

                          // Check for an uppercase letter
                          if (!RegExp(r'.*?[A-Z]').hasMatch(value)) {
                            errorMessage +=
                                "- Must contain at least one uppercase letter\n";
                          }

                          // Check for a lowercase letter
                          if (!RegExp(r'.*?[a-z]').hasMatch(value)) {
                            errorMessage +=
                                "- Must contain at least one lowercase letter\n";
                          }

                          // Check for a number
                          if (!RegExp(r'.*?[0-9]').hasMatch(value)) {
                            errorMessage +=
                                "- Must contain at least one number\n";
                          }

                          // Check for a special character
                          if (!RegExp(r'.*?[!@#\$&*~]').hasMatch(value)) {
                            errorMessage +=
                                "- Must contain at least one special character\n";
                          }

                          // Check for minimum length
                          if (value.length < 8) {
                            errorMessage +=
                                "- Must be at least 8 characters long\n";
                          }

                          return errorMessage;
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _userData.password = value!;
                      },
                      obsecureText: passwordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          passwordVisible = !passwordVisible;
                          setState(() {});
                        },
                        icon: passwordVisible
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                      ),
                      focusNode: passwordFocus,
                      nextFocusNode: rePasswordFocus,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InputField(
                      labelText: appLocalization.confirmPassword,
                      controller: rePasswordController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.confirmPasswordNotEmpty;
                        } else if (value != passwordController.value.text) {
                          return appLocalization.confirmPasswordIdentical;
                        }
                        return null;
                      },
                      obsecureText: rePasswordVisible,
                      focusNode: rePasswordFocus,
                      nextFocusNode: rePasswordFocus,
                      suffixIcon: IconButton(
                        onPressed: () {
                          rePasswordVisible = !rePasswordVisible;
                          setState(() {});
                        },
                        icon: rePasswordVisible
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    const SizedBox(height: 16),
                    SignButton(
                      mediaQuery: mediaQuery,
                      onPressed: () => regBtn(authResponse, medicineResponse,
                          userProvider, context),
                      label: appLocalization.register,
                    ),
                    if (authResponse.appState == AppState.loading)
                      const CircularProgressIndicator.adaptive(),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    TextButton(
                      onPressed: () {
                        print('tap');
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minimumSize: Size(
                          mediaQuery.size.width * 0.85,
                          mediaQuery.size.height * 0.06,
                        ),
                        side: const BorderSide(
                          width: 0.8,
                          color: Colors.grey,
                        ),
                      ),
                      child: SizedBox(
                        width: mediaQuery.size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google.png',
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              appLocalization.signUpWithGoogle,
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      fontSize: mediaQuery.size.width * 0.038),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLocalization.alreadyHaveAnAccount,
                          style: Theme.of(context).textTheme.button!.copyWith(
                              fontSize: mediaQuery.size.width * 0.038),
                        ),
                        TextButton(
                            onPressed: () => {
                                  Navigator.of(context).pushReplacementNamed(
                                      LoginScreen.routeName),
                                  setState(() {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .isRegister = false;
                                  }),
                                },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                appLocalization.login,
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(
                                        fontSize:
                                            mediaQuery.size.width * 0.038),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Set<Set<void>>> regBtn(
      AuthProvider authResponse,
      MedicineProvider medicineResponse,
      UserProvider userProvider,
      BuildContext context) async {
    return {
      if (formKey.currentState!.validate())
        {
          formKey.currentState!.save(),
          // log('$_userData'),
          await authResponse
              .register(_userData)
              .then((_) => {
                    if (authResponse.appState == AppState.error)
                      {
                        showAlertDialog(
                          context: context,
                          content: authResponse.errorMessage!,
                          confirmButtonText: 'Dismiss',
                          onConfirmPressed: () => Navigator.pop(context),
                          title: 'Oops something went wrong...',
                        ),
                      }
                  })
              .then((_) async {
            if (authResponse.appState == AppState.done) {
              await authResponse.login(
                username: _userData.username,
                password: _userData.password,
              );
            }
          }).then((_) async {
            final token = await storage.getToken();

            List<String> parts = token!.split('.');
            String payload = parts[1];
            while (payload.length % 4 != 0) {
              payload += '=';
            }
            Map<String, dynamic> data =
                json.decode(utf8.decode(base64Url.decode(payload)));

            userProvider.userProfileData = data;
          }).then((_) => Navigator.of(context).pushReplacementNamed(
                    ContinueRegisterScreen.routeName,
                    arguments: _userData,
                  )),
        }
    };
  }
}
