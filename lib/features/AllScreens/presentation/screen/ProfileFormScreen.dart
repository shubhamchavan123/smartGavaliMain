// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:mime/mime.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ProfileFormScreen extends StatefulWidget {
//   const ProfileFormScreen({super.key});
//
//   @override
//   State<ProfileFormScreen> createState() => _ProfileFormScreenState();
// }
//
// class _ProfileFormScreenState extends State<ProfileFormScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//
//   File? _selectedImage;
//   String? _networkImageUrl;
//   int userId = 0;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserDataFromPrefs().then((_) {
//       if (userId != 0) {
//         _fetchUserDetailsFromServer();
//       }
//     });
//   }
//
//   Future<void> _loadUserDataFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedUserId = prefs.getString('user_id');
//     if (storedUserId != null) {
//       userId = int.tryParse(storedUserId) ?? 0;
//     }
//   }
//
//   Future<void> _fetchUserDetailsFromServer() async {
//     final url = Uri.parse('https://sks.sitsolutions.co.in/user_details');
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {'user_id': userId.toString()},
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'success') {
//           final user = data['details'];
//           setState(() {
//             nameController.text = user['name'] ?? '';
//             mobileController.text = user['mobile'] ?? '';
//             addressController.text = user['address'] ?? '';
//             _networkImageUrl = user['image'];
//             _selectedImage = null;
//           });
//
//           await _saveUserData({
//             'id': user['id'].toString(),
//             'name': user['name'],
//             'mobile': user['mobile'],
//             'address': user['address'] ?? '',
//             'imagePath': user['image'] ?? '',
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(data['message'] ?? 'Failed to load profile')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Server error: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final pickedFile =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Image selection error: $e')),
//       );
//     }
//   }
//
//   Future<void> _saveUserData(Map<String, dynamic> userData) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userData', json.encode(userData));
//     await prefs.setString('id', userData['id'].toString());
//     await prefs.setString('name', userData['name']);
//     await prefs.setString('mobile', userData['mobile']);
//     await prefs.setString('address', userData['address']);
//     await prefs.setString('user_id', userData['id'].toString());
//     await prefs.setString('imagePath', userData['imagePath']);
//     await prefs.setBool('isLoggedIn', true);
//   }
//
//   Future<void> _saveProfileToServer() async {
//     final name = nameController.text.trim();
//     final mobile = mobileController.text.trim();
//     final address = addressController.text.trim();
//
//     if (name.isEmpty || mobile.isEmpty || address.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }
//
//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select profile image')),
//       );
//       return;
//     }
//
//     final imageFile = _selectedImage!;
//     if (!await imageFile.exists() || await imageFile.length() == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid image file')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       var success = await _uploadProfileData(imageFile, name, mobile, address);
//       if (!success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to upload profile')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<bool> _uploadProfileData(
//       File imageFile, String name, String mobile, String address) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('https://sks.sitsolutions.co.in/update_profile'),
//       );
//
//       request.fields.addAll({
//         'user_id': userId.toString(),
//         'name': name,
//         'mobile': mobile,
//         'address': address,
//       });
//
//       final mimeType = lookupMimeType(imageFile.path) ?? 'image/png';
//       final extension = mimeType.split('/').last;
//       final filename = 'profile_${DateTime.now().millisecondsSinceEpoch}.$extension';
//
//       request.files.add(await http.MultipartFile.fromPath(
//         'image',
//         imageFile.path,
//         filename: filename,
//         contentType: MediaType('image', extension),
//       ));
//
//       request.headers.addAll({
//         'Accept': 'application/json',
//         'Connection': 'keep-alive',
//       });
//
//       /// 🔍 Debug Logging
//       print("📤 Sending profile update request...");
//       print("➡️ Endpoint: ${request.url}");
//       print("📦 Fields: ${request.fields}");
//       print("🖼️ Image: ${imageFile.path}");
//
//       var response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//
//       /// 📥 Log Response
//       print("✅ Response Status: ${response.statusCode}");
//       print("📨 Response Body: $responseBody");
//
//       // var response = await request.send();
//       // final responseBody = await response.stream.bytesToString();
//       //
//       // // 🛠️ Debug: Print full response
//       // print("✅ Response Status Code: ${response.statusCode}");
//       // print("📨 Response Body: $responseBody");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(responseBody);
//         if (data['status'] == 'success') {
//           await _saveUserData({
//             'id': userId.toString(),
//             'name': name,
//             'mobile': mobile,
//             'address': address,
//             'imagePath': imageFile.path,
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(data['message'] ?? 'Profile updated')),
//           );
//           return true;
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(data['message'] ?? 'Update failed')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Server error: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       print("❌ Upload error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload error: $e')),
//       );
//     }
//     return false;
//   }
//
//   Widget _buildLabel(String label) {
//     return Text(label, style: const TextStyle(fontWeight: FontWeight.w600));
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: const OutlineInputBorder(),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         centerTitle: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _selectedImage != null
//                         ? FileImage(_selectedImage!)
//                         : (_networkImageUrl != null
//                         ? NetworkImage(_networkImageUrl!)
//                         : const AssetImage('assets/icons/dummy_profile_ic.png')
//                     ) as ImageProvider,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: _pickImage,
//                       child: const CircleAvatar(
//                         radius: 16,
//                         backgroundColor: Colors.brown,
//                         child: Icon(Icons.edit, size: 16, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildLabel("Name"),
//             _buildTextField(controller: nameController, hintText: "Your full name"),
//             const SizedBox(height: 16),
//             _buildLabel("Mobile Number"),
//             _buildTextField(
//               controller: mobileController,
//               hintText: "Mobile number",
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             _buildLabel("Address"),
//             _buildTextField(controller: addressController, hintText: "Your full address"),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _saveProfileToServer,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text('Save Profile', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiService/api_service.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _selectedImage;
  int userId = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserDataFromPrefs();
  }

  Future<void> _loadUserDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    final storedUserId = prefs.getString('user_id');

    if (storedUserId != null) {
      userId = int.tryParse(storedUserId) ?? 0;
    }

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      setState(() {
        nameController.text = userData['name'] ?? '';
        mobileController.text = userData['mobile'] ?? '';
        addressController.text = userData['address'] ?? '';
        if (userId == 0 && userData['id'] != null) {
          userId = int.tryParse(userData['id'].toString()) ?? 0;
        }
        if (userData['imagePath'] != null &&
            userData['imagePath'].toString().isNotEmpty) {
          _selectedImage = File(userData['imagePath']);
        }
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selection error: $e')),
      );
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', json.encode(userData));
    await prefs.setString('id', userData['id'].toString());
    await prefs.setString('name', userData['name']);
    await prefs.setString('mobile', userData['mobile']);
    await prefs.setString('address', userData['address']);
    await prefs.setString('user_id', userData['id'].toString());
    await prefs.setString('imagePath', userData['imagePath']);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _saveProfileToServer() async {
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not available')),
      );
      return;
    }

    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty || mobile.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select profile image')),
      );
      return;
    }

    final imageFile = _selectedImage!;
    if (!await imageFile.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image file not found')),
      );
      return;
    }

    final fileSize = await imageFile.length();
    if (fileSize == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image file is empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var success = await _uploadProfileData(imageFile, name, mobile, address);

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload profile')),
        );
      }
    } catch (e) {
      print('Error in _saveProfileToServer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _uploadProfileData(
      File imageFile, String name, String mobile, String address) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        ApiService.updateProfile,
        // Uri.parse('https://sks.sitsolutions.co.in/update_profile'),
      );

      request.fields.addAll({
        'user_id': userId.toString(),
        'name': name,
        'mobile': mobile,
        'address': address,
      });

      final mimeType = lookupMimeType(imageFile.path) ?? 'image/png';
      final extension = mimeType.split('/').last;
      final filename =
          'profile_${DateTime.now().millisecondsSinceEpoch}.$extension';

      // Using 'image' as the field name as required by the server
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: filename,
        contentType: MediaType('image', extension),
      ));

      request.headers.addAll({
        'Accept': 'application/json',
        'Connection': 'keep-alive',
      });

      print('Sending multipart request...');
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Server response: $responseBody');

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        if (data['status'] == 'success') {
          await _saveUserData({
            'id': userId.toString(),
            'name': name,
            'mobile': mobile,
            'address': address,
            'imagePath': imageFile.path,
          });
          Fluttertoast.showToast(
            msg: data['message'] ?? 'Profile saved successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        } else {
          Fluttertoast.showToast(
            msg: data['message'] ?? 'Failed to save profile',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
      return false;
    } catch (e) {
      print('Profile upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload error: $e')),
      );
      return false;
    }
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : const AssetImage(
                                      'assets/icons/dummy_profile_ic.png')
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.brown,
                              child: Icon(Icons.edit,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Name"),
                  _buildTextField(
                      controller: nameController, hintText: "Your full name"),
                  const SizedBox(height: 16),
                  _buildLabel("Mobile Number"),
                  _buildTextField(
                    controller: mobileController,
                    hintText: "Mobile number",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Address"),
                  _buildTextField(
                      controller: addressController,
                      hintText: "Your full address"),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfileToServer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(fontSize: 16,color: Colors.white, )
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
