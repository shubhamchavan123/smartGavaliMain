import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  int userId = 0; // Will be loaded from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUserDataFromPrefs();
  }

  Future<void> _loadUserDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    final storedUserId = prefs.getString('user_id') ?? '0';

    setState(() {
      userId = int.tryParse(storedUserId) ?? 0;
    });

    print("Loaded user_id from SharedPreferences: $userId");

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      setState(() {
        nameController.text = userData['name'] ?? '';
        mobileController.text = userData['mobile'] ?? '';
        addressController.text = userData['address'] ?? '';
        if (userData['imagePath'] != null &&
            userData['imagePath'].toString().isNotEmpty) {
          _selectedImage = File(userData['imagePath']);
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    final id = userData['id']?.toString() ?? '';
    final name = userData['name']?.toString() ?? '';
    final mobile = userData['mobile']?.toString() ?? '';
    final address = userData['address']?.toString() ?? '';
    final userIdStr = userId.toString();
    print("Saved user_id: $userIdStr");

    await prefs.setString('userData', json.encode(userData));
    await prefs.setString('id', id);
    await prefs.setString('name', name);
    await prefs.setString('mobile', mobile);
    await prefs.setString('address', address);
    await prefs.setString('user_id', userIdStr);
    await prefs.setBool('isLoggedIn', true);

    print("Saved ID: $id");
    print("Saved Name: $name");
    print("Saved Mobile: $mobile");
    print("Saved user_id: $userIdStr");
  }

  Future<void> _saveProfileToServer() async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();

    var uri = Uri.parse('https://sks.sitsolutions.co.in/update_profile');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = userId.toString();
    request.fields['name'] = name;
    request.fields['mobile'] = mobile;
    request.fields['address'] = address;

    if (_selectedImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('API Response: $responseBody');

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        if (data['status'] == 'success') {
          await _saveUserData({
            'id': userId.toString(),
            'name': name,
            'mobile': mobile,
            'address': address,
            'imagePath': _selectedImage?.path ?? '',
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'प्रोफाइल जतन झाले')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'काहीतरी चुकले आहे')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('सर्व्हर त्रुटी: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('API Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('कनेक्शनमध्ये त्रुटी: $e')),
      );
    }
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
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
      body: SingleChildScrollView(
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
                        : const AssetImage('assets/images/user.png')
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
                        child:
                        Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel("नाव"),
            _buildTextField(
                controller: nameController, hintText: "तुमचे पूर्ण नाव"),
            const SizedBox(height: 16),
            _buildLabel("मोबाईल नंबर"),
            _buildTextField(
              controller: mobileController,
              hintText: "मोबाईल नंबर",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildLabel("पत्ता"),
            _buildTextField(
                controller: addressController, hintText: "तुमचा पूर्ण पत्ता"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfileToServer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('सेव्ह करा',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
