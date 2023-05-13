import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final BuildContext context;
  const DateSelector({
    super.key,
    required this.context,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime? selectdate;

  void _presentDatePicker(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectdate) {
      setState(() {
        selectdate = pickedDate;
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
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              cursorColor: labelColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: containerFillColor,
                filled: true,
                labelText: selectdate == null
                    ? 'No Date Chosen!'
                    : 'Picked Date: ${DateFormat.yMd().format(selectdate!)}',
                labelStyle: TextStyle(color: labelColor),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
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
