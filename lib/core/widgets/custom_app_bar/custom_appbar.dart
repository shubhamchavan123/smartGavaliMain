import 'package:flutter/material.dart';

import '../../local_assets/common_images.dart';
import '../../theme_style/ken_theme_generator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onLeadingPressed;

  CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate font size based on screens width
    final double fontSize = screenWidth * 0.040; // Adjust the multiplier as needed

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: ThemeGenerator.appBarTextColor,
        ),
      ),
      leading: IconButton(
        icon: ImageIcon(
          AssetImage(LocalAssets.back_arrow),
          size: screenWidth * 0.075,
          color: ThemeGenerator.appBarTextColor,
        ),
        onPressed: onLeadingPressed ?? () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: ThemeGenerator.appBarBgColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}