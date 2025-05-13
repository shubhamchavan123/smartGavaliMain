


import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InternetAlertWidget extends StatelessWidget {
  final Stream<ConnectivityResult> connectivityStream;

  const InternetAlertWidget({super.key, required this.connectivityStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final result = snapshot.data;
          if (result == ConnectivityResult.none) {
            Fluttertoast.showToast(
              msg: 'No internet connection. Please check your connection.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.02, // Adjust font size based on screen height
            );
          }
        }
        // Return an empty container if there's no issue
        return const SizedBox.shrink();
      },
    );
  }
}