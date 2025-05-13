import 'package:flutter/material.dart';
import 'package:smart_gawali/features/login/presentation/screen/ProfileFormScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/smart_login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Important for gradient visibility
        title: Text(
          'प्रोफाइल',
          style: TextStyle(
            color: Colors.black, // Title color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {

            },
          ),
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2E7D32), // Green at top
                Color(0xFFFFFFFF), // White at bottom
              ],
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
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/user.png'), // Replace with actual image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  ProfileFormScreen(),
                        ),
                      );
                    },
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
          // Your settings list
           ProfileMenuItem(title: "सेटिंग"),
           ProfileMenuItem(title: '" माझी विक्री "'),
        ProfileMenuItem(
          title: "लॉग आऊट",
          onTap: () {
            showLogoutDialog(context);
          },
        ),


          Spacer(),
           Text(
            "खरेदीसाठी टाका",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
      ),
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
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 35,
              child: Icon(Icons.logout, color: Colors.white, size: 40),
            ),
            SizedBox(height: 16),
            Text('तुम्हाला खात्रीने लॉग आऊट करायचे आहे का?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context), // Cancel
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('रद्द करा', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context); // Close dialog first
                      await logout(context);  // Then perform logout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('हो', style: TextStyle(color: Colors.white)),
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
