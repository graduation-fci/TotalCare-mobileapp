import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/app_state.dart';
import 'package:provider/provider.dart';

import '../models/medication.dart';
import '../widgets/input_field.dart';
import '../providers/userProvider.dart';
import '../providers/medicineProvider.dart';

class AddMedicationScreen extends StatefulWidget {
  static const String routeName = 'add-medication';
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final Medication _med = Medication(title: '', medicines: []);
  final List<Map<String, dynamic>> _medicineList = [];
  final List _drugsList = [];
  final FocusNode _focusNode = FocusNode();

  Map<String, dynamic>? filteredMeds;
  List<dynamic>? results;
  bool hasContent = false;
  bool _isVisible = true;
  AppState appState = AppState.init;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  Future<List<dynamic>?> _filterDataList(String searchValue) async {
    filteredMeds = await Provider.of<MedicineProvider>(context, listen: false)
        .getFilteredMedsData(searchQuery: searchValue);
    if (filteredMeds != null && filteredMeds!['results'] != null) {
      results = filteredMeds!['results'];
    }
    setState(() {});
    return results;
  }

  Future<void> _addSearchedMedicine(String medicineName) async {
    List<dynamic> newData =
        await _filterDataList(medicineName) as List<dynamic>;

    // Make each object unique in the new list of interactionMedicines.
    if (!_medicineList.contains(newData[0])) {
      _medicineList.add(newData[0]);
    }

    log('$_medicineList');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFCFCFC),
          appBar: AppBar(
            title: Text(
              'Add profile',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .addUserMedication(_med);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save_alt_outlined))
            ],
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    InputField(
                      prefixIcon: const Icon(Icons.title_outlined),
                      labelText: 'title',
                      controller: _titleController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'asdasd';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _med.title = value!;
                      },
                      obsecureText: false,
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        focusNode: _focusNode,
                        onChanged: _filterDataList,
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: _searchController.text.isNotEmpty
                              ? ''
                              : 'Enter a medicine name',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    hasContent
                        ? appState == AppState.loading
                            ? const CircularProgressIndicator.adaptive()
                            : Stack(
                                children: [
                                  if (_medicineList.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          for (int i = 0;
                                              i <
                                                  _medicineList[index]['drug']
                                                      .length;
                                              i++) {
                                            _drugsList.add(_medicineList[index]
                                                ['drug'][i]['name']);
                                          }
                                          return ListTile(
                                            title: Text(
                                                _medicineList[index]['name']),
                                            subtitle:
                                                Text(_drugsList.join(', ')),
                                          );
                                        },
                                        itemCount: _medicineList.length,
                                      ),
                                    ),
                                  results != null && results!.isNotEmpty
                                      ? Visibility(
                                          visible: _isVisible,
                                          child: Container(
                                            height: 200,
                                            padding: const EdgeInsets.all(8),
                                            margin:
                                                const EdgeInsets.only(top: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.grey.shade400,
                                                width: 1,
                                              ),
                                            ),
                                            child: ListView.builder(
                                              itemExtent: 50,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(
                                                    '${results![index]['name']}',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  onTap: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    _addSearchedMedicine(
                                                            results![index]
                                                                ['name'])
                                                        .then(
                                                      (_) => {
                                                        log('${_medicineList[index]['id']}'),
                                                      },
                                                    );

                                                    _med.medicines.add(
                                                        _medicineList[index]
                                                            ['id']);
                                                    log('${_med.medicines}');
                                                    setState(
                                                      () {
                                                        appState =
                                                            AppState.loading;
                                                        _searchController
                                                                .text.isNotEmpty
                                                            ? hasContent = true
                                                            : hasContent =
                                                                false;
                                                        appState =
                                                            AppState.done;
                                                      },
                                                    );
                                                    _searchController.text = '';
                                                  },
                                                );
                                              },
                                              itemCount: results!.length,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                        : results != null && results!.isNotEmpty
                            ? Visibility(
                                visible: _isVisible,
                                child: Container(
                                  height: 200,
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(top: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                    ),
                                  ),
                                  child: ListView.builder(
                                    itemExtent: 50,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          '${results![index]['name']}',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          _addSearchedMedicine(
                                                  results![index]['name'])
                                              .then((_) => {
                                                    log('${_medicineList[index]['id']}'),
                                                  });

                                          // log('${_med.medicines}');
                                          _med.medicines
                                              .add(_medicineList[index]['id']);
                                          setState(
                                            () {
                                              log('${_med.medicines}');
                                              appState = AppState.loading;
                                              _searchController.text.isNotEmpty
                                                  ? hasContent = true
                                                  : hasContent = false;
                                              appState = AppState.done;
                                            },
                                          );
                                          _searchController.text = '';
                                        },
                                      );
                                    },
                                    itemCount: results!.length,
                                  ),
                                ),
                              )
                            : Container(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Provider.of<UserProvider>(context, listen: false)
                      .addUserMedication(_med)
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
