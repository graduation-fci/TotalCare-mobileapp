// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController nameController;
  final String labelText;
  var isPassword = false;

  InputField({
    required this.nameController,
    required this.labelText,
    required this.isPassword,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  var visible = true;

  @override
  Widget build(BuildContext context) {
    return widget.isPassword
        ? Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Opacity(
              opacity: 0.7,
              child: TextField(
                obscureText: visible,
                controller: widget.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: widget.labelText,
                  suffixIcon: IconButton(
                    onPressed: () {
                      visible = !visible;
                      setState(() {});
                    },
                    icon: visible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: Opacity(
              opacity: 0.7,
              child: TextField(
                controller: widget.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: widget.labelText,
                  // labelStyle: TextStyle(fontStyle: )
                  // labelStyle:
                ),
              ),
            ),
          );
  }
}
