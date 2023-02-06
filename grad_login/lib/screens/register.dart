// ignore_for_file: avoid_print

// import 'package:final_project/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userService.dart';
import '../models/user.dart';
import './exams_screen.dart';

class RegisterFormScreen extends StatefulWidget {
  static const routeName = '/register';

  RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  // final Map<String, dynamic> user = {
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var _isLoading = false;

  User user = User(
      username: '',
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      profile_type: '');

  // void loginNav(BuildContext context) {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

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
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<UserService>(context, listen: false)
            .register(user, context);
        Navigator.of(context).pushReplacementNamed(ExamsScreen.routeName);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        //
      }

      // if (formKey.currentState!.validate()) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Processing Data')),
      //   );
      // }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Care',
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Email')),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextFormField(
                      autofocus: false,
                      // controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            !value.contains('@') ||
                            value.isEmpty) {
                          return 'Email Address Should not be Empty!';
                        }
                      },
                      onSaved: (value) {
                        user.email = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Enter Your Email Account',
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('First Name')),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextFormField(
                      // controller: firstNameController,
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        user.firstName = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First Name Cannot be Empty!';
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Your First Name',
                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Last Name')),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextFormField(
                      // controller: lastNameController,
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        user.lastName = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last Name Cannot be Empty!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Your Last Name',
                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Username')),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextFormField(
                      // controller: userNameController,
                      onSaved: (value) {
                        user.username = value!;
                      },
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username Should not be Empty!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'What Should We Call You?',
                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    // Container(
                    //     alignment: Alignment.topLeft,
                    //     child: const Text('Phone Number')),
                    // SizedBox(
                    //   height: mediaQuery.height * 0.01,
                    // ),
                    // TextFormField(
                    //   // controller: mobileController,
                    //   keyboardType: TextInputType.phone,
                    //   onSaved: (value) {
                    //     user['phone_number'] = value;
                    //   },
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Phone Number Cannot be Empty!';
                    //     }
                    //   },
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20.0)),
                    //     labelText: 'Enter Your Phone Number',
                    //     // focusedBorder: OutlineInputBorder(),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: mediaQuery.height * 0.04,
                    // ),
                    // Container(
                    //     alignment: Alignment.topLeft,
                    //     child: const Text('Birth Date')),
                    // SizedBox(
                    //   height: mediaQuery.height * 0.01,
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
                    //   height: mediaQuery.height * 0.04,
                    // ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Password')),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password Should not be Empty!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        user.password = value!;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Your Password',
                        //hintText: 'password',
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Confirm Your Password')),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextFormField(
                      // controller: rePasswordController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password Confirmation Field Cannot be Empty!';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Confirm Your Password',
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          fixedSize: MaterialStateProperty.all(Size(
                              mediaQuery.width * 0.77,
                              mediaQuery.height * 0.08)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white70),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent)),
                      onPressed: () => register(context),
                      child: const Text('Register'),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.04,
                    ),
                    const Divider(),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: mediaQuery.height * 0.07,
                            child: Image.network(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKoBxdc41cpqz-7ipwR7smTudicsd8J0MBKL0yyup1qA&s'),
                          ),
                          const Text('Sign up using Google'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: mediaQuery.height * 0.07,
                            child: Image.network(
                                'https://imgs.search.brave.com/1TdjcfEDQyBphTbyy3o9G7Hznno23ojIcxzQgX536fc/rs:fit:1024:1024:1/g:ce/aHR0cHM6Ly93d3cu/Y2hzaWNhLm9yZy93/cC1jb250ZW50L3Vw/bG9hZHMvMjAyMC8x/MC9GYWNlYm9vay1M/b2dvLVBORy1UcmFu/c3BhcmVudC1MaWtl/LTE3LnBuZw'),
                          ),
                          const Text('Sign up using Facebook'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                            onPressed: () => {}, child: const Text('Login'))
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
