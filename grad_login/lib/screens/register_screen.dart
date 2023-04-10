// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/examProvider.dart';
import '../providers/authProvider.dart';

import '.././screens/login_screen.dart';
import '.././screens/exams_screen.dart';
import '.././models/user.dart';
import '../widgets/custom_text_form_field.dart';

class RegisterFormScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final User _userData = User(
    username: '',
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    profile_type: 'STD',
  );
  Locale? locale;

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

  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  // void loginNav(BuildContext context) {
  void register() {
    // if (formKey.currentState!.validate()) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Processing Data')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final authResponse = Provider.of<AuthProvider>(context);
    final examResponse = Provider.of<ExamProvider>(context);
    String countryName = appLocalization.countryName;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width * 0.13,
                      vertical: mediaQuery.height * 0.08),
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
                      Text(
                        appLocalization.email,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: appLocalization.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(MdiIcons.email),
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
                      Text(appLocalization.firstName),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: appLocalization.firstName,
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.account_box),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalization.firstNameNotEmpty;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userData.firstName = value!;
                        },
                        focusNode: firstNameFocus,
                        nextFocusNode: lastNameFocus,
                        textInputAction: TextInputAction.next,
                        obsecureText: false,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      Text(appLocalization.lastName),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: appLocalization.lastName,
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.account_box),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalization.lastNameNotEmpty;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userData.lastName = value!;
                        },
                        focusNode: lastNameFocus,
                        nextFocusNode: userNameFocus,
                        textInputAction: TextInputAction.next,
                        obsecureText: false,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      Text(appLocalization.username),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: appLocalization.username,
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.person_add_alt_1),
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
                      Text(appLocalization.country),
                      TextButton.icon(
                        focusNode: countryFocus,
                        label: Text(countryName),
                        onPressed: () => showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            country.flagEmoji;
                            mobileController.text = '+${country.phoneCode}';
                            countryName =
                                '${country.flagEmoji}  ${country.name}';
                            phoneFocus.requestFocus();
                            setState(() {});
                          },
                        ),
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      Text(appLocalization.phoneNumber),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: appLocalization.phoneNumber,
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalization.phoneNumberNotEmpty;
                          }
                          return null;
                        },
                        // onSaved: (value) {
                        //   _userData.phone = value!;
                        // },
                        focusNode: phoneFocus,
                        nextFocusNode: passwordFocus,
                        textInputAction: TextInputAction.next,
                        obsecureText: false,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      Text(appLocalization.password),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: appLocalization.password,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalization.passwordNotEmpty;
                          } else if (value.contains(RegExp(
                              r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&~*]).{8,}$'))) {
                            return '''Password must be atleast 8 characters, 
        include an uppercase letter, number and symbol''';
                          }
                          return null;
                        },
                        // onSaved: (value) {
                        //   _userData.phone = value!;
                        // },
                        obsecureText: passwordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            passwordVisible = !passwordVisible;
                            setState(() {});
                          },
                          icon: passwordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        focusNode: passwordFocus,
                        nextFocusNode: rePasswordFocus,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      Text(appLocalization.confirmPassword),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      CustomTextFormField(
                        labelText: appLocalization.password,
                        controller: rePasswordController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalization.confirmPasswordNotEmpty;
                          } else if (value != passwordController.value.text) {
                            return appLocalization.confirmPasswordIdentical;
                          }
                          return null;
                        },
                        // onSaved: (value) {
                        //   _userData.phone = value!;
                        // },
                        obsecureText: rePasswordVisible,
                        focusNode: rePasswordFocus,
                        nextFocusNode: rePasswordFocus,
                        suffixIcon: IconButton(
                          onPressed: () {
                            rePasswordVisible = !rePasswordVisible;
                            setState(() {});
                          },
                          icon: rePasswordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.03,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            fixedSize: MaterialStateProperty.all(Size(
                                mediaQuery.width * 0.77,
                                mediaQuery.height * 0.06)),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                        onPressed: () => {
                          if (formKey.currentState!.validate())
                            {
                              formKey.currentState!.save(),
                              log('$_userData'),
                              authResponse
                                  .register(_userData)
                                  .then((_) => authResponse.login(
                                      username: _userData.username,
                                      password: _userData.password))
                                  .then((_) => {
                                        examResponse.getExams(),
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                ExamsScreen.routeName),
                                      }),
                            },
                        },
                        child: Text(
                          appLocalization.register,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                appLocalization.signInWithGoogle,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
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
                          Text(appLocalization.alreadyHaveAnAccount),
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
                              child: Text(appLocalization.login))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
