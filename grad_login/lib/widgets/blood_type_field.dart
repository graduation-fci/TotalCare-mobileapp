import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/user.dart';

class BloodTypeInput extends StatefulWidget {
  final List bloodTypes;
  final TextEditingController bloodTypeController;
  User? user;

  BloodTypeInput({
    super.key,
    required this.bloodTypes,
    required this.bloodTypeController,
    this.user,
  });

  @override
  State<BloodTypeInput> createState() => _BloodTypeInputState();
}

class _BloodTypeInputState extends State<BloodTypeInput> {
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    Color containerFillColor = Colors.grey.shade100;
    Color labelColor = Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.35),
            offset: const Offset(0, 10),
            blurRadius: 25,
          ),
        ],
      ),
      child: DropdownButtonFormField(
        icon: Icon(
          Icons.arrow_drop_down_circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        menuMaxHeight: 200,
        elevation: 0,
        isExpanded: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Blood Type',
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          filled: true,
          fillColor: containerFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items: widget.bloodTypes.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            widget.bloodTypeController.text = value!.toString();
          });
        },
        validator: (value) {
          widget.user?.bloodType = value.toString();
        },
      ),
    );
  }
}
