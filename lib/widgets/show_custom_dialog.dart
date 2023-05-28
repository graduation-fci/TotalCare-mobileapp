import 'package:flutter/material.dart';

Future<dynamic> showCustomDialog(
  BuildContext context,
  Widget titleWidget, {
  Widget? contentWidget,
  List<Widget>? actionsWidgets,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: titleWidget,
        content: contentWidget,
        actions: actionsWidgets,
      );
    },
  );
}
