import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

class DateSelector extends StatefulWidget {
  final BuildContext context;
  final TextEditingController dateController;
  final User userData;
  final dynamic validator;

  String? selectdate;
  Color? backColor;

  DateSelector({
    super.key,
    this.selectdate,
    this.backColor,
    this.validator,
    required this.userData,
    required this.context,
    required this.dateController,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  String? dataString;
  void _presentDatePicker(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dataString = DateFormat('yyyy-MM-dd').format(pickedDate);
        dataString = dataString!.substring(0, 10);
        widget.selectdate = dataString;
        widget.dateController.text = dataString!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color containerFillColor = Colors.grey.shade100;
    Color labelColor = Colors.grey;

    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 25,
                offset: const Offset(0, 10),
                color: Colors.grey.withOpacity(0.25),
              )
            ]),
            child: TextFormField(
              controller: widget.dateController,
              cursorColor: labelColor,
              validator: (_) {
                if (widget.selectdate != null) {
                  widget.userData.birthDate = widget.selectdate;
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: widget.backColor ?? containerFillColor,
                filled: true,
                labelText:
                    widget.selectdate == null ? 'Birth date' : 'Picked Date',
                labelStyle: TextStyle(color: labelColor),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  onPressed: () => _presentDatePicker(widget.context),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              readOnly: true,
              onTap: () => _presentDatePicker(widget.context),
            ),
          ),
        ),
      ],
    );
  }
}
