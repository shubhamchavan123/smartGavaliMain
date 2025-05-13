import 'package:flutter/material.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[900], // Set your desired background color here
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.white),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
