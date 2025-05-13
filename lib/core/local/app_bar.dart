import 'package:flutter/material.dart';

class KanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KanAppBar({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      centerTitle: false,
      title: Text(title, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(3);
}
