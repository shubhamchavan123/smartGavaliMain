import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/features/login/presentation/screen/smart_login_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/provider/calcium_mineral_product_provider.dart';
import 'features/home/presentation/screen/HomeScreen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CalciumMineralProductProvider()),
      // other providers
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This function checks the login status
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          // Show loading indicator while checking login status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If data is available, decide which screen to show
          if (snapshot.hasData) {
            return snapshot.data! ? HomeScreen() : LoginScreen();
          }

          // If there's an error, default to login screen
          return LoginScreen();
        },
      ),
    );
  }
}
