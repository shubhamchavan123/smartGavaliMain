// import 'dart:convert';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/login/presentation/screen/ForgotPasswordScreen.dart';

import '../../../ApiService/api_service.dart';
import '../../../home/presentation/screen/HomeScreen.dart';
import 'package:smart_gawali/features/registration/presentation/screen/registration_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     if (isLoggedIn) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => HomeScreen()),
//       );
//     }
//   }
//
//
//   Future<void> _saveUserData(Map<String, dynamic> userData) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // Extract values
//     final id = userData['id']?.toString() ?? '';
//     final name = userData['name']?.toString() ?? '';
//     final mobile = userData['mobile']?.toString() ?? '';
//     final userId = userData['user_id']?.toString() ?? '';
//
//     // Save values
//     await prefs.setString('userData', json.encode(userData));
//     await prefs.setString('id', id);
//     await prefs.setString('name', name);
//     await prefs.setString('mobile', mobile);
//     await prefs.setString('user_id', userId);
//     await prefs.setBool('isLoggedIn', true);
//
//     print("Saved ID: $id");
//     print("Saved Name: $name");
//       print("Saved Mobile: $mobile");
//     print("Saved user_id: $userId");
//   }
//
//   Future<void> loginUser() async {
//     final String mobile = mobileController.text.trim();
//     final String password = passwordController.text.trim();
//
//     if (mobile.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('कृपया मोबाईल नंबर आणि पासवर्ड भरा')),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       print("Sending: username=$mobile, password=$password");
//
//       final response = await http.post(
//         Uri.parse('https://sks.sitsolutions.co.in/do_login'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'username': mobile,
//           'password': password,
//         }),
//       );
//
//       print("Status Code: ${response.statusCode}");
//       print("Response: ${response.body}");
//
//       final jsonData = json.decode(response.body);
//       print('Response: $jsonData');
//
//       if (jsonData['status'] == 'success') {
//         await _saveUserData(jsonData['details']);
//         showSuccessDialog(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(jsonData['message'] ?? 'Login failed')),
//         );
//       }
//     } catch (e) {
//       print('Login error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('सर्व्हर त्रुटी. कृपया पुन्हा प्रयत्न करा')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('लॉग इन अकाउंट',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 5),
//                 Text('Welcome back',
//                     style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//                 SizedBox(height: 20),
//                 Image.asset('assets/images/smart.png', height: 100),
//                 Image.asset('assets/images/login_logo.png', height: 140),
//                 Image.asset('assets/images/gawali.png', height: 140),
//                 SizedBox(height: 10),
//                 _buildLabel('मोबाईल नंबर'),
//                 SizedBox(height: 10),
//                 _buildTextField(
//                   controller: mobileController,
//                   hintText: 'मोबाईल नंबर टाका',
//                   prefixIcon: Icons.phone,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 SizedBox(height: 20),
//                 _buildLabel('पासवर्ड'),
//                 SizedBox(height: 10),
//                 _buildTextField(
//                   controller: passwordController,
//                   hintText: 'पासवर्ड टाका',
//                   prefixIcon: Icons.lock,
//                   obscureText: _obscurePassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                         _obscurePassword ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () =>
//                         setState(() => _obscurePassword = !_obscurePassword),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : loginUser,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: isLoading
//                         ? CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                       'लॉगिन करा',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => RegistrationScreen()),
//                     );
//                   },
//                   child: Text('Registration', style: TextStyle(color: Colors.blue)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLabel(String text) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 10.0),
//           child: Text(
//             text,
//             textAlign: TextAlign.start,
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData prefixIcon,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: Icon(prefixIcon),
//         suffixIcon: suffixIcon,
//         contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//     );
//   }
// }
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    final id = userData['id']?.toString() ?? '';
    final name = userData['name']?.toString() ?? '';
    final mobile = userData['mobile']?.toString() ?? '';
    final userId = userData['user_id']?.toString() ?? '';

    await prefs.setString('userData', json.encode(userData));
    await prefs.setString('id', id);
    await prefs.setString('name', name);
    await prefs.setString('mobile', mobile);
    await prefs.setString('user_id', userId);
    await prefs.setBool('isLoggedIn', true);

    print("Saved ID: $id");
    print("Saved Name: $name");
    print("Saved Mobile: $mobile");
    print("Saved user_id: $userId");
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) {
      // If form is not valid, don't proceed.
      return;
    }

    final String mobile = mobileController.text.trim();
    final String password = passwordController.text.trim();

    setState(() => isLoading = true);

    try {
      print("Sending: username=$mobile, password=$password");

      final response = await http.post(
          ApiService.doLoginUrl,
        // Uri.parse('https://sks.sitsolutions.co.in/do_login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': mobile,
          'password': password,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      final jsonData = json.decode(response.body);
      print('Response: $jsonData');

      if (jsonData['status'] == 'success') {
        await _saveUserData(jsonData['details']);
        showSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonData['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('सर्व्हर त्रुटी. कृपया पुन्हा प्रयत्न करा')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

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
                  Text('लॉग इन अकाउंट',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Welcome back',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  SizedBox(height: 20),
                  Image.asset('assets/images/smart.png', height: 100),
                  Image.asset('assets/images/login_logo.png', height: 140),
                  Image.asset('assets/images/gawali.png', height: 140),
                  SizedBox(height: 10),
                  _buildLabel('मोबाईल नंबर'),
                  SizedBox(height: 10),
                  _buildMobileTextFormField(),
                  SizedBox(height: 20),
                  _buildLabel('पासवर्ड'),
                  SizedBox(height: 10),
                  _buildPasswordTextFormField(),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'लॉगिन करा',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegistrationScreen()),
                          );
                        },
                        child: Text('Registration', style: TextStyle(color: Colors.blue)),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text('Forgot Password', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileTextFormField() {
    return TextFormField(
      controller: mobileController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        hintText: 'मोबाईल नंबर टाका',
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'मोबाईल नंबर आवश्यक आहे';
        }
        // Simple mobile number validation (India-style 10 digits)
        final pattern = RegExp(r'^[6-9]\d{9}$');
        if (!pattern.hasMatch(value.trim())) {
          return 'वैध मोबाईल नंबर टाका';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordTextFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'पासवर्ड टाका',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon:
          Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'पासवर्ड आवश्यक आहे';
        }
        if (value.trim().length < 6) {
          return 'पासवर्ड किमान 6 अक्षरे असावे';
        }
        return null;
      },
    );
  }
}

void showSuccessDialog(BuildContext context) {
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
              child: Icon(Icons.check, color: Colors.white, size: 40),
            ),
            SizedBox(height: 16),
            Text('लॉग इन यशस्वी',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => HomeScreen()),
                  // );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
    ),
  );
}

// Utility function to get user data from SharedPreferences
Future<Map<String, dynamic>?> getUserData() async {
  final prefs = await SharedPreferences.getInstance();

  final userDataString = prefs.getString('userData');
  if (userDataString != null) {
    return json.decode(userDataString);
  }
  return null;
}

// Utility function for logout
Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userData');
  await prefs.setBool('isLoggedIn', false);
  // ✅ Navigate to login screen and remove all previous routes
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) =>  LoginScreen()),
        (Route<dynamic> route) => false,
  );
}
