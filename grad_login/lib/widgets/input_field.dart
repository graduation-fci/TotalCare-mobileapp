// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController nameController;
  final String labelText;
  final IconData prefixIcon;
  var isPassword = false;

  InputField({
    required this.nameController,
    required this.labelText,
    required this.isPassword,
    required this.prefixIcon,
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
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              obscureText: visible,
              controller: widget.nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '${widget.labelText} is required.';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                  icon: visible
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                          size: 22,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                          size: 22,
                        ),
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: widget.nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '${widget.labelText} is required.';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.all(5),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: Colors.grey,
                ),
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          );
  }
}
