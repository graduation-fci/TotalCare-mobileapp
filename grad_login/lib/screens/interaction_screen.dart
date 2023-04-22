import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:grad_login/models/drug.dart';
import 'package:grad_login/models/simple_medicine.dart';
import 'package:grad_login/screens/show_interactions_results_screen.dart';
import 'package:provider/provider.dart';

import '../providers/interactionsProvider.dart';
import '../providers/medicineProvider.dart';
import '../providers/userProvider.dart';

import '.././app_state.dart';
import '.././my_config.dart';

class InteractionScreen extends StatefulWidget {
  static const routeName = '/interaction-screen';
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final simpleMeds = Config.simpleMeds;

  List<SimpleMedicine> _interactionMedicines = [];
  bool _isVisible = true;
  AppState appState = AppState.init;
  Map<String, dynamic>? filteredMeds;
  Map<String, dynamic>? meds;

  List<dynamic>? results;

  @override
  void initState() {
    // TODO: implement initState
    _focusNode.addListener(() {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<dynamic>?> _filterDataList(String searchValue) async {
    filteredMeds = await Provider.of<UserProvider>(context, listen: false)
        .getFilteredData(searchQuery: searchValue);
    if (filteredMeds != null && filteredMeds!['results'] != null) {
      results = filteredMeds!['results'];
    }
    setState(() {});
    return results;
  }

  Future<void> _addSearchedMedicine(String? medicineName) async {
    List<dynamic> newData =
        await _filterDataList(medicineName!) as List<dynamic>;

    SimpleMedicine newMed = SimpleMedicine.fromJson(newData[0]);
    // Make each object unique in the new list of interactionMedicines.
    if (!_interactionMedicines.contains(newMed)) {
      _interactionMedicines.add(newMed);
    }

    log('${_interactionMedicines[0].name}');
  }

  void startOver() {
    _interactionMedicines = [];
    hasContent = false;
    setState(() {});
  }

  bool hasContent = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final interactionsProvider = Provider.of<InteractionsProvider>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFCFCFC),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                height: mediaQuery.height * 0.45,
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  )),
                              child: TextFormField(
                                focusNode: _focusNode,
                                onChanged: _filterDataList,
                                // onTap: () async => {
                                //   meds =
                                //       await UserProvider().getFilteredData() as Map,
                                // },
                                controller: searchController,
                                decoration: InputDecoration(
                                  labelText: searchController.text.isNotEmpty
                                      ? ''
                                      : 'Enter a drug name',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _addSearchedMedicine(searchController.text);
                                setState(() {
                                  appState = AppState.loading;
                                  searchController.text.isNotEmpty
                                      ? hasContent = false
                                      : hasContent = true;
                                  appState = AppState.done;
                                });
                                searchController.text = '';
                              },
                              child: const Text('Add'),
                            ),
                          ),
                        ],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                'unsaved interactions list',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          TextButton(
                                            onPressed: startOver,
                                            child: const Text(
                                              'Start over',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceAround,
                                      //   children: <Widget>[
                                      //     Expanded(
                                      //       child: TextFormField(
                                      //         controller: searchController2,
                                      //         decoration: InputDecoration(
                                      //           hintText: 'Drug 1 (example)',
                                      //           border: OutlineInputBorder(),
                                      //           suffixIcon: IconButton(
                                      //             icon: Icon(Icons.clear),
                                      //             onPressed: () {
                                      //               searchController2.clear();
                                      //             },
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      if (_interactionMedicines.isNotEmpty)
                                        SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                    '${_interactionMedicines[index].name}'),
                                                onTap: () => {
                                                  log('${_interactionMedicines[index].name}')
                                                },
                                              );
                                            },
                                            itemCount:
                                                _interactionMedicines.length,
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
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                            ShowInteractionsResultsScreen
                                                                .routeName,
                                                          ),
                                                          log('${interactionsProvider.response}'),
                                                        });

                                                // log('$_interactionMedicines');
                                              },
                                              child: const Text(
                                                'Check interactions',
                                                // style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
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
                                              onPressed: () {},
                                              child: const Text(
                                                'Save',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  results != null
                                      ? results!.isNotEmpty
                                          ? Visibility(
                                              visible: _isVisible,
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        minHeight: 50,
                                                        maxHeight: 180),
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
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                          '${results![index]['name']}'),
                                                      onTap: () {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        _addSearchedMedicine(
                                                            results![index]
                                                                ['name']);
                                                        log('${results![index]['name']}');
                                                        setState(() {
                                                          appState =
                                                              AppState.loading;
                                                          searchController.text
                                                                  .isNotEmpty
                                                              ? hasContent =
                                                                  true
                                                              : hasContent =
                                                                  false;
                                                          appState =
                                                              AppState.done;
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
                                          : Container()
                                      : Container(),
                                ],
                              )
                        : Stack(
                            children: [
                              const Text(
                                'Type a drug name in the box above to get started.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              results != null
                                  ? results!.isNotEmpty
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
                                                      appState =
                                                          AppState.loading;
                                                      searchController
                                                              .text.isNotEmpty
                                                          ? hasContent = true
                                                          : hasContent = false;
                                                      appState = AppState.done;
                                                    });
                                                    searchController.text = '';
                                                  },
                                                );
                                              },
                                              itemCount: results!.length,
                                            ),
                                          ),
                                        )
                                      : Container()
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
    );
  }
}
