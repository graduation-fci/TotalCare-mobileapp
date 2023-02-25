// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_state.dart';

import '../providers/examProvider.dart';
import '../providers/authProvider.dart';
import '../widgets/input_field.dart';

import './exams_screen.dart';
import './register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var isActive = false;
  var visible = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  bool isButtonActive() {
    isActive =
        nameController.text.isNotEmpty && passwordController.text.isNotEmpty
            ? true
            : false;
    setState(() {
      isActive;
    });
    return isActive;
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mainTopPadding =
        AppBar().preferredSize.height + mediaQuery.size.height * 0.07;
    final authResponse = Provider.of<AuthProvider>(context);
    final examResponse = Provider.of<ExamProvider>(context);
    final appLocalization = AppLocalizations.of(context)!;
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

    return !Provider.of<AuthProvider>(context).isRegister
        ? SafeArea(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                key: key,
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: EdgeInsets.only(
                    top: mainTopPadding,
                    left: mediaQuery.size.width * 0.05,
                    right: mediaQuery.size.width * 0.05,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Total Care',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            appLocalization.signIn,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        InputField(
                          nameController: nameController,
                          labelText: appLocalization.username,
                          isPassword: false,
                          prefixIcon: Icons.person,
                        ),
                        InputField(
                          nameController: passwordController,
                          labelText: appLocalization.password,
                          isPassword: true,
                          prefixIcon: Icons.lock,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  appLocalization.forgetPassword,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (authResponse.appState != AppState.loading)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              fixedSize: Size(
                                mediaQuery.size.width * 0.85,
                                mediaQuery.size.height * 0.06,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authResponse
                                    .login(
                                        username: nameController.text,
                                        password: passwordController.text)
                                    .then((_) {
                                  if (authResponse.appState == AppState.error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                authResponse.errorMessage!)));
                                  }
                                }).then((_) => {
                                          examResponse.getExams(),
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  ExamsScreen.routeName),
                                        });
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            // isButtonActive()
                            //     ?
                            //     : null,
                            child: Text(
                              appLocalization.login,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        if (authResponse.appState == AppState.loading)
                          CircularProgressIndicator.adaptive(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 36,
                                    ),
                                  ),
                                ),
                                Text(
                                  appLocalization.or,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 36,
                                    ),
                                  ),
                                ),
                              ],
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
                                side: BorderSide(
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      appLocalization.signInWithGoogle,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${appLocalization.dontHaveAnAccount} ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .isRegister = true;
                                      });
                                    },
                                    child: Text(
                                      appLocalization.register,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.9),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : RegisterFormScreen();
  }
}
