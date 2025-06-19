
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/smart_login_screen.dart';
import 'package:smart_gawali/features/home/presentation/screen/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/firebase_options.dart';
import 'package:smart_gawali/provider/calcium_mineral_product_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'features/AllScreens/presentation/screen/CheckoutScreen.dart';

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Required for background
  if (message.data.containsKey('url')) {
    final url = message.data['url'];
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Subscribe to 'all' topic
  await FirebaseMessaging.instance.subscribeToTopic('all');

  // Initialize provider before running the app
  final cartProvider = CalciumMineralProductProvider();
  await cartProvider.loadCartFromPreferences(); // Preload cart



  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CalciumMineralProductProvider>.value(value: cartProvider),

        // Other providers
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Gawali',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(),
          // MaterialPageRoute(builder: (_) => CheckoutScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Padding(
              padding: const EdgeInsets.only(right: 22.0),
              child: Image.asset('assets/images/splash_screen.png', height: 520),
            )), // Make sure the asset exists
          ],
        ),
      ),
    );
  }
}


