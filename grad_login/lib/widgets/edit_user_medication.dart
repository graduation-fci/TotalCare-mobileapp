import 'package:flutter/material.dart';
import 'package:grad_login/providers/userProvider.dart';
import 'package:provider/provider.dart';

class EditUserMedication extends StatefulWidget {
  Map<String, dynamic> medication;
  EditUserMedication({super.key, required this.medication});

  @override
  State<EditUserMedication> createState() => _EditUserMedicationState();
}

class _EditUserMedicationState extends State<EditUserMedication> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.medication['title'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    bool isEnabled = false;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    // border: InputBorder.none,
                    ),
                onTap: () {
                  setState(() {
                    isEnabled = true;
                  });
                },
                controller: _titleController,
                // onSubmitted: (_) => _submitData(),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    return Card(
                      margin: const EdgeInsets.only(top: 8),
                      elevation: 2,
                      child: ListTile(
                        title:
                            Text(widget.medication['medicine'][index]['name']),
                      ),
                    );
                  }),
                  itemCount: widget.medication['medicine'].length,
                ),
              ),
              const ElevatedButton(
                onPressed: null,
                child: Text(
                  'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
