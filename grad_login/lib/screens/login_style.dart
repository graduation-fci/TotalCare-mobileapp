// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/input_field.dart';
import '../providers/authService.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var visible = true;
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var mainTopPadding =
        AppBar().preferredSize.height + mediaQuery.size.height * 0.07;
    // var materialCommunityIcons;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Padding(
                  padding: EdgeInsets.only(
                    top: mainTopPadding,
                    left: mediaQuery.size.width * 0.05,
                    right: mediaQuery.size.width * 0.05,
                  ),
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
                          "sign in",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      InputField(
                        nameController: nameController,
                        labelText: 'Username',
                        isPassword: false,
                      ),
                      InputField(
                        nameController: nameController,
                        labelText: 'Password',
                        isPassword: true,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'forget Password',
                        ),
                      ),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () {
                              Provider.of<AuthService>(context, listen: false)
                                  .login(nameController.text,
                                      passwordController.text, context);
                              Provider.of<AuthService>(context, listen: false)
                                  .getExams();
                            },
                          )),
                      Column(
                        children: [
                          const Text('OR Sign up with'),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      // primary: Colors.white,
                                      // backgroundColor: palette.googleColor,
                                      minimumSize: const Size(300, 50),
                                      side: const BorderSide(
                                        width: 2,
                                        color: Color.fromARGB(255, 222, 33, 80),
                                      )),
                                  child: Row(
                                    children: [
                                      // Icon(
                                      //   MaterialCommunityIcons.google,
                                      // ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Google')
                                    ],
                                  )),
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            )),
      ),
    );
  }
}
