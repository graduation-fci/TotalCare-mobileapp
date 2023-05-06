import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/models/simple_medicine.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:grad_login/providers/interactionsProvider.dart';

class ShowInteractionsResultsScreen extends StatefulWidget {
  static const routeName = 'show-interactions-results-screen';
  const ShowInteractionsResultsScreen({super.key});

  @override
  State<ShowInteractionsResultsScreen> createState() =>
      _ShowInteractionsResultsScreenState();
}

class _ShowInteractionsResultsScreenState
    extends State<ShowInteractionsResultsScreen> {
  List<bool> _selections = [true, false];

  final List<Map<String, String>> medicines = [];
  bool isProfessional = false;
  int numOfDrugs = 0;

  @override
  Widget build(BuildContext context) {
    final interactionsResponse =
        Provider.of<InteractionsProvider>(context, listen: false).response;
    final List<Map<String, dynamic>> medicineList = ModalRoute.of(context)!
        .settings
        .arguments as List<Map<String, dynamic>>;
    final appLocalization = AppLocalizations.of(context)!;
    List<String> uniqueMedicineList = [];

    for (int i = 0; i < medicineList.length; i++) {
      for (int j = 0; j < medicineList[i]['drug'].length; j++) {
        if (!uniqueMedicineList.contains(medicineList[i]['drug'][j]['name'])) {
          uniqueMedicineList.add(medicineList[i]['drug'][j]['name']);
          numOfDrugs++;
        }
      }
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
          style: const TextStyle(color: Colors.black87),
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
                    '${interactionsResponse.length} ${appLocalization.interactions} found for the following ${uniqueMedicineList.length} drugs: ',
                    style: customTextStyle(
                      16,
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
                      title: Text(uniqueMedicineList[drugIndex]),
                    );
                  },
                  itemCount: uniqueMedicineList.length,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 21, bottom: 21),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(6),
                    selectedColor: Colors.white,
                    fillColor: const Color.fromARGB(255, 2, 17, 29),
                    borderWidth: 0,
                    isSelected: _selections,
                    onPressed: (index) => {
                      setState(() {
                        _selections =
                            _selections.map((value) => false).toList();
                        _selections[index] = true;
                        if (_selections[0]) {
                          isProfessional = false;
                        } else if (_selections[1]) {
                          isProfessional = true;
                        }
                      })
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appLocalization.consumer),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appLocalization.professional),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: interactionsResponse.length,
                  itemBuilder: (context, index) {
                    final List interactionList =
                        interactionsResponse[index]['interactions'];
                    final List medicinesOfInteraction =
                        interactionsResponse[index]['medecines'];
                    final List namesOfMedicines = [];

                    for (int k = 0; k < medicinesOfInteraction.length; k++) {
                      namesOfMedicines.add(medicinesOfInteraction[k]['nameEn']);
                    }

                    for (int i = 0; i < interactionList.length; i++) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 21, bottom: 21, right: 21),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int k = 0; k < namesOfMedicines.length; k++)
                              Column(
                                children: [
                                  Text(
                                    namesOfMedicines[k],
                                    style: customTextStyle(18,
                                        weight: FontWeight.w700),
                                  ),
                                  k == namesOfMedicines.length - 1
                                      ? Container()
                                      : Center(
                                          child: Text(
                                            '×',
                                            style: customTextStyle(18,
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
                                borderRadius: BorderRadius.circular(20),
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
                                  style: customTextStyle(15),
                                ),
                                Text(
                                  interactionList[i]['drugs'].join(', '),
                                  style: customTextStyle(18,
                                      weight: FontWeight.w400),
                                  softWrap: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            isProfessional
                                ? Text(
                                    '${interactionList[i]['professionalEffect']}',
                                    textAlign: TextAlign.justify,
                                    style: customTextStyle(
                                      16,
                                    ),
                                  )
                                : Text(
                                    '${interactionList[i]['consumerEffect']}',
                                    textAlign: TextAlign.justify,
                                    style: customTextStyle(
                                      16,
                                    ),
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
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 12, right: 6),
                      height: 20,
                      width: 20,
                      child: const Center(
                        child: Icon(
                          Icons.circle,
                          color: Colors.black87,
                          size: 10,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: null,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Save interactions report',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

TextStyle customTextStyle(double fontSize, {FontWeight? weight}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: weight,
    color: Colors.black,
  );
}
