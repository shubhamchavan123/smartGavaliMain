
import 'package:flutter/material.dart';

AlertDialog featureYetToComeAlert(
    {required BuildContext context, required double width}) {
  final mediaQuery = MediaQuery.of(context);
  final dialogHeight = mediaQuery.size.height * 0.25; // 25% of the screen height
  final dialogWidth = mediaQuery.size.width * 0.75;  // 75% of the screen width
  final iconSize = mediaQuery.size.width * 0.09; // Icon size relative to screen width
  final titleFontSize = mediaQuery.size.width * 0.045; // Title font size relative to screen width
  final contentFontSize = mediaQuery.size.width * 0.035; // Content font size relative to screen width
  final padding = mediaQuery.size.width * 0.05; // Padding relative to screen width

  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    backgroundColor: Colors.transparent,
    content: Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: dialogHeight,
      width: dialogWidth,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, size: iconSize),
            SizedBox(height: mediaQuery.size.height * 0.02), // Spacing relative to height
            Text(
              'Feature Yet to Come',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.01),
            Text(
              'This feature is currently under development. Please check back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: contentFontSize,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
