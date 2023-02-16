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
            height: 68,
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: visible,
              controller: widget.nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                labelText: widget.labelText,
                suffixIcon: IconButton(
                  onPressed: () {
                    visible = !visible;
                    setState(() {});
                  },
                  icon: visible
                      ? const Icon(
                          Icons.visibility_off,
                          size: 22,
                        )
                      : Icon(
                          Icons.visibility,
                          color: Colors.black.withOpacity(0.8),
                          size: 22,
                        ),
                ),
              ),
            ),
          )
        : Container(
            height: 68,
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                labelText: widget.labelText,
                // labelStyle: TextStyle(fontStyle: )
                // labelStyle:
              ),
            ),
          );
  }
}
