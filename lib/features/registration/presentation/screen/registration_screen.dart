import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_gawali/features/login/presentation/screen/smart_login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  Future<void> registerUser() async {
    final url = Uri.parse('https://sks.sitsolutions.co.in/do_register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "mobile": mobileController.text.trim(),
        "password": passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true || jsonResponse['success'] == true) {
        showSuccessDialog(context);
      } else {
        showErrorDialog(context, jsonResponse['message'] ?? 'नोंदणी अयशस्वी');
      }
    } else {
      showErrorDialog(context, 'सर्व्हर त्रुटी: ${response.statusCode}');
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 35,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'नोंदणी यशस्वी',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false, // Remove all previous routes
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('पुढे', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('त्रुटी'),
        content: Text(message),
        actions: [

          TextButton(
            onPressed: () {

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );

            },
            child: Text('ठीक आहे'),
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('नोंदणी करा',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                SizedBox(height: 5),
                Text('Welcome back',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 20),
                Image.asset('assets/images/smart.png', height: 100),
                Image.asset('assets/images/login_logo.png', height: 140),
                Image.asset('assets/images/gawali.png', height: 140),
                SizedBox(height: 20),

                /// First Name
                buildLabel('पहिलं नाव'),
                buildTextField(
                    controller: firstNameController,
                    hintText: 'पहिलं नाव टाका',
                    icon: Icons.person),

                /// Last Name
                buildLabel('आडनाव'),
                buildTextField(
                    controller: lastNameController,
                    hintText: 'आडनाव टाका',
                    icon: Icons.person_outline),

                /// Mobile
                buildLabel('मोबाईल नंबर'),
                buildTextField(
                    controller: mobileController,
                    hintText: 'मोबाईल नंबर टाका',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone),

                buildLabel('वापरकर्ता नाव'),
                buildTextField(
                    controller: mobileController,
                    hintText: '',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone),

                /// Password
                buildLabel('पासवर्ड'),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'पासवर्ड टाका',
                    prefixIcon: Icon(Icons.lock),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),

                /// Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('नोंदणी करा',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 20),
      child: Row(
        children: [
          Text(
            label,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
        required String hintText,
        required IconData icon,
        TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
