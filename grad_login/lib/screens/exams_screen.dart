import 'package:flutter/material.dart';
import 'package:grad_login/providers/examProvider.dart';
import 'package:grad_login/providers/userProvider.dart';
import 'package:grad_login/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../widgets/drop_down_list.dart';

class ExamsScreen extends StatefulWidget {
  static const routeName = '/exams-screen';

  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final av = 0;
  final Map<String, String> dropDownOptions = {
    '-': '-',
    'starts_at': 'Ascending start',
    'ends_at': 'Ascending end',
    '-starts_at': 'Descending start',
    '-ends_at': 'Descending end'
  };

  late String dropdownValue;

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  // void handleSearch() {

  // }

  @override
  Widget build(BuildContext context) {
    final examResponse = Provider.of<ExamProvider>(context);
    final authResponse = Provider.of<AuthProvider>(context);
    final userResponse = Provider.of<UserProvider>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
              title: const Text(
                'Exams',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      authResponse.logout();
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ))
              ]),
          body: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: (value) {
                  print(userResponse.getSearchedData(searchController.text));
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  controller: scrollController,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(examResponse.exams[i].title),
                    leading: CircleAvatar(child: Text('$i')),
                  ),
                  itemCount: examResponse.exams.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDropdownButton(
                    items: dropDownOptions,
                    onChanged: (String? value) {
                      userResponse.handleOrder(
                        searchController.text,
                        ordering: value,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      Provider.of<ExamProvider>(context, listen: false).getExams();
    }
    print('not call');
  }
}
