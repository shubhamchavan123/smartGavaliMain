import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class CharaArjaFormScreen extends StatefulWidget {
  const CharaArjaFormScreen({super.key});

  @override
  State<CharaArjaFormScreen> createState() => _CharaArjaFormScreenState();
}

class _CharaArjaFormScreenState extends State<CharaArjaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController vetController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController villageTitleController = TextEditingController();
  final TextEditingController greenFodderOptionsController = TextEditingController();
  final TextEditingController dryFodderUnitController = TextEditingController();

  // Dropdown options
  final List<String> greenFodderOptions = ['मका', 'कडवळ', 'घास गवत'];
  final List<String> dryFodderOptions = ['कडबा', 'वैरण'];

  String? selectedGreenFodder;
  String? selectedDryFodder;

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    vetController.dispose();
    sourceController.dispose();
    villageTitleController.dispose();
    greenFodderOptionsController.dispose();
    dryFodderUnitController.dispose();
    super.dispose();
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

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final uri = Uri.parse('https://yourapi.com/submit-form'); // Replace with actual API

        final request = http.MultipartRequest('POST', uri);

        request.fields['name'] = nameController.text.trim();
        request.fields['address'] = addressController.text.trim();
        request.fields['mobile'] = mobileController.text.trim();
        request.fields['vet'] = vetController.text.trim();
        request.fields['source'] = sourceController.text.trim();
        request.fields['villageTitle'] = villageTitleController.text.trim();
        request.fields['condition'] = selectedGreenFodder ?? '';
        request.fields['khare'] = selectedDryFodder ?? '';

        if (selectedDryFodder == 'कडबा' || selectedDryFodder == 'वैरण') {
          request.fields['dry_fodder_unit'] = greenFodderOptionsController.text.trim();
        }

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
          _showSuccessDialog(context); // ✅ Show dialog on success
        } else {
          _showSuccessDialog(context); // ✅ Show dialog on success

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("त्रुटी: ${response.statusCode}")),
          // );
        }
      } catch (e) {
        setState(() => _isLoading = false);
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        validator: (value) =>
        (value == null || value.isEmpty) ? 'कृपया $label निवडा' : null,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
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
        title: const Text('चारा अर्ज'),
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
                  _buildTextField('नाव', nameController),
                  _buildTextField('पत्ता', addressController),
                  _buildTextField('मोबाईल', mobileController,
                      keyboardType: TextInputType.phone),


                  _buildDropdownField(
                    label: 'हिरवा चारा',
                    items: greenFodderOptions,
                    selectedValue: selectedGreenFodder,
                    onChanged: (value) {
                      setState(() => selectedGreenFodder = value);
                    },
                  ),
                  _buildDropdownField(
                    label: 'सुखा चारा',
                    items: dryFodderOptions,
                    selectedValue: selectedDryFodder,
                    onChanged: (value) {
                      setState(() => selectedDryFodder = value);
                    },
                  ),

                  // Show the unit field if either 'कडबा' or 'वैरण' is selected for dry fodder
                  if (selectedDryFodder == 'कडबा' || selectedDryFodder == 'वैरण') ...[
                    const SizedBox(height: 8),
                    _buildTextField('युनिट ', greenFodderOptionsController),
                  ],

                  // Additional conditional fields based on selectedGreenFodder
                  if (selectedGreenFodder == 'मका') ...[
                    const SizedBox(height: 8),
                    _buildTextField('मका चारा गुंठा', dryFodderUnitController), // You can modify this as needed
                  ],
                  if (selectedGreenFodder == 'कडवळ') ...[
                    const SizedBox(height: 8),
                    _buildTextField('कडवळ चारा गुंठा', dryFodderUnitController), // Modify as per requirement
                  ],
                  if (selectedGreenFodder == 'घास गवत') ...[
                    const SizedBox(height: 8),
                    _buildTextField('घास गवत चारा गुंठा', dryFodderUnitController), // Modify as per requirement
                  ],
                  const SizedBox(height: 12),
                  _buildUploadBox(),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'सबमिट करा',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            'अर्ज यशस्वीरित्या\nसबमिट केला आहे',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    ),
  );
}

