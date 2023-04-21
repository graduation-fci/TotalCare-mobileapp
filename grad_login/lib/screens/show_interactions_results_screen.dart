import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:grad_login/providers/interactionsProvider.dart';

class ShowInteractionsResultsScreen extends StatefulWidget {
  static const routeName = 'show-interactions-results-screen';
  ShowInteractionsResultsScreen({super.key});

  @override
  State<ShowInteractionsResultsScreen> createState() =>
      _ShowInteractionsResultsScreenState();
}

class _ShowInteractionsResultsScreenState
    extends State<ShowInteractionsResultsScreen> {
  List<bool> _selections = [true, false];

  final List<Map<String, String>> medicines = [];
  bool isProfessional = false;

  @override
  Widget build(BuildContext context) {
    final interactionsResponse =
        Provider.of<InteractionsProvider>(context, listen: false).response;

    final List interactionDrugs =
        interactionsResponse['interactions'][0]['drugs'];
    final severity = interactionsResponse['interactions'][0]['severity'];
    final consumerEffect =
        interactionsResponse['interactions'][0]['consumerEffect'];
    final professionalEffect =
        interactionsResponse['interactions'][0]['professionalEffect'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Drug Interaction Report',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Interactions found for the following drugs: ',
              style: customTextStyle(16, weight: FontWeight.w600),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                itemExtent: 25,
                itemBuilder: (context, index) {
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
                    title: Text(
                      '${interactionDrugs[index]}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                },
                itemCount: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToggleButtons(
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
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Consumer'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Professional'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.red.shade700,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '$severity',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 181, 45, 35),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        'Applies to: ',
                        style: customTextStyle(16),
                      ),
                      Text('$interactionDrugs'),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  isProfessional
                      ? Text(
                          '$professionalEffect',
                          textAlign: TextAlign.justify,
                          style: customTextStyle(
                            16,
                          ),
                        )
                      : Text(
                          '$consumerEffect',
                          textAlign: TextAlign.justify,
                          style: customTextStyle(
                            16,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
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
