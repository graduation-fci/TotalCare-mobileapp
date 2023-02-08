import 'package:flutter/material.dart';
import 'package:grad_login/providers/authService.dart';
import 'package:provider/provider.dart';

import '../providers/examService.dart';
import '../models/exam.dart';

class ExamsScreen extends StatefulWidget {
  static const routeName = '/exams-screen';
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ExamService>(context, listen: false).getExams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final exams = Provider.of<ExamService>(context).exams;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Exams',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      )),
      body: Container(
          height: 300,
          child: ListView.builder(
            itemBuilder: (ctx, i) => Container(
                height: 40,
                child: Column(
                  children: [
                    Card(
                      elevation: 6,
                      child: Text(exams[i].title),
                    ),
                    const Divider(),
                  ],
                )),
            itemCount: exams.length,
          )),
    );
  }
}
