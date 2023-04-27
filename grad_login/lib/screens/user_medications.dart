import 'package:flutter/material.dart';
import 'package:grad_login/app_state.dart';
import 'package:grad_login/providers/userProvider.dart';
import 'package:provider/provider.dart';

import '../infrastructure/user/user_service.dart';

class UserMedicationsScreen extends StatefulWidget {
  static const routeName = 'user-medications-screen';
  const UserMedicationsScreen({super.key});

  @override
  State<UserMedicationsScreen> createState() => _UserMedicationsScreenState();
}

class _UserMedicationsScreenState extends State<UserMedicationsScreen> {
  List<Map<String, dynamic>> medication = [];
  AppState appState = AppState.init;
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
    final userProfileData = userProvider.userProfileData;
    final userMedications = userProvider.userMedications;
    // print(userMedications);
    // for (int i = 0; i <= userMedications['count']; i++) {
    //   for (int k = 0;
    //       k <= userMedications['results'][i]['medicine'].length;
    //       k++) {
    //     medicationNames
    //         .add(userMedications['results'][i]['medicine'][k]['name']);
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My medications',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: Image.asset(
                  'assets/images/TotalCare.png',
                  height: mediaQuery.height * 0.24,
                  width: mediaQuery.width * 0.3,
                ),
              ),
              Text(
                '${userProfileData['first_name']} ${userProfileData['last_name']}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                height: mediaQuery.height,
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (medication.length > 1) {
                      medication.removeAt(index - 1);
                    }
                    for (int i = 0;
                        i <
                            userMedications['results'][index]['medicine']
                                .length;
                        i++) {
                      medication.add(
                          userMedications['results'][index]['medicine'][i]);
                    }

                    return Column(
                      children: [
                        userMedications['results'][index] == 0
                            ? ListTile(
                                title: Text(
                                  '${userMedications['results'][index]['title']}',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                subtitle: Text(
                                  medication.join(', '),
                                ),
                              )
                            : const Divider(thickness: 0.8, color: Colors.grey),
                        ListTile(
                          title: Text(
                            '${userMedications['results'][index]['title']}',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          subtitle: Text(
                            medication.map((med) => med['name']).join(', '),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              userProvider.delMedication(
                                userMedications['results'][index]['id'],
                              );
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: userMedications['results'].length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
