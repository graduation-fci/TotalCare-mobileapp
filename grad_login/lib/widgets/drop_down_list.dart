import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final Map<String, String> items;
  final Function(String) onChanged;

  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  late String _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.items.entries.first.key;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          _dropdownValue = newValue!;
        });
        widget.onChanged(newValue!);
      },
      items: widget.items.entries
          .map<DropdownMenuItem<String>>((MapEntry<String, String> entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
    );
  }
}
