import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:grad_login/providers/interactionsProvider.dart';

import 'package:translator/translator.dart';

class ShowInteractionsResultsScreen extends StatefulWidget {
  static const routeName = 'show-interactions-results-screen';
  const ShowInteractionsResultsScreen({super.key});

  @override
  State<ShowInteractionsResultsScreen> createState() =>
      _ShowInteractionsResultsScreenState();
}

class _ShowInteractionsResultsScreenState
    extends State<ShowInteractionsResultsScreen> {
  final List<Map<String, String>> medicines = [];

  List<String> uniqueDrugsList = [];
  List<bool> _selections = [true, false];
  bool isProfessional = false;
  String? errorMsg;

  final translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final interactionsProvider =
        Provider.of<InteractionsProvider>(context, listen: false);
    final appLocalization = AppLocalizations.of(context)!;
    final localeName = appLocalization.localeName;
    final arguements =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>?;
    List<dynamic> interactionsResponse =
        arguements ?? interactionsProvider.response;

    for (int i = 0; i < interactionsResponse.length; i++) {
      for (int j = 0; j < interactionsResponse[i]['interactions'].length; j++) {
        for (int k = 0;
            k < interactionsResponse[i]['interactions'][j]['drugs'].length;
            k++) {
          if (!uniqueDrugsList.contains(
              interactionsResponse[i]['interactions'][j]['drugs'][k])) {
            uniqueDrugsList
                .add(interactionsResponse[i]['interactions'][j]['drugs'][k]);
          }
        }
      }
    }
    if (interactionsProvider.appState == AppState.error) {
      errorMsg = interactionsProvider.errorMessage;
      interactionsResponse = [];
      uniqueDrugsList = [];
    }

    return Scaffold(
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
        elevation: 0,
        title: Text(
          appLocalization.drugInteractionsReport.toUpperCase(),
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle!
              .copyWith(fontSize: mediaQuery.width * 0.045),
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    top: 12,
                    right: 12,
                  ),
                  child: Text(
                    '${interactionsResponse.length} ${appLocalization.interactions} found for the following ${uniqueDrugsList.length} drugs: ',
                    style: customTextStyle(
                      mediaQuery.width * 0.043,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.builder(
                  itemExtent: 25,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, drugIndex) {
                    return ListTile(
                      leading: const SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: Icon(
                            Icons.circle,
                            color: Colors.black87,
                            size: 10,
                          ),
                        ),
                      ),
                      title: Text(uniqueDrugsList[drugIndex]),
                    );
                  },
                  itemCount: uniqueDrugsList.length,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 21, bottom: 21),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(6),
                    selectedColor: Colors.white,
                    fillColor: const Color.fromARGB(255, 2, 17, 29),
                    borderWidth: 0,
                    isSelected: _selections,
                    onPressed: toggleBtnsFunction,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          appLocalization.consumer,
                          style: TextStyle(fontSize: mediaQuery.width * 0.04),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          appLocalization.professional,
                          style: TextStyle(fontSize: mediaQuery.width * 0.04),
                        ),
                      ),
                    ],
                  ),
                ),
                errorMsg != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          errorMsg!,
                          style: TextStyle(fontSize: mediaQuery.width * 0.05),
                        ))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: interactionsResponse.length,
                        itemBuilder: (context, index) {
                          final List interactionList =
                              interactionsResponse[index]['interactions'];
                          final List medicinesOfInteraction =
                              interactionsResponse[index]['medecines'];
                          final List namesOfMedicines = [];

                          for (int k = 0;
                              k < medicinesOfInteraction.length;
                              k++) {
                            namesOfMedicines
                                .add(medicinesOfInteraction[k]['nameEn']);
                          }

                          for (int i = 0; i < interactionList.length; i++) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 21, bottom: 21, right: 21),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int k = 0;
                                      k < namesOfMedicines.length;
                                      k++)
                                    Column(
                                      children: [
                                        Text(
                                          namesOfMedicines[k],
                                          overflow: TextOverflow.clip,
                                          style: customTextStyle(
                                              mediaQuery.width * 0.048,
                                              weight: FontWeight.w700),
                                        ),
                                        k == namesOfMedicines.length - 1
                                            ? Container()
                                            : Center(
                                                child: Text(
                                                  '×',
                                                  style: customTextStyle(
                                                      mediaQuery.width * 0.045,
                                                      weight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red.shade700,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      '${interactionList[i]['severity']}',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 64, 26, 23),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    children: [
                                      Text(
                                        'Applies to: ',
                                        style: customTextStyle(
                                            mediaQuery.width * 0.041),
                                      ),
                                      Text(
                                        interactionList[i]['drugs'].join(', '),
                                        style: customTextStyle(
                                            mediaQuery.width * 0.045,
                                            weight: FontWeight.w400),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  isProfessional
                                      ? FutureBuilder<Translation>(
                                          future:  translator.translate(
                                            interactionList[i]
                                                ['professionalEffect'],
                                            to: localeName,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  'Translation Error');
                                            } else {
                                              return Text(
                                                snapshot.data.toString(),
                                                textAlign: TextAlign.justify,
                                                style: customTextStyle(
                                                    mediaQuery.width * 0.042),
                                              );
                                            }
                                          },
                                        )
                                      : FutureBuilder<Translation>(
                                          future: translator.translate(
                                            interactionList[i]
                                                ['consumerEffect'],
                                            to: localeName,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  'Translation Error');
                                            } else {
                                              return Text(
                                                snapshot.data.toString(),
                                                textAlign: TextAlign.justify,
                                                style: customTextStyle(
                                                    mediaQuery.width * 0.042),
                                              );
                                            }
                                          },
                                        ),
                                  const SizedBox(height: 24),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                // Row(
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.only(left: 12, right: 6),
                //       height: 20,
                //       width: 20,
                //       child: const Center(
                //         child: Icon(
                //           Icons.circle,
                //           color: Colors.black87,
                //           size: 10,
                //         ),
                //       ),
                //     ),
                // TextButton(
                //     onPressed: null,
                //     child: Container(
                //       decoration: const BoxDecoration(
                //         border: Border(
                //           bottom: BorderSide(
                //             width: 1,
                //             color: Colors.blueAccent,
                //           ),
                //         ),
                //       ),
                //       child: Text(
                //         'Save interactions report',
                //         style: TextStyle(
                //           color: Colors.blueAccent,
                //           fontSize: mediaQuery.width * 0.038,
                //         ),
                //       ),
                //     ))
                //   ],
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void toggleBtnsFunction(index) => {
        setState(() {
          _selections = _selections.map((value) => false).toList();
          _selections[index] = true;
          if (_selections[0]) {
            isProfessional = false;
          } else if (_selections[1]) {
            isProfessional = true;
          }
        })
      };
}

TextStyle customTextStyle(double fontSize, {FontWeight? weight}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: weight,
    color: Colors.black,
  );
}
