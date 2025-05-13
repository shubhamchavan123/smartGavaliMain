import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class CustomLoaderDialog extends StatelessWidget {
  const CustomLoaderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed background
        Opacity(
          opacity: 0.5,
          child: Container(
            color: Colors.black,
          ),
        ),
        // Centered loader
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.threeArchedCircle(
                color: Colors.blue,
                size: 70,
              ),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
      ],
    );
  }
}
