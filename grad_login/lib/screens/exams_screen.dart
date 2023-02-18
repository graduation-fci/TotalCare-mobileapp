import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authService.dart';

class ExamsScreen extends StatefulWidget {
  static const routeName = '/exams-screen';

  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  bool? isLoaded = false;
  final ScrollController scrollController = ScrollController();
  var currentPage = 1;

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final exams = Provider.of<AuthService>(context).exams;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
          title: const Text(
        'Exams',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      )),
      body: isLoaded!
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Container(
              height: 300,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                controller: scrollController,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(exams[i].title),
                  leading: CircleAvatar(child: Text('$i')),
                ),
                itemCount: exams.length,
              ),
            ),
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      currentPage += 1;
      Provider.of<AuthService>(context, listen: false).getExams();
    }
    print('not call');
  }
}
