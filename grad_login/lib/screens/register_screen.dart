// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/widgets/error_dialog_box.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_state.dart';
import '../providers/medicineProvider.dart';
import '../providers/authProvider.dart';

import '../screens/tabs_screen.dart';
import '../screens/login_screen.dart';

import '../models/user.dart';

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
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
  String? _selectedItem;

  final formKey = GlobalKey<FormState>();
  // final Map<String, String> _dropDownItems = {
  //   'PAT': 'Patient',
  //   'DOC': 'Doctor'
  // };

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final authResponse = Provider.of<AuthProvider>(context);
    final medicineResponse = Provider.of<MedicineProvider>(context);
    String countryName = appLocalization.countryName;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width * 0.05,
                  vertical: mediaQuery.height * 0.08,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/TotalCare.png',
                        height: mediaQuery.height * 0.2,
                        width: mediaQuery.height * 0.2,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
                      nextFocusNode: countryFocus,
                      textInputAction: TextInputAction.next,
                      obsecureText: false,
                    ),

                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
                      height: mediaQuery.height * 0.02,
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
                      nextFocusNode: userNameFocus,
                      textInputAction: TextInputAction.next,
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
                      nextFocusNode: firstNameFocus,
                      textInputAction: TextInputAction.next,
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    // Container(
                    //   margin: const EdgeInsets.all(10),
                    //   width: mediaQuery.width,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.grey,
                    //       width: 1,
                    //     ),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       IconButton(
                    //         focusNode: countryFocus,
                    //         onPressed: () => showCountryPicker(
                    //           context: context,
                    //           showPhoneCode: true,
                    //           onSelect: (Country country) {
                    //             country.flagEmoji;
                    //             countryController.text =
                    //                 '+${country.phoneCode}';
                    //             countryName =
                    //                 '${country.flagEmoji}  ${country.name}';
                    //             setState(() {});
                    //           },
                    //         ),
                    //         icon: const Icon(
                    //           Icons.arrow_drop_down,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       countryController.text.isEmpty
                    //           ? const Text('---')
                    //           : TextFormField(
                    //               controller: countryController,
                    //               decoration: const InputDecoration(
                    //                 // contentPadding: EdgeInsets.only(left: 18),
                    //                 border: InputBorder.none,
                    //               ),
                    //               enabled: false,
                    //             ),
                    //       Expanded(
                    //         child: TextFormField(
                    //           controller: mobileController,
                    //           focusNode: phoneFocus,
                    //           onEditingComplete: () {
                    //             if (passwordFocus != null) {
                    //               FocusScope.of(context)
                    //                   .requestFocus(passwordFocus);
                    //             }
                    //           },
                    //           textInputAction: TextInputAction.next,
                    //           keyboardType: TextInputType.phone,
                    //           decoration: InputDecoration(
                    //             contentPadding:
                    //                 const EdgeInsets.fromLTRB(20, 5, 5, 5),
                    //             labelText: appLocalization.phoneNumber,
                    //             labelStyle: const TextStyle(color: Colors.grey),
                    //             border: InputBorder.none,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                          return '''Password must contain:
     - at least one uppercase letter
     - at least one lowercase letter
     - at least one number
     - at least one special character
     - at least 8 characters''';
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
                      height: mediaQuery.height * 0.02,
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
                      height: mediaQuery.height * 0.02,
                    ),

                    // select profile type

                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 18,
                    //     // vertical: 12,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.grey, width: 1),
                    //     borderRadius: BorderRadius.circular(40),
                    //   ),
                    //   child: DropdownButtonFormField<String>(
                    //     decoration: const InputDecoration(
                    //       border: InputBorder.none,
                    //     ),
                    //     onSaved: ((value) => _userData.profileType = value!),
                    //     hint: const Text(
                    //       'Select ...',
                    //       style: TextStyle(fontSize: 14),
                    //     ),
                    //     value: _selectedItem,
                    //     items: _dropDownItems.entries
                    //         .map<DropdownMenuItem<String>>((value) {
                    //       return DropdownMenuItem(
                    //         value: value.key,
                    //         child: Text(value.value),
                    //       );
                    //     }).toList(),
                    //     onChanged: (newValue) {
                    //       setState(() {
                    //         _selectedItem = newValue;
                    //       });
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        fixedSize: Size(
                          mediaQuery.width * 0.85,
                          mediaQuery.height * 0.06,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () =>
                          regBtn(authResponse, medicineResponse, context),
                      child: Text(
                        appLocalization.register,
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontSize: mediaQuery.width * 0.038),
                      ),
                    ),
                    if (authResponse.appState == AppState.loading)
                      const CircularProgressIndicator.adaptive(),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
                          mediaQuery.width * 0.85,
                          mediaQuery.height * 0.06,
                        ),
                        side: const BorderSide(
                          width: 0.8,
                          color: Colors.grey,
                        ),
                      ),
                      child: SizedBox(
                        width: mediaQuery.width * 0.8,
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
                                  .copyWith(fontSize: mediaQuery.width * 0.038),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLocalization.alreadyHaveAnAccount,
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(fontSize: mediaQuery.width * 0.038),
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
                                        fontSize: mediaQuery.width * 0.038),
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

  Future<Set<Set<void>>> regBtn(AuthProvider authResponse,
      MedicineProvider medicineResponse, BuildContext context) async {
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
                        ),
                      }
                  })
              .then((_) => {
                    if (authResponse.appState == AppState.done)
                      {
                        authResponse.login(
                            username: _userData.username,
                            password: _userData.password),
                        medicineResponse.getMedicines(),
                        Navigator.of(context)
                            .pushReplacementNamed(TabsScreen.routeName),
                      }
                  }),
        },
    };
  }
}
