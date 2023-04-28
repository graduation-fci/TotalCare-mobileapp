import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/widgets/edit_user_medication.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
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

  void _showEditMedication(BuildContext ctx, medication) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: EditUserMedication(medication: medication),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
          'My medications',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  // ignore: avoid_unnecessary_containers
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/TotalCare.png',
                          height: mediaQuery.height * 0.24,
                          width: mediaQuery.width * 0.3,
                        ),
                        Text(
                          '${userProfileData['first_name']} ${userProfileData['last_name']}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                      key: GlobalKey(),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: Text(
                                '${medicationResults[index]['title']}',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
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
                                          await userProvider.delMedication(
                                            medicationResults[index]['id'],
                                          );
                                          setState(() {
                                            medicationResults.remove(
                                                medicationResults[index]);
                                          });
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
                                        onPressed: () => _showEditMedication(
                                            context, medicationResults[index]),
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
