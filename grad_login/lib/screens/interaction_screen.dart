import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/medication.dart';
import '../providers/userProvider.dart';
import '../screens/show_interactions_results_screen.dart';
import '../providers/interactionsProvider.dart';
import '../providers/medicineProvider.dart';

import '.././app_state.dart';

class InteractionScreen extends StatefulWidget {
  static const routeName = '/interaction-screen';
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Medication _med = Medication(title: '', medicineIds: []);

  List<Map<String, dynamic>> _interactionMedicines = [];
  AppState appState = AppState.init;
  bool _isVisible = true;
  List<dynamic>? results;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<dynamic>?> _filterDataList(String searchValue) async {
    Map<String, dynamic>? filteredMeds;
    Timer? debounce;

    debounce?.cancel(); // Cancel previous debounce timer
    debounce = Timer(const Duration(milliseconds: 300), () async {
      // Perform search/filtering here
      filteredMeds = await Provider.of<MedicineProvider>(context, listen: false)
          .getFilteredMedsData(searchQuery: searchValue);
      if (filteredMeds != null && filteredMeds!['results'] != null) {
        results = filteredMeds!['results'];
      }
      setState(() {});
    });
    return results;
  }

  Future<void> _addSearchedMedicine(String? medicineName) async {
    List<dynamic> newData =
        await _filterDataList(medicineName!) as List<dynamic>;
    final med =
        newData.firstWhere((element) => element['name'] == medicineName);
    // Make each object unique in the new list of interactionMedicines.
    if (!_med.medicineIds.contains(med['id'])) {
      _med.medicineIds.add(med['id']);
      _interactionMedicines.add(med);
    }

    // log('$_interactionMedicines');
  }

  void startOver() {
    _interactionMedicines = [];
    hasContent = false;
    setState(() {});
  }

  bool hasContent = false;

  @override
  Widget build(BuildContext context) {
    final interactionsProvider = Provider.of<InteractionsProvider>(context);
    final appLocalization = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              appLocalization.drugInteractionsChecker.toUpperCase(),
              style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    fontSize: mediaQuery.width * 0.05,
                  ),
            ),
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFCFCFC),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    padding: EdgeInsets.all(mediaQuery.width * 0.045),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              focusNode: _focusNode,
                              onChanged: _filterDataList,
                              controller: searchController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: -10),
                                hintText: appLocalization.enterMedicineName,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        hasContent
                            ? appState == AppState.loading
                                ? const CircularProgressIndicator.adaptive()
                                : Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  appLocalization
                                                      .unsavedInteractionsList,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: mediaQuery.width *
                                                        0.038,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              TextButton(
                                                onPressed: startOver,
                                                child: Text(
                                                  appLocalization.startOver,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: mediaQuery.width *
                                                        0.038,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          if (_interactionMedicines.isNotEmpty)
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      index == 0
                                                          ? Container()
                                                          : const Divider(
                                                              thickness: 0.6,
                                                              color: Colors
                                                                  .black87),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: mediaQuery
                                                                    .width *
                                                                0.65,
                                                            child: Text(
                                                              '${_interactionMedicines[index]['name']}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          removeIconButton(
                                                              index, context),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                                itemCount: _interactionMedicines
                                                    .length,
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await interactionsProvider
                                                        .getInteractions(
                                                            _interactionMedicines)
                                                        .then((_) => {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                ShowInteractionsResultsScreen
                                                                    .routeName,
                                                              ),
                                                            });
                                                  },
                                                  child: Text(
                                                    '${appLocalization.check} ${appLocalization.interactions}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    showTitleDialogBox(context);
                                                  },
                                                  child: Text(
                                                    '${appLocalization.save} as Medication profile',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      results != null && results!.isNotEmpty
                                          ? Visibility(
                                              visible: _isVisible,
                                              child: Container(
                                                height: 200,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin: const EdgeInsets.only(
                                                    top: 3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1,
                                                    )),
                                                child: ListView.builder(
                                                  itemExtent: 50,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                        '${results![index]['name']}',
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        _addSearchedMedicine(
                                                            results![index]
                                                                ['name']);
                                                        setState(() {
                                                          searchController.text
                                                                  .isNotEmpty
                                                              ? hasContent =
                                                                  true
                                                              : hasContent =
                                                                  false;
                                                        });
                                                        searchController.text =
                                                            '';
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
                            : Stack(
                                children: [
                                  Text(
                                    appLocalization
                                        .typeADrugNameInTheBoxAboveToGetStarted,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  results != null && results!.isNotEmpty
                                      ? Visibility(
                                          visible: _isVisible,
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                minHeight: 50, maxHeight: 180),
                                            padding: const EdgeInsets.all(8),
                                            margin:
                                                const EdgeInsets.only(top: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                )),
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(
                                                      '${results![index]['name']}'),
                                                  onTap: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    _addSearchedMedicine(
                                                        results![index]
                                                            ['name']);
                                                    setState(() {
                                                      searchController
                                                              .text.isNotEmpty
                                                          ? hasContent = true
                                                          : hasContent = false;
                                                    });
                                                    searchController.text = '';
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector removeIconButton(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final deletedMed = _interactionMedicines[index];
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 2000),
            content: Text('${deletedMed['name']} removed'),
            action: SnackBarAction(
              textColor: Colors.grey.shade600,
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _interactionMedicines.insert(index, deletedMed);
                  _med.medicineIds.insert(index, deletedMed['id']);
                  _interactionMedicines.isNotEmpty ? hasContent = true : null;
                });
              },
            ),
          ),
        );
        setState(() {
          _interactionMedicines.removeAt(index);
          _med.medicineIds.remove(deletedMed['id']);
          _interactionMedicines.isEmpty ? hasContent = false : null;
        });
      },
      child: Icon(
        Icons.remove,
        color: Colors.red.shade600,
      ),
    );
  }

  showTitleDialogBox(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Medication profile title'),
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: 'e.g. My profile',
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              cursorColor: Colors.grey,
              controller: titleController,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red.shade600),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              width: 70,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  _med.title = titleController.text;
                  await Provider.of<UserProvider>(context, listen: false)
                      .addUserMedication(_med)
                      .then((value) => Navigator.pop(context));
                },
                child: Text(
                  'Save',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
