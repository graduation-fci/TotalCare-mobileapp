import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/models/medication.dart';
import 'package:provider/provider.dart';

import '../providers/userProvider.dart';
import '../widgets/input_field.dart';

class EditMedicationScreen extends StatefulWidget {
  static const String routeName = 'edit-medication';
  const EditMedicationScreen({super.key});

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Medication _med = Medication(title: '', medicines: []);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map medication = ModalRoute.of(context)!.settings.arguments as Map;
    final mediaQuery = MediaQuery.of(context).size;

    log('$medication');
    setState(() {
      _titleController.text = medication['title'];
    });

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF003745),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Edit Profile',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            actions: const [
              IconButton(onPressed: null, icon: Icon(Icons.save_as_outlined)),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InputField(
                      prefixIcon: const Icon(
                        Icons.title_outlined,
                        color: Colors.grey,
                      ),
                      labelText: 'Title',
                      controller: _titleController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This value cannot be empty!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _med.title = value!;
                      },
                      obsecureText: false,
                    ),
                    ListView.builder(
                      itemExtent: 100,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List drugsList = [];
                        for (int i = 0;
                            i < medication['medicine'][index]['drug'].length;
                            i++) {
                          drugsList.add(
                              medication['medicine'][index]['drug'][i]['name']);
                        }
                        return Card(
                          margin: const EdgeInsets.only(top: 8),
                          elevation: 3,
                          child: ListTile(
                            title: Text(medication['medicine'][index]['name']),
                            subtitle: Text(drugsList.join(', ')),
                          ),
                        );
                      }),
                      itemCount: medication['medicine'].length,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Provider.of<UserProvider>(context, listen: false)
                      .editUserMedication(_med, medication['id'])
                      .then((_) => Navigator.pop(context));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                fixedSize: Size(
                  mediaQuery.width * 0.85,
                  mediaQuery.height * 0.06,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text('Add', style: Theme.of(context).textTheme.button),
            ),
          ),
        ),
      ),
    );
  }
}
