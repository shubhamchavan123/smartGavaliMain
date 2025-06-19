import 'package:flutter/material.dart';
import 'package:smart_gawali/features/home/presentation/screen/HomeScreen.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/MyPurchaseScreen.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/ProfileFormScreen.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/smart_login_screen.dart';

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../ApiService/api_service.dart';
import '../../../registration/presentation/screen/registration_screen.dart';
import 'SoldOutPostScreen.dart';
import 'SubscriptionScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String _name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load both image and name
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      final imagePath = userData['imagePath'] ?? '';
      final name = userData['name'] ?? '';

      if (imagePath.toString().isNotEmpty && File(imagePath).existsSync()) {
        setState(() {
          _profileImage = File(imagePath);
        });
      }

      setState(() {
        _name = name;
      });
    }
  }


  Future<void> _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileFormScreen()),
    );
    await _loadUserData(); // ✅ Reload image after editing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'प्रोफाइल',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/icons/dummy_profile_ic.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _navigateToEditProfile,
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.brown,
                      child: Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // const ProfileMenuItem(title: "सेटिंग"),
          Text(
            _name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          ProfileMenuItem(
            title: "माझी खरेदी",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyPurchaseScreen(),
                ),
              );
            },
          ),
          // const ProfileMenuItem(title: "",),
          ProfileMenuItem(
            title: "माझी विक्री",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SoldOutPostScreen(),
                ),
              );
            },
          ),

          ProfileMenuItem(
            title: "नवीन सदस्यता",
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final userIdStr = prefs.getString('user_id') ?? '0';
              final userId = int.tryParse(userIdStr) ?? 0;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubscriptionScreen(userId: userId),
                ),
              );
            },
          ),

          ProfileMenuItem(
            title: "लॉग आऊट",
            onTap: () {
              showLogoutDialog(context);
            },
          ),
          ProfileMenuItem(
            title: "डिलिट आऊट",
            onTap: () {
              showDeleteDialog(context);
            },
          ),


          // const Spacer(),
          // // const Text(
          // //   "खरेदीसाठी टाका",
          // //   style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          // // ),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '0';
    print("Saved user_id: $userId");

    if (userId == '0') {
      print("❗ user_id is not set properly in SharedPreferences");
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
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
              const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 35,
                child: Icon(Icons.delete, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'तुम्हाला खातं कायमचं हटवायचं आहे का?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('रद्द करा',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close dialog

                        final response = await deleteUserAccount(userId);
                        if (response != null && response.status == "success") {
                          await prefs.clear();

                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
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
                                    const CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 35,
                                      child: Icon(Icons.check,
                                          color: Colors.white, size: 40),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      response.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationScreen()),
                                              (Route<dynamic> route) => false,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 32),
                                      ),
                                      child: const Text('ठीक आहे',
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
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
                                    const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 35,
                                      child: Icon(Icons.error,
                                          color: Colors.white, size: 40),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      response?.message ??
                                          "खातं हटवण्यात अयशस्वी.",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 32),
                                      ),
                                      child: const Text('ठीक आहे',
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                      const Text('हो', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*void showDeleteDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '0';
    print("Saved user_id: $userId");

    if (userId == '0') {
      print("❗ user_id is not set properly in SharedPreferences");
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("खातं हटवा"),
        content: const Text("तुम्हाला खातं कायमचं हटवायचं आहे का?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("रद्द करा"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog

              final response = await deleteUserAccount(userId);
              if (response != null && response.status == "success") {
                // Optional: Clear saved user_id
                await prefs.clear();

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("यशस्वी"),
                    content: Text(response.message),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => RegistrationScreen()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text("ठीक आहे"),
                      ),
                    ],
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("त्रुटी"),
                    content: Text(response?.message ?? "खातं हटवण्यात अयशस्वी."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("ठीक आहे"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text("हो"),
          ),
        ],
      ),
    );
  }*/


  Future<DeleteAccountResponse?> deleteUserAccount(String userId) async {
    // const url = 'https://sks.sitsolutions.co.in/delete_account';
    try {
      print('Deleting user with ID: $userId');

      final response = await http.post(
        ApiService.deleteAccount,
        // Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("Parsed JSON: $jsonData");
        return DeleteAccountResponse.fromJson(jsonData);
      } else {
        print('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Delete Account Error: $e');
      return null;
    }
  }



}
class DeleteAccountResponse {
  final String status;
  final String message;

  DeleteAccountResponse({
    required this.status,
    required this.message,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}



class ProfileMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
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
            const CircleAvatar(
              backgroundColor: Colors.red,
              radius: 35,
              child: Icon(Icons.logout, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'तुम्हाला खात्रीने लॉग आऊट करायचे आहे का?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('रद्द करा',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:
                        const Text('हो', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
