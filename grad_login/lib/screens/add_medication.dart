import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
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
  final FocusNode _focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic>? filteredMeds;
  List<dynamic>? results;
  bool hasContent = false;
  bool _isVisible = true;
  AppState appState = AppState.init;
  Timer? _debounce;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  Future<dynamic> _filterDataList(String searchValue) async {
    _debounce?.cancel(); // Cancel previous debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // Perform search/filtering here
      filteredMeds = await Provider.of<MedicineProvider>(context, listen: false)
          .getFilteredMedsData(searchQuery: searchValue);
      if (filteredMeds != null && filteredMeds!['results'] != null) {
        results = filteredMeds!['results'];
      }
      setState(() {});
    });
    return results != null && results!.isNotEmpty ? results![0] : null;
  }

  Future<void> _addSearchedMedicine(String medicineName) async {
    final newData = await _filterDataList(medicineName);

    // Make each object unique in the new list of interactionMedicines.
    if (_medicineList.contains(newData)) {
    } else {
      _medicineList.add(newData);
    }
    log('$_medicineList');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFCFCFC),
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
              'Add profile',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            actions: [
              IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  iconSize: 30,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await Provider.of<UserProvider>(context, listen: false)
                          .addUserMedication(_med);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.save_as,
                    color: Theme.of(context).colorScheme.secondary,
                  ))
            ],
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Column(
                  children: [
                    InputField(
                      suffixIcon: const IconButton(
                        icon: Icon(
                          Icons.title_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: null,
                      ),
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
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(
                      height: 12,
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
                                          List drugsList = [];
                                          for (int i = 0;
                                              i <
                                                  _medicineList[index]['drug']
                                                      .length;
                                              i++) {
                                            if (!drugsList.contains(
                                                _medicineList[index]['drug'][i]
                                                    ['name'])) {
                                              drugsList.add(_medicineList[index]
                                                  ['drug'][i]['name']);
                                            }
                                          }
                                          return ListTile(
                                            title: Text(
                                                _medicineList[index]['name']),
                                            subtitle:
                                                Text(drugsList.join(', ')),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                await userProvider
                                                    .delMedication(
                                                  _medicineList[index]['id'],
                                                );
                                                setState(() {
                                                  _med.medicines.removeWhere(
                                                      (element) =>
                                                          element ==
                                                          _medicineList[index]
                                                              ['id']);
                                                  _medicineList.removeAt(index);
                                                });
                                                log('$_medicineList');
                                                log('${_med.medicines}');
                                              },
                                            ),
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
                                                  onTap: () async {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    await _addSearchedMedicine(
                                                        results![index]
                                                            ['name']);

                                                    if (!_med.medicines
                                                        .contains(
                                                            results![index]
                                                                ['id'])) {
                                                      _med.medicines.add(
                                                          results![index]
                                                              ['id']);
                                                    }
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
                                        onTap: () async {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          await _addSearchedMedicine(
                                              results![index]['name']);

                                          // log('${_med.medicines}');
                                          _med.medicines
                                              .add(results![index]['id']);
                                          log('${_med.medicines}');
                                          setState(
                                            () {
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
