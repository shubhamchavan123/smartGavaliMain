
import 'package:flutter/material.dart';

class CustomErrorDialog extends StatelessWidget {
  final String title;
  final String description;

  const CustomErrorDialog({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  static void show(BuildContext context, {required String title, required String description}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return CustomErrorDialog(
          title: title,
          description: description,
        );
      },
    );
  }
}

