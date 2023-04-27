import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final Function(String?)? onSaved;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  bool? passwordVis;
  bool obsecureText;

  InputField({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    required this.obsecureText,
    this.onSaved,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.passwordVis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onEditingComplete: () {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        obscureText: obsecureText,
        focusNode: focusNode,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
