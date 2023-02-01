import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  var visible = true;
  @override
  Widget build(BuildContext context) {
    // var materialCommunityIcons;
    return Scaffold(
        appBar: AppBar(
          title: Text('login'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: const Text(
                      'Total Care',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "sign in",
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: 'UserName',
                      // labelStyle:
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: visible,
                    controller: PasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              visible = !visible;
                              setState(() {});
                            },
                            icon: visible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility))),
                  ),
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
                      child: const Text('Login'),
                      onPressed: () {
                        print(nameController.text);
                        print(PasswordController.text);
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
                                    borderRadius: BorderRadius.circular(40)),
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
            )));
  }
}
