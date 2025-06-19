import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:smart_gawali/features/AllScreens/presentation/screen/smart_login_screen.dart';

import '../../../ApiService/api_service.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final url = ApiService.doRegisterUrl;

    try {
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
        if (jsonResponse['status'].toString() == 'true' || jsonResponse['success'].toString() == 'true') {
          showSuccessDialog(context, jsonResponse['message'] ?? 'नोंदणी यशस्वी झाली!');
        } else {
          // Check if the error message indicates the user is already registered
          bool isAlreadyRegistered = jsonResponse['message']?.toString().toLowerCase().contains('already') ?? false;
          showErrorDialog(
              context,
              jsonResponse['message'] ?? 'नोंदणी अयशस्वी',
              isAlreadyRegistered: isAlreadyRegistered
          );
        }
      } else {
        showErrorDialog(context, 'सर्व्हर त्रुटी: ${response.statusCode}');
      }
    } catch (e) {
      showErrorDialog(context, 'नेटवर्क त्रुटी: $e');
    }
  }

  void showSuccessDialog(BuildContext context, String message) {
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
                  backgroundColor: Colors.green, // Green for success
                  radius: 35,
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
                SizedBox(height: 16),
                Text(
                  'नोंदणी यशस्वी',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

  void showErrorDialog(BuildContext context, String message, {bool isAlreadyRegistered = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: isAlreadyRegistered ? Colors.red : Colors.green,
                radius: 35,
                child: Icon(
                    isAlreadyRegistered ? Icons.error : Icons.check,
                    color: Colors.white,
                    size: 40
                ),
              ),
              SizedBox(height: 16),
              Text(
                isAlreadyRegistered ? 'त्रुटी' : 'यशस्वी',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isAlreadyRegistered) {
                      Navigator.pop(context); // Just close the dialog
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAlreadyRegistered ? Colors.red : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('ठीक आहे', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
/*
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
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
                child: Icon(Icons.verified, color: Colors.white, size: 40),
              ),
              SizedBox(height: 16),
              // Text('त्रुटी',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('ठीक आहे', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
*/



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('नोंदणी करा',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 5),
                  Text('Welcome back', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  SizedBox(height: 20),
                  Image.asset('assets/images/login_logo.png', height: 250),
                  SizedBox(height: 20),

                  /// First Name
                  buildLabel('पहिलं नाव'),
            /*      buildTextField(
                    controller: firstNameController,
                    hintText: 'पहिलं नाव टाका',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'पहिलं नाव आवश्यक आहे';
                      }
                      if (value.contains(' ')) {
                        return 'स्पेसची परवानगी नाही';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Blocks spaces
                    ],
                  ),*/
                buildTextField(
                  controller: firstNameController,
                  hintText: 'पहिलं नाव टाका',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'पहिलं नाव आवश्यक आहे';
                    }

                    final RegExp nameRegExp = RegExp(r'^[a-zA-Zअ-हऀ-ॿ]+$');
                    if (!nameRegExp.hasMatch(value.trim())) {
                      return 'फक्त पहिलं नाव टाका (फक्त अक्षरे, स्पेस नाही)';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zअ-हऀ-ॿ]')), // Only letters, no spaces
                  ],
                ),



                // buildTextField(
                  //   controller: firstNameController,
                  //   hintText: 'पहिलं नाव टाका',
                  //   icon: Icons.person,
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) return 'पहिलं नाव आवश्यक आहे';
                  //     return null;
                  //   },
                  // ),

                  /// Last Name
                  buildLabel('आडनाव'),


                  /*buildTextField(
                    controller: lastNameController,
                    hintText: 'आडनाव नाव टाका',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'आडनाव नाव आवश्यक आहे';
                      }
                      if (value.contains(' ')) {
                        return 'स्पेसची परवानगी नाही';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Blocks spaces
                    ],
                  ),*/
                buildTextField(
                  controller: lastNameController,
                  hintText: 'आडनाव टाका',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'आडनाव आवश्यक आहे';
                    }

                    final RegExp nameRegExp = RegExp(r'^[a-zA-Zअ-हऀ-ॿ]+$');
                    if (!nameRegExp.hasMatch(value.trim())) {
                      return 'फक्त अक्षरे टाका (स्पेस व संख्या नाही)';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zअ-हऀ-ॿ]')),
                  ],
                ),



                // buildTextField(
                  //   controller: lastNameController,
                  //   hintText: 'आडनाव टाका',
                  //   icon: Icons.person_outline,
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) return 'आडनाव आवश्यक आहे';
                  //     return null;
                  //   },
                  // ),


                  /// Mobile Number
                  buildLabel('मोबाईल नंबर'),
                  buildTextField(
                    controller: mobileController,
                    hintText: 'मोबाईल नंबर टाका',
                    icon: Icons.phone,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'मोबाईल नंबर आवश्यक आहे';
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) return 'वैध मोबाईल नंबर टाका';
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),


                  /// Username (reusing mobileController here is not ideal – can add separate controller if needed)
                  /*   buildLabel('वापरकर्ता नाव'),
                  buildTextField(
                    controller: mobileController,
                    hintText: '',
                    icon: Icons.person,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'वापरकर्ता नाव आवश्यक आहे';
                      return null;
                    },
                  ),*/

                  /// Password
                  buildLabel('पासवर्ड'),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'पासवर्ड टाका',
                        prefixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'पासवर्ड आवश्यक आहे';
                        if (value.length < 8) return 'किमान 8 अक्षरे असावीत';
                        return null;
                      },
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters, // <-- Add this
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters, // <-- Use here
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

}
