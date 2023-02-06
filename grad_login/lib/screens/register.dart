// ignore_for_file: avoid_print

// import 'package:final_project/login.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RegisterFormScreen extends StatelessWidget {
  final Map<String, dynamic> _authData = {
    'username': '',
    'password': '',
    'first_name': '',
    'last_name': '',
    'phone_number': '',
    'email': '',
  };
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController firstNameController = TextEditingController();
  // final TextEditingController lastNameController = TextEditingController();
  // final TextEditingController userNameController = TextEditingController();
  // final TextEditingController mobileController = TextEditingController();
  // final TextEditingController birthDateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController rePasswordController = TextEditingController();

  static const routeName = '/register';

  final formKey = GlobalKey<FormState>();

  RegisterFormScreen({super.key});

  // void loginNav(BuildContext context) {
  //   Navigator.of(context).pushNamed(LoginFormScreen.routeName);
  // }

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
                    Image.asset(
                      'assets/images/TotalCare.png',
                    ),

                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Email')),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      //make autofocus: true after completion
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
                        _authData['email'] = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Enter Your Email Account',
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('First Name')),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      // controller: firstNameController,
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        _authData['first_name'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First Name Cannot be Empty!';
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Your First Name',
                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Last Name')),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      // controller: lastNameController,
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        _authData['last_name'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last Name Cannot be Empty!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Your Last Name',
                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Username')),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      // controller: userNameController,
                      onSaved: (value) {
                        _authData['username'] = value;
                      },
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username Should not be Empty!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'What Should We Call You?',
                        // focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Phone Number')),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    TextFormField(
                      // controller: mobileController,
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        _authData['phone_number'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number Cannot be Empty!';
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Your Phone Number',
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
                        child: const Text('Password')),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
                        _authData['password'] = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Your Password',
                        //hintText: 'password',
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text('Confirm Your Password')),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Confirm Your Password',
                        // focusedBorder: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      onPressed: () => register(context),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 18, letterSpacing: 2),
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
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: TextButton.icon(
                        label: const Text(
                          'Sign up using Facebook',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          MdiIcons.facebook,
                          size: 34,
                          color: Color(0xff3E529C),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    Container(
                      alignment: Alignment.lerp(
                          Alignment.bottomRight, Alignment.bottomCenter, 1.11),
                      child: TextButton.icon(
                        label: const Text(
                          'Sign up using Google',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                        icon: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color(0xffEC2D2F)),
                          child: const Icon(
                            MdiIcons.google,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.02,
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
