import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/providers/interactionsProvider.dart';
import 'package:grad_login/screens/show_interactions_results_screen.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../screens/add_medication.dart';
import '../screens/edit_medication.dart';
import '../providers/userProvider.dart';

class UserMedicationsScreen extends StatefulWidget {
  static const routeName = 'user-medications-screen';
  const UserMedicationsScreen({super.key});

  @override
  State<UserMedicationsScreen> createState() => _UserMedicationsScreenState();
}

class _UserMedicationsScreenState extends State<UserMedicationsScreen> {
  final List<Map<String, dynamic>> myList = [
    {
      "id": 41,
      "name": "abrammune 100 mg 50 capsules(n/a yet)",
      "name_ar": "Ø§Ø¨Ø±Ø§ÙÙÙÙ 100 ÙØ¬Ù 50 ÙØ¨Ø³ÙÙ",
      "drug": [
        {"id": 6, "name": "cyclosporine"}
      ],
      "medicine_images": [
        "http://192.168.1.8:8001/media/medicines/images/category_T42ggCH.jpg",
        "http://192.168.1.8:8001/media/medicines/images/drug_YcJ8SYl.jpg"
      ]
    },
    {
      "id": 928,
      "name": "tramacet 20 f.c. tabs.",
      "name_ar": "ØªØ±Ø§ÙØ§Ø³ÙØª 20 ÙØ±Øµ",
      "drug": [
        {"id": 3, "name": "paracetamol"},
        {"id": 276, "name": "tramadol"}
      ],
      "medicine_images": [
        "http://192.168.1.8:8001/media/medicines/images/category_GUzYNi5.jpg",
        "http://192.168.1.8:8001/media/medicines/images/drug_udo8dt5.jpg"
      ]
    }
  ];
  List<Map<String, dynamic>> medication = [];
  AppState appState = AppState.init;
  // Map medications = {};
  Map<int, List> medications = {};
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<UserProvider>(context, listen: false).getUserProfile();
      Provider.of<UserProvider>(context, listen: false).getUserMedications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final interactionsProvider =
        Provider.of<InteractionsProvider>(context, listen: false);
    final userProfileData = userProvider.userProfileData;
    final userMedications = userProvider.userMedications;
    final medicationResults = userMedications['results'];

    for (int i = 0; i < userMedications['count']; i++) {
      List medicineNames = [];

      for (int k = 0; k < medicationResults[i]['medicine'].length; k++) {
        medicineNames.add(medicationResults[i]['medicine'][k]['name']);
      }
      medications[i] = medicineNames;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medication profiles',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(children: [
            Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ignore: avoid_unnecessary_containers
                      Container(
                        width: mediaQuery.width,
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade300),
                        child: const Text(
                          'You can press on a profile to check the interaction between its medicines.',
                          style: TextStyle(color: Colors.black54, fontSize: 10),
                        ),
                      ),

                      Image.asset(
                        'assets/images/TotalCare.png',
                        height: mediaQuery.height * 0.24,
                        width: mediaQuery.width * 0.3,
                        alignment: Alignment.center,
                      ),
                      Text(
                        '${userProfileData['first_name']} ${userProfileData['last_name']}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      medicationResults.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'You have no medication profiles.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(12),
                              child: ListView.builder(
                                key: GlobalKey(),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  List<Map<String, dynamic>>
                                      interactionMedicines = [];
                                      
                                  for (int i = 0;
                                      i <
                                          medicationResults[index]['medicine']
                                              .length;
                                      i++) {
                                    interactionMedicines.add(
                                        medicationResults[index]['medicine']
                                            [i]);
                                  }

                                  return Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: ListTile(
                                        onTap: () async {
                                          await interactionsProvider
                                              .getInteractions(
                                                  interactionMedicines)
                                              .then(
                                                (_) => Navigator.of(context)
                                                    .pushNamed(
                                                        ShowInteractionsResultsScreen
                                                            .routeName,
                                                        arguments:
                                                            interactionMedicines),
                                              );
                                        },
                                        title: Text(
                                          '${medicationResults[index]['title']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                        subtitle: Text(
                                          medications[index]!.join(', '),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: SizedBox(
                                          width: 80,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    await userProvider
                                                        .delMedication(
                                                          medicationResults[
                                                              index]['id'],
                                                        )
                                                        .then((value) =>
                                                            medicationResults.remove(
                                                                medicationResults[
                                                                    index]));
                                                    setState(() {});
                                                    log('$medicationResults');
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () => Navigator.of(
                                                          context)
                                                      .pushNamed(
                                                          EditMedicationScreen
                                                              .routeName,
                                                          arguments:
                                                              medicationResults[
                                                                  index]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: medicationResults.length,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ]);
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddMedicationScreen.routeName);
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
          child: Text('Add profile', style: Theme.of(context).textTheme.button),
        ),
      ),
    );
  }
}
