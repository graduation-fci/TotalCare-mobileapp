import 'package:flutter/cupertino.dart';

class Exam {
  final String title;
  final dynamic subject;
  final int id;
  final String starts_at;
  final String ends_at;

  Exam({
    required this.title,
    required this.subject,
    required this.id,
    required this.starts_at,
    required this.ends_at,
  });
}
