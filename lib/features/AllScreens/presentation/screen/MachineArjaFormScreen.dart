import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class MachineArjaFormScreen extends StatefulWidget {
  const MachineArjaFormScreen({super.key});

  @override
  State<MachineArjaFormScreen> createState() => _MachineArjaFormScreenState();
}

class _MachineArjaFormScreenState extends State<MachineArjaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
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
        final uri = Uri.parse('https://yourapi.com/submit-form'); // TODO: replace with your API

        final request = http.MultipartRequest('POST', uri);

        // Add form fields
        request.fields['name'] = nameController.text.trim();
        request.fields['address'] = addressController.text.trim();
        request.fields['mobile'] = mobileController.text.trim();
        request.fields['condition'] = conditionController.text.trim();
        request.fields['khare'] = khareController.text.trim();
        request.fields['vet'] = vetController.text.trim();
        request.fields['source'] = sourceController.text.trim();
        request.fields['villageTitle'] = villageTitleController.text.trim();

        // Add image file if selected
        if (_selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'photo', // This must match your API field name
            _selectedImage!.path,
            filename: basename(_selectedImage!.path),
          ));
        }

        // Send request
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
            fit: BoxFit.fill,
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
        title:  Text('मशीन्स अर्ज'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'नाव',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing:0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildTextField('', nameController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'पत्ता',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing:0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildTextField('', addressController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'मोबाईल',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing:0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildTextField('', mobileController,
                      keyboardType: TextInputType.phone),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'नवीन',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing:0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildTextField('', conditionController),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'जुने',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing:0,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildTextField('', khareController),
                            ],
                          )),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'वय',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing:0,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _buildTextField('', vetController),
                        ],
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'किंमत',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing:0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildTextField('', sourceController),


                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'अपलोड फोटो ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing:0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('सबमिट करा',
                          style:
                          TextStyle(fontSize: 16, color: Colors.white)),
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
