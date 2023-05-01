import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final String? labelText;
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
    this.labelText,
    required this.keyboardType,
    required this.validator,
    required this.controller,
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
    return Container(
      margin: const EdgeInsets.all(10),
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
          contentPadding: prefixIcon != null
              ? const EdgeInsets.all(5)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
