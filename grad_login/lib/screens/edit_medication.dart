import 'package:flutter/material.dart';

class EditMedication extends StatefulWidget {
  static const String routeName = 'edit-medication';
  const EditMedication({super.key});

  @override
  State<EditMedication> createState() => _EditMedicationState();
}

class _EditMedicationState extends State<EditMedication> {
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Map medication = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          medication['title'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.save_alt_outlined)),
        ],
      ),
      // body: ,
    );
  }
}
