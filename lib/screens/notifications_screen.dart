import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/medicineProvider.dart';
import '../infrastructure/shared/storage.dart';
import 'notification_widget.dart';
import 'show_interactions_results_screen.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = 'notifications-screen';
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

bool readAll = false;

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  Storage storage = Storage();
  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  void loadNotifications() async {
    List<dynamic> loadedNotifications = await storage.loadItemList();
    setState(() {
      notifications = loadedNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final medicineProvider = Provider.of<MedicineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
            medicineProvider.notificationsCounter = 0;
            NotificationIcon().counter = 0;
          },
        ),
        title: Text(
          'Notifications'.toUpperCase(),
          style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                fontSize: mediaQuery.width * 0.05,
              ),
        ),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'You have no notifications!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton(
                      onPressed: () => setState(() {
                        readAll = true;
                      }),
                      child: const Text(
                        'Read all',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pushNamed(
                                ShowInteractionsResultsScreen.routeName,
                                arguments: notifications[index]
                                    ['permutations']);
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Text(
                              notifications[index]['notification']['en'],
                              style: TextStyle(
                                fontWeight: readAll == false
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: notifications.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
