import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../widgets/error_dialog_box.dart';
import '../providers/interactionsProvider.dart';
import '../screens/show_interactions_results_screen.dart';
import '../screens/edit_medication.dart';

class ShowMedicationProfile extends StatelessWidget {
  static const String routeName = 'show-medication-profile';
  const ShowMedicationProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final medication =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final interactionsProvider = Provider.of<InteractionsProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            medication['title'],
            style: Theme.of(context)
                .appBarTheme
                .titleTextStyle!
                .copyWith(fontSize: mediaQuery.width * 0.05),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed(
                    EditMedicationScreen.routeName,
                    arguments: medication),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constrains) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constrains.maxHeight),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.03),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 5,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final List drugs = [];
                      for (int i = 0;
                          i < medication['medicine'][index]['drug'].length;
                          i++) {
                        drugs.add(
                            medication['medicine'][index]['drug'][i]['name']);
                      }

                      return Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 35,
                              offset: const Offset(0, 10))
                        ]),
                        child: GridTile(
                          footer: GridTileBar(
                            title: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: Text(
                                medication['medicine'][index]['name'],
                                overflow: TextOverflow.visible,
                                // textAlign: TextAlign.left,
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: mediaQuery.width * 0.035,
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Image.network(medication['medicine'][index]
                              ['medicine_images'][0]),
                        ),
                      );
                    },
                    itemCount: medication['medicine'].length,
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> interactionMedicines = [];
                medication['medicine'].map((element) {
                  interactionMedicines.add(element);
                }).toList();
                await interactionsProvider
                    .getInteractions(interactionMedicines)
                    .then(
                      (_) => Navigator.of(context).pushNamed(
                        ShowInteractionsResultsScreen.routeName,
                      ),
                    );
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
                'Check interactions',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(fontSize: mediaQuery.width * 0.038),
              ),
            )),
      ),
    );
  }
}
