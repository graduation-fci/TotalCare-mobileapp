import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_state.dart';
import '../models/medication.dart';
import '../providers/medicineProvider.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final Medication _med = Medication(medicineIds: [], title: '');
  final _formKey = GlobalKey<FormState>();

  List<int> medicineIds = [];
  Timer? _debounce;
  Map<String, dynamic>? filteredMeds;
  List<dynamic>? results;
  Map<String, dynamic> medication = {};
  bool hasContent = true;
  bool _isVisible = true;
  AppState appState = AppState.init;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isVisible = _searchFocusNode.hasFocus;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      medication =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      medication['medicine']
          .map((element) => medicineIds.add(element['id']))
          .toList();
      log('$medicineIds');
      _titleController.text = medication['title'];
    });
  }

  Future<dynamic> _filterDataList(String searchValue) async {
    _debounce?.cancel(); // Cancel previous debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      filteredMeds = await Provider.of<MedicineProvider>(context, listen: false)
          .getFilteredMedsData(searchQuery: searchValue);
      if (filteredMeds != null && filteredMeds!['results'] != null) {
        results = filteredMeds!['results'];
      }
      setState(() {});
    });
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final medicineProvider =
        Provider.of<MedicineProvider>(context, listen: false);
    medication =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Future<void> addSearchedMedicine(String medicineName) async {
      List<dynamic> newData =
          await _filterDataList(medicineName) as List<dynamic>;
      var med =
          newData.firstWhere((element) => element['name'] == medicineName);
      // Make each object unique in the new list of interactionMedicines.
      if (!medicineIds.contains(med['id'])) {
        medicineIds.add(med['id']);
        medication['medicine'].add(med);
      }
    }

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
              'Edit profile'.toUpperCase(),
              style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    fontSize: mediaQuery.width * 0.05,
                  ),
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
                      focusNode: _titleFocusNode,
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
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        focusNode: _searchFocusNode,
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
                                  const Text(
                                    'MEDICINES',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      // height: 1.5,
                                    ),
                                  ),
                                  if (medication['medicine'].isNotEmpty)
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: mediaQuery.height * 0.04),
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: ListView.builder(
                                        // itemExtent: 80,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: ((context, index) {
                                          List drugsList = [];
                                          for (int i = 0;
                                              i <
                                                  medication['medicine'][index]
                                                          ['drug']
                                                      .length;
                                              i++) {
                                            drugsList.add(medication['medicine']
                                                [index]['drug'][i]['name']);
                                          }
                                          return Dismissible(
                                            key: Key(medication['medicine']
                                                    [index]['id']
                                                .toString()),
                                            direction:
                                                DismissDirection.endToStart,
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 32,
                                                ),
                                              ),
                                            ),
                                            onDismissed: (_) {
                                              final deletedMed =
                                                  medication['medicine'][index];
                                              setState(() {
                                                medication['medicine']
                                                    .removeAt(index);
                                                medicineIds
                                                    .remove(deletedMed['id']);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  duration: const Duration(
                                                      milliseconds: 2000),
                                                  content: Text(
                                                      '${deletedMed['name']} dismissed'),
                                                  action: SnackBarAction(
                                                    textColor: Colors.white,
                                                    label: 'Undo',
                                                    onPressed: () {
                                                      setState(() {
                                                        medication['medicine']
                                                            .insert(index,
                                                                deletedMed);
                                                        medicineIds.add(
                                                            deletedMed['id']);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 8,
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    medication['medicine']
                                                        [index]['name'],
                                                  ),
                                                  subtitle: Text(
                                                    drugsList.join(', '),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 8, 16, 8),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        itemCount:
                                            medication['medicine'].length,
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
                                                    await addSearchedMedicine(
                                                        results![index]
                                                            ['name']);

                                                    if (!_med.medicineIds
                                                        .contains(
                                                            results![index]
                                                                ['id'])) {
                                                      _med.medicineIds.add(
                                                          results![index]
                                                              ['id']);
                                                    }
                                                    log('${_med.medicineIds}');
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
                                          await addSearchedMedicine(
                                              results![index]['name']);

                                          // log('${_med.medicines}');
                                          _med.medicineIds
                                              .add(results![index]['id']);
                                          log('${_med.medicineIds}');
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _med.medicineIds.addAll(medicineIds);
                  _formKey.currentState!.save();
                  await userProvider
                      .editUserMedication(_med, medication['id'])
                      .then((_) async => await medicineProvider
                          .getNotifications(medication['id']))
                      .then((_) => userProvider.getUserMedications())
                      .then((_) => Navigator.pop(context))
                      .then((_) {
                    medicineProvider.noticationsEn.isNotEmpty
                        ? Fluttertoast.showToast(
                            msg: 'New interactions found!',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP_RIGHT,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          )
                        : null;
                  });
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
              child: Text(
                'Save',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(fontSize: mediaQuery.width * 0.038),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
