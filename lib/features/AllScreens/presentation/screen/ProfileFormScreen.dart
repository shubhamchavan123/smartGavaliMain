
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiService/api_service.dart';
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
import 'ProfileScreen.dart';
// profile_form_screen.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  // controllers
  final TextEditingController nameController    = TextEditingController();
  final TextEditingController mobileController  = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // state
  File?   _selectedImage;        // new local pick
  String? _networkImageUrl;      // existing HTTP image
  int     userId     = 0;
  bool    _isLoading = false;

  // ── lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadUserDataFromPrefs();
  }

  // ── local storage helpers ──────────────────────────────────────────────────
  Future<void> _loadUserDataFromPrefs() async {
    final prefs          = await SharedPreferences.getInstance();
    final storedUserId   = prefs.getString('user_id');
    final userDataString = prefs.getString('userData');

    if (storedUserId != null) {
      userId = int.tryParse(storedUserId) ?? 0;
    }

    if (userDataString != null) {
      final userData = json.decode(userDataString);

      nameController.text    = userData['name']    ?? '';
      mobileController.text  = userData['mobile']  ?? '';
      addressController.text = userData['address'] ?? '';

      if (userId == 0 && userData['id'] != null) {
        userId = int.tryParse(userData['id'].toString()) ?? 0;
      }

      final profilePath = userData['profile'] ?? '';

      if (profilePath.toString().startsWith('http')) {
        _networkImageUrl = profilePath;
      } else if (profilePath.isNotEmpty) {
        final file = File(profilePath);
        if (await file.exists()) {
          _selectedImage = file;
        }
      }
    }

    setState(() {}); // refresh
  }

  // pick image from gallery
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage   = File(picked.path);
        _networkImageUrl = null;            // clear network preview
      });
    }
  }

  // ── save button handler ────────────────────────────────────────────────────
  Future<void> _saveProfileToServer() async {
    final name    = nameController.text.trim();
    final mobile  = mobileController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty || mobile.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सर्व माहिती भरा')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _uploadProfileData(
        name     : name,
        mobile   : mobile,
        address  : address,
        imageFile: _selectedImage,   // may be null
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── upload logic ───────────────────────────────────────────────────────────
  Future<bool> _uploadProfileData({
    required String name,
    required String mobile,
    required String address,
    File? imageFile,
  }) async {
    try {
      // If user did **not** pick a new one, but a network photo exists,
      // download it so the backend still receives an image part.
      if (imageFile == null && _networkImageUrl != null) {
        final res = await http.get(Uri.parse(_networkImageUrl!));
        if (res.statusCode == 200) {
          final mimeType  = lookupMimeType(_networkImageUrl!) ?? 'image/png';
          final ext       = mimeType.split('/').last;
          final dir       = await getTemporaryDirectory();
          final tempPath  = '${dir.path}/profile_existing.$ext';
          final tempFile  = File(tempPath);
          await tempFile.writeAsBytes(res.bodyBytes);
          imageFile = tempFile;
        }
      }

      // Still nothing? Ask user to pick a picture – backend requires it.
      if (imageFile == null) {
        Fluttertoast.showToast(msg: 'Please select a profile image');
        return false;
      }

      final request = http.MultipartRequest('POST', ApiService.updateProfile)
        ..fields.addAll({
          'user_id': userId.toString(),
          'name'   : name,
          'mobile' : mobile,
          'address': address,
        })
        ..headers.addAll({
          'Accept'    : 'application/json',
          'Connection': 'keep-alive',
        });

      final mimeType  = lookupMimeType(imageFile.path) ?? 'image/png';
      final ext       = mimeType.split('/').last;
      final fileName  =
          'profile_${DateTime.now().millisecondsSinceEpoch}.$ext';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename   : fileName,
          contentType: MediaType('image', ext),
        ),
      );

      final streamed  = await request.send();
      final body      = await streamed.stream.bytesToString();
      final data      = json.decode(body);

      if (streamed.statusCode == 200 && data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'userData',
          json.encode({
            'id'     : userId.toString(),
            'name'   : name,
            'mobile' : mobile,
            'address': address,
            'profile': imageFile.path,          // now a local path
          }),
        );
        Fluttertoast.showToast(
          msg: data['message'] ?? 'Profile updated',
        );
        return true;
      }

      Fluttertoast.showToast(
        msg: data['message'] ?? 'Profile upload failed',
      );
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      return false;
    }
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'प्रोफाइल',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // avatar picker
            Center(
              child: Stack(
                children: [
                  // CircleAvatar(
                  //   radius: 50,
                  //   backgroundImage: _selectedImage != null
                  //       ? FileImage(_selectedImage!)
                  //       : (_networkImageUrl != null
                  //       ? NetworkImage(_networkImageUrl!)
                  //       : const AssetImage(
                  //       'assets/icons/profile_img.png')
                  //   as ImageProvider),
                  // ),

                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (_networkImageUrl != null && _networkImageUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(_networkImageUrl!)
                        : const AssetImage('assets/icons/profile_img.png')
                    as ImageProvider),
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

            // name
            const Text("Name",
                style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Your full name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // mobile
            const Text("Mobile Number",
                style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Mobile number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // address
            const Text("Address",
                style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: "Your full address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfileToServer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
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
  String? _networkImageUrl;
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
      nameController.text = userData['name'] ?? '';
      mobileController.text = userData['mobile'] ?? '';
      addressController.text = userData['address'] ?? '';

      if (userId == 0 && userData['id'] != null) {
        userId = int.tryParse(userData['id'].toString()) ?? 0;
      }

      final profilePath = userData['profile'] ?? '';
      if (profilePath.toString().startsWith('http')) {
        _networkImageUrl = profilePath;
      } else {
        final file = File(profilePath);
        if (await file.exists()) {
          _selectedImage = file;
        }
      }
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _networkImageUrl = null;
      });
    }
  }
  Future<void> _saveProfileToServer() async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty || mobile.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // if (_selectedImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please select profile image')));
    //   return;
    // }

    final imageFile = _selectedImage!;
    if (!await imageFile.exists() || await imageFile.length() == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid image file')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _uploadProfileData(imageFile, name, mobile, address);
      if (success) {
        // ✅ Navigate to ProfileScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload profile')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _uploadProfileData(File imageFile, String name, String mobile, String address) async {
    try {
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/png';
      final extension = mimeType.split('/').last;
      final filename = 'profile_${DateTime.now().millisecondsSinceEpoch}.$extension';

      final request = http.MultipartRequest('POST', ApiService.updateProfile);
      request.fields.addAll({
        'user_id': userId.toString(),
        'name': name,
        'mobile': mobile,
        'address': address,
      });
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

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', json.encode({
          'id': userId.toString(),
          'name': name,
          'mobile': mobile,
          'address': address,
          'profile': imageFile.path,
        }));
        Fluttertoast.showToast(msg: data['message'] ?? 'Profile saved successfully');
        return true;
      }

      Fluttertoast.showToast(msg: data['message'] ?? 'Profile upload failed');
      return false;
    } catch (e) {
      print('Profile upload error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('प्रोफाइल',  style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        padding: const EdgeInsets.all(20),
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
                        : (_networkImageUrl != null
                        ? NetworkImage(_networkImageUrl!)
                        : const AssetImage('assets/icons/profile_img.png'))
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
                        child: Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("Name", style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Your full name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("Mobile Number", style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "Mobile number", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("Address", style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(hintText: "Your full address", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfileToServer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Profile', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/
