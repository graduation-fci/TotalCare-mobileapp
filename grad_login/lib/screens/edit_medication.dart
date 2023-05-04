import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medication.dart';
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
  final Medication _med = Medication(medicines: [], title: '');
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> medication = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      medication =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _titleController.text = medication['title'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    medication =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    log('$medication');
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROFILE TITLE',
                      style: TextStyle(
                        fontFamily: 'Heebo',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        // height: 1.5,
                      ),
                    ),
                    InputField(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.title_outlined),
                        color: Colors.grey,
                        onPressed: () {},
                      ),
                      focusNode: _focusNode,
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
                      // itemExtent: 80,
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
                        return Dismissible(
                          key: Key(
                              medication['medicine'][index]['id'].toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              userProvider.delMedication(
                                  medication['medicine'][index]['id']);
                              medication['medicine'].removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${medication['title']} dismissed'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      userProvider.addUserMedication(_med);
                                      medication['medicine'].insert(
                                          index, medication['medicine'][index]);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: ListTile(
                                title:
                                    Text(medication['medicine'][index]['name']),
                                subtitle: Text(
                                  drugsList.join(', '),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              ),
                            ),
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
              child: Text('Save', style: Theme.of(context).textTheme.button),
            ),
          ),
        ),
      ),
    );
  }
}
