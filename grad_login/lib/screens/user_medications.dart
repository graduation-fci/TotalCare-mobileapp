import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/providers/interactionsProvider.dart';
import 'package:grad_login/screens/show_interactions_results_screen.dart';
import 'package:grad_login/widgets/error_dialog_box.dart';
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
  List<Map<String, dynamic>> medication = [];
  AppState appState = AppState.init;
  Map<int, List> medications = {};

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final interactionsProvider =
        Provider.of<InteractionsProvider>(context, listen: false);
    final userProfileData = userProvider.userProfileData;
    final userMedications = userProvider.userMedications;

    if (userMedications.isNotEmpty) {
      for (int i = 0; i < userMedications.length; i++) {
        List medicineNames = [];
        if (i < userMedications.length) {
          for (int k = 0; k < userMedications[i]['medicine'].length; k++) {
            medicineNames.add(userMedications[i]['medicine'][k]['name']);
          }
        }
        medications[i] = medicineNames;
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
        title: Text(
          'Medication Profiles'.toUpperCase(),
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle!
              .copyWith(fontSize: mediaQuery.width * 0.05),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
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
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: mediaQuery.width * 0.055),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    userMedications.isEmpty
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

                                // add medicine objects to the interactionMedicines list
                                // so that I can use them to get the interactions
                                if (userMedications != null ||
                                    userMedications.isNotEmpty) {
                                  for (int i = 0;
                                      i <
                                          userMedications[index]['medicine']
                                              .length;
                                      i++) {
                                    interactionMedicines.add(
                                        userMedications[index]['medicine'][i]);
                                  }
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
                                              (_) => interactionsProvider
                                                          .appState ==
                                                      AppState.error
                                                  ? showAlertDialog(
                                                      content:
                                                          interactionsProvider
                                                              .errorMessage,
                                                      context: context,
                                                      confirmButtonText:
                                                          'Confirm',
                                                    )
                                                  : Navigator.of(context).pushNamed(
                                                      ShowInteractionsResultsScreen
                                                          .routeName,
                                                      arguments:
                                                          interactionMedicines),
                                            );
                                      },
                                      title: Text(
                                        '${userMedications[index]['title']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                                fontSize:
                                                    mediaQuery.width * 0.042),
                                      ),
                                      subtitle: Text(
                                        medications[index]!.join(', '),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: PopupMenuButton<int>(
                                        itemBuilder: (context) => [
                                          PopupMenuItem<int>(
                                            height: mediaQuery.height * 0.03,
                                            value: 0,
                                            child: const Text('Edit'),
                                          ),
                                          const PopupMenuDivider(),
                                          PopupMenuItem<int>(
                                            textStyle:
                                                TextStyle(color: Colors.red),
                                            height: mediaQuery.height * 0.03,
                                            value: 1,
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                        onSelected: (value) async {
                                          switch (value) {
                                            case 0:
                                              Navigator.of(context).pushNamed(
                                                  EditMedicationScreen
                                                      .routeName,
                                                  arguments:
                                                      userMedications[index]);
                                              break;
                                            case 1:
                                              await userProvider.delMedication(
                                                userMedications[index]['id'],
                                              );
                                              setState(() {
                                                userMedications.removeAt(index);
                                              });
                                              log('$userMedications');
                                              break;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: userMedications.length,
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
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
          child: Text(
            'Add profile',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(fontSize: mediaQuery.width * 0.038),
          ),
        ),
      ),
    );
  }
}
