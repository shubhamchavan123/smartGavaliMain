import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalArjaFormScreen extends StatefulWidget {
  final String categoryName;

  const AnimalArjaFormScreen({super.key, required this.categoryName});

  @override
  State<AnimalArjaFormScreen> createState() => _AnimalArjaFormScreenState();
}

class _AnimalArjaFormScreenState   extends State<AnimalArjaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController khareController = TextEditingController();
  final TextEditingController vetController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController villageTitleController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserDataFromPrefs(); // Load SharedPreferences data
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    conditionController.dispose();
    khareController.dispose();
    vetController.dispose();
    sourceController.dispose();
    villageTitleController.dispose();
    super.dispose();
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
      });
    }

    debugPrint("Loaded user_id: $userId");
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final uri = Uri.parse('https://yourapi.com/submit-form'); // Replace with your API
        final request = http.MultipartRequest('POST', uri);

        request.fields['name'] = nameController.text.trim();
        request.fields['address'] = addressController.text.trim();
        request.fields['mobile'] = mobileController.text.trim();
        request.fields['condition'] = conditionController.text.trim();
        request.fields['khare'] = khareController.text.trim();
        request.fields['vet'] = vetController.text.trim();
        request.fields['source'] = sourceController.text.trim();
        request.fields['villageTitle'] = villageTitleController.text.trim();
        request.fields['user_id'] = userId.toString();

        if (_selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'photo',
            _selectedImage!.path,
            filename: basename(_selectedImage!.path),
          ));
        }

        final response = await request.send();

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("फॉर्म यशस्वीरित्या पाठवला.")),
          // );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("त्रुटी: ${response.statusCode}")),
          // );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        debugPrint('Error: $e');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("नेटवर्क त्रुटी.")),
        // );
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) =>
        (value == null || value.isEmpty) ? 'कृपया $label भरा' : null,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _selectedImage != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            _selectedImage!,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        )
            : const Center(
          child: Icon(Icons.upload_file, color: Colors.grey, size: 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildSectionTitle('नाव'),
                  _buildTextFieldNameMobile('नाव', nameController, readOnly: true), // Read-only
                  _buildSectionTitle('मोबाईल'),
                  _buildTextFieldNameMobile('मोबाईल', mobileController,
                      keyboardType: TextInputType.phone, readOnly: true),
                  _buildSectionTitle('पत्ता'),
                  _buildTextField('पत्ता', addressController),
                   // Read-only

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildSectionTitle('वय'),
                            _buildTextField('वय', khareController),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            _buildSectionTitle('वेत'),
                            _buildTextField('वेत', vetController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _buildSectionTitle('दूध'),
                  _buildTextField('दूध', sourceController),
                  _buildSectionTitle('गाभण (असल्यास महिना लिहावा)'),
                  _buildTextField('गाभण', villageTitleController),
                  const SizedBox(height: 10),
                  _buildUploadBox(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text(
                        'सबमिट करा',
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldNameMobile(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        validator: (value) {
          if (!readOnly && (value == null || value.isEmpty)) {
            return 'कृपया $label भरा';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

}
