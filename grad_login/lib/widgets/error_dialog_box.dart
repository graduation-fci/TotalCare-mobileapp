import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  String? title;
  String? content;
  String? confirmButtonText;
  Function? onConfirmPressed;

  CustomAlertDialog({
    super.key,
    this.title,
    this.content,
    this.confirmButtonText,
    this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Oops... Something went wrong!',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      content: Text(
        content!,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 12),
          width: 120,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // onConfirmPressed();
            },
            child: Text(
              confirmButtonText!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showAlertDialog(
    {BuildContext? context,
    String? title,
    String? content,
    String? confirmButtonText,
    Function? onConfirmPressed}) {
  showDialog(
    context: context!,
    builder: (context) {
      return CustomAlertDialog(
        title: title,
        content: content,
        confirmButtonText: confirmButtonText,
        // onConfirmPressed: onConfirmPressed,
      );
    },
  );
}
