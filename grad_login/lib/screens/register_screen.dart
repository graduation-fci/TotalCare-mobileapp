// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:grad_login/screens/login_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/authService.dart';

class RegisterFormScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final Map<String, dynamic> _authData = {
    'username': '',
    'password': '',
    'first_name': '',
    'last_name': '',
    'phone_number': '',
    'email': '',
  };
  Locale? locale;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

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

  bool visible = true;

  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  // void loginNav(BuildContext context) {
  void register(BuildContext context) {
    // if (passwordController.text == rePasswordController.text) {
    //   print(emailController.text);
    //   print(firstNameController.text);
    //   print(lastNameController.text);
    //   print(userNameController.text);
    //   print(mobileController.text);
    //   print(birthDateController.text);
    //   print(passwordController.text);
    //   print(rePasswordController.text);
    // } else {
    //   print('Passwords are not Identical!');
    // }
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    String countryName = appLocalization.countryName;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * 0.13,
                    vertical: mediaQuery.height * 0.08),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/TotalCare.png',
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(appLocalization.email)),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onEditingComplete: () {
                        firstNameFocus.requestFocus();
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.emailNotEmpty;
                        } else if (!value.contains(r'\w+@\w+.\w+')) {
                          return appLocalization.invalidEmail;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(MdiIcons.email),
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: appLocalization.email,
                        labelStyle: labelStyle(),
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(appLocalization.firstName)),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      onEditingComplete: () => lastNameFocus.requestFocus(),
                      focusNode: firstNameFocus,
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        _authData['first_name'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.firstNameNotEmpty;
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.account_box),
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: appLocalization.firstName,
                        labelStyle: labelStyle(),

                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(appLocalization.lastName)),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      onEditingComplete: () => userNameFocus.requestFocus(),
                      focusNode: lastNameFocus,
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        _authData['last_name'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.lastNameNotEmpty;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.account_box),
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: appLocalization.firstName,
                        labelStyle: labelStyle(),

                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(appLocalization.username)),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      focusNode: userNameFocus,
                      onEditingComplete: () => countryFocus.requestFocus(),
                      controller: userNameController,
                      onSaved: (value) {
                        _authData['username'] = value;
                      },
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.usernameNotEmpty;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_add_alt_1),
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: appLocalization.username,
                        labelStyle: labelStyle(),

                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(appLocalization.country)),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                      alignment: Alignment.lerp(
                          Alignment.bottomRight, Alignment.center, 2.1),
                      child: TextButton.icon(
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
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(appLocalization.phoneNumber),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      onEditingComplete: () => passwordFocus.requestFocus(),
                      controller: mobileController,
                      focusNode: phoneFocus,
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        _authData['phone_number'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.phoneNumberNotEmpty;
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        contentPadding: const EdgeInsets.all(5),
                        border: const OutlineInputBorder(),
                        labelText: appLocalization.phoneNumber,
                        labelStyle: labelStyle(),

                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    // Container(
                    //     alignment: Alignment.topLeft,
                    //     child: const Text('Birth Date')),
                    // SizedBox(
                    //   height: mediaQuery.height * 0.02,
                    // ),
                    // // IconButton(
                    // //     onPressed: () {
                    // //       showDatePicker(
                    // //           context: context,
                    // //           initialDate: DateTime.now(),
                    // //           firstDate: DateTime(1950),
                    // //           lastDate: DateTime.now());
                    // //     },
                    // //     icon: const Icon(Icons.date_range_outlined)),
                    // TextFormField(
                    // onEditingComplete: () => firstNameFocus.requestFocus(),
                    //   // controller: birthDateController,
                    //   keyboardType: TextInputType.datetime,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Birth Date Cannot be Empty!';
                    //     }
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20.0)),
                    //     labelText: 'Enter Your Date of Birth',
                    //     // focusedBorder: OutlineInputBorder(),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: mediaQuery.height * 0.02,
                    // ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(appLocalization.password)),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      onEditingComplete: () => rePasswordFocus.requestFocus(),
                      focusNode: passwordFocus,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.passwordNotEmpty;
                        } else if (!value.contains(RegExp(
                            r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&~*]).{8,}$'))) {
                          return '''Password must be atleast 8 characters, 
include an uppercase letter, number and symbol''';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                      obscureText: visible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            visible = !visible;
                            setState(() {});
                          },
                          icon: visible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: appLocalization.password,
                        labelStyle: labelStyle(),

                        //hintText: 'password',
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(appLocalization.confirmPassword)),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      focusNode: rePasswordFocus,
                      // controller: rePasswordController,
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalization.confirmPasswordNotEmpty;
                        } else if (value != passwordController.value.text) {
                          return appLocalization.confirmPasswordIdentical;
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            visible = !visible;
                            setState(() {});
                          },
                          icon: visible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: appLocalization.confirmPassword,
                        labelStyle: labelStyle(),

                        // focusedBorder: const OutlineInputBorder(),
                      ),
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
                      onPressed: () => register(context),
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
                                    Provider.of<AuthService>(context,
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
    );
  }
}
