import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiService/api_service.dart';
import '../../../home/presentation/screen/HomeScreen.dart';

/// this is working code single img
// class DynamicFormScreen extends StatefulWidget {
//   final String categoryName;
//   final String categoryId;
//
//   const DynamicFormScreen({
//     Key? key,
//     required this.categoryName,
//     required this.categoryId,
//   }) : super(key: key);
//
//   @override
//   _DynamicFormScreenState createState() => _DynamicFormScreenState();
// }
//
// class _DynamicFormScreenState extends State<DynamicFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();
//
//   List<Map<String, dynamic>> fields = [];
//   List<Map<String, dynamic>> childFields = [];
//   final Map<String, TextEditingController> controllers = {};
//   final Map<String, dynamic> dropdownValues = {};
//   final Map<String, File?> fileValues = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFormFields();
//   }
//
//   // Future<void> fetchFormFields() async {
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse('https://sks.sitsolutions.co.in/attribute_list'),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({'cat_id': int.tryParse(widget.categoryId) ?? 1}),
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       final attributeResponse = AttributeResponse.fromJson(data);
//   //
//   //       setState(() {
//   //         fields = attributeResponse.details.map((e) {
//   //           final bool isRequired = e.required.toLowerCase() == 'yes';
//   //           List<String>? options;
//   //           Map<String, String>? optionMap;
//   //
//   //           if (e.type == 'dropdown') {
//   //             if (e.dropdownList != null) {
//   //               options = e.dropdownList;
//   //             } else if (e.dropdownMap != null) {
//   //               optionMap = e.dropdownMap;
//   //               options = e.dropdownMap!.values.toList();
//   //             } else {
//   //               options = ['होय', 'नाही'];
//   //             }
//   //           }
//   //
//   //           return {
//   //             'type': e.type,
//   //             'label': e.label,
//   //             'name': e.attribute,
//   //             'required': isRequired,
//   //             'options': options,
//   //             'optionMap': optionMap,
//   //             'originalData': e,
//   //           };
//   //         }).toList();
//   //
//   //         // Initialize controllers and dropdown values
//   //         for (var field in fields) {
//   //           if (field['type'] == 'dropdown') {
//   //             dropdownValues[field['name']] = null;
//   //           } else if (field['type'] != 'file') {
//   //             controllers[field['name']] = TextEditingController();
//   //           }
//   //         }
//   //       });
//   //     } else {
//   //       print('Failed to fetch attributes: ${response.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching form fields: $e');
//   //   }
//   // }
//   Future<void> _loadFormFields() async {
//     try {
//       final result = await ApiService.fetchAttributeFields(widget.categoryId);
//
//       setState(() {
//         fields = result;
//
//         for (var field in fields) {
//           if (field['type'] == 'dropdown') {
//             dropdownValues[field['name']] = null;
//           } else if (field['type'] != 'file') {
//             controllers[field['name']] = TextEditingController();
//           }
//         }
//       });
//     } catch (e) {
//       print('Error loading fields: $e');
//     }
//   }
//
//   // Future<void> fetchChildSubcategories(int subcatId) async {
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse('https://sks.sitsolutions.co.in/child_subcat_list'),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({'subcat_id': subcatId}),
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       final childResponse = ChildSubcategoryResponse.fromJson(data);
//   //
//   //       setState(() {
//   //         childFields = childResponse.details.map((e) {
//   //           final bool isRequired = e.required.toLowerCase() == 'yes';
//   //           final options = e.dropdownValues.values.toList();
//   //           final optionMap = e.dropdownValues;
//   //
//   //           return {
//   //             'type': e.type,
//   //             'label': e.label,
//   //             'name': e.attribute,
//   //             'required': isRequired,
//   //             'options': options,
//   //             'optionMap': optionMap,
//   //           };
//   //         }).toList();
//   //
//   //         // Initialize dropdown values for child fields
//   //         for (var field in childFields) {
//   //           if (field['type'] == 'dropdown') {
//   //             dropdownValues[field['name']] = null;
//   //           }
//   //         }
//   //       });
//   //     } else {
//   //       print('Failed to fetch child subcategories: ${response.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching child subcategories: $e');
//   //   }
//   // }
//   Future<void> fetchChildSubcategories(int subcatId) async {
//     try {
//       final result = await ApiService.fetchChildSubcategorie(subcatId);
//
//       setState(() {
//         childFields = result;
//
//         // Initialize dropdown values
//         for (var field in childFields) {
//           if (field['type'] == 'dropdown') {
//             dropdownValues[field['name']] = null;
//           }
//         }
//       });
//     } catch (e) {
//       print('UI Error - fetchChildSubcategories: $e');
//     }
//   }
//
//   void handleSubcategoryChange(String? value, Map<String, dynamic> field) {
//     if (value == null) return;
//
//     setState(() {
//       dropdownValues[field['name']] = value;
//     });
//
//     // Check if this is the subcategory dropdown
//     if (field['name'] == 'subcategory') {
//       final originalData = field['originalData'] as AttributeDetail?;
//       final optionMap = originalData?.dropdownMap ??
//           field['optionMap'] as Map<String, String>?;
//
//       if (optionMap != null) {
//         // Find the key for the selected value
//         final selectedKey = optionMap.entries
//             .firstWhere(
//               (entry) => entry.value == value,
//               orElse: () => MapEntry('', ''),
//             )
//             .key;
//
//         if (selectedKey.isNotEmpty) {
//           final subcatId = int.tryParse(selectedKey);
//           if (subcatId != null) {
//             // Clear previous child fields
//             setState(() {
//               childFields = [];
//             });
//
//             // Fetch child subcategories dynamically
//             fetchChildSubcategories(subcatId);
//           }
//         }
//       }
//     }
//   }
//
//   void initializeFieldControllers(List<Map<String, dynamic>> fieldList) {
//     for (var field in fieldList) {
//       if (field['type'] == 'dropdown') {
//         dropdownValues[field['name']] = null;
//       } else if (field['type'] != 'file') {
//         controllers[field['name']] = TextEditingController();
//       }
//     }
//   }
//
//   void submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Center(child: CircularProgressIndicator()),
//       );
//
//       try {
//         // Get user_id from SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         final userId = prefs.getString('user_id') ?? '0';
//         print("Using user_id: $userId"); // Debug print
//
//         // Prepare form data
//         final Map<String, String> formData = {
//           'user_id': userId,
//           'cat_id': widget.categoryId,
//         };
//
//         // Add main form fields
//         for (var field in fields) {
//           final name = field['name'];
//           final originalData = field['originalData'] as AttributeDetail?;
//
//           switch (field['type']) {
//             case 'dropdown':
//               if (dropdownValues[name] != null) {
//                 // For dropdowns with option maps, we need to send the key, not the value
//                 if (originalData?.dropdownMap != null) {
//                   // Find the key for the selected value
//                   final selectedEntry =
//                       originalData?.dropdownMap?.entries.firstWhere(
//                     (entry) => entry.value == dropdownValues[name],
//                     orElse: () => MapEntry('', ''),
//                   );
//
//                   if (selectedEntry?.key.isNotEmpty ?? false) {
//                     formData[name] = selectedEntry!.key;
//                   } else {
//                     formData[name] = dropdownValues[name].toString();
//                   }
//                 } else {
//                   formData[name] = dropdownValues[name].toString();
//                 }
//               }
//               break;
//             case 'file':
//               // Files will be handled separately in multipart
//               break;
//             default:
//               if (controllers[name]?.text.isNotEmpty ?? false) {
//                 formData[name] = controllers[name]!.text;
//               }
//           }
//         }
//
//         // Add child fields data
//         for (var field in childFields) {
//           final name = field['name'];
//           if (field['type'] == 'dropdown' && dropdownValues[name] != null) {
//             // For child dropdowns with option maps
//             if (field['optionMap'] != null) {
//               final selectedEntry = field['optionMap'].entries.firstWhere(
//                     (entry) => entry.value == dropdownValues[name],
//                     orElse: () => MapEntry('', ''),
//                   );
//
//               if (selectedEntry.key.isNotEmpty) {
//                 formData[name] = selectedEntry.key;
//               } else {
//                 formData[name] = dropdownValues[name].toString();
//               }
//             } else {
//               formData[name] = dropdownValues[name].toString();
//             }
//           }
//         }
//
//         // Create multipart request
//         var request = http.MultipartRequest('POST', ApiService.addPostUrl
//             // Uri.parse('https://sks.sitsolutions.co.in/add_post'),
//             );
//
//         // Add form fields
//         request.fields.addAll(formData);
//
//         // Add files
//         for (var field in fields) {
//           if (field['type'] == 'file' && fileValues[field['name']] != null) {
//             final file = fileValues[field['name']]!;
//             request.files.add(
//               await http.MultipartFile.fromPath(
//                 field['name'],
//                 file.path,
//               ),
//             );
//           }
//         }
//
//         // Print the request data for debugging
//         print('Submitting form data: ${request.fields}');
//         print('Files: ${request.files.length}');
//
//         // Send request
//         final response = await request.send();
//
//         // Close loading dialog
//         Navigator.of(context).pop();
//
//         if (response.statusCode == 200) {
//           final responseData = await response.stream.bytesToString();
//           final jsonResponse = json.decode(responseData);
//           print('Response: $jsonResponse');
//
//           if (jsonResponse['status'] == 'success') {
//             // Show approval message dialog
//             await showDialog(
//               context: context,
//               barrierDismissible: false, // User must tap button to close
//               builder: (context) => AlertDialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.0),
//                 ),
//                 elevation: 4,
//                 title: Text(
//                   // 'Submission Successful',
//                   'सबमिशन यशस्वी',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green, // Success color
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 48,
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'तुमची पोस्ट यशस्वीरित्या सबमिट केली गेली आहे!',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'प्रशासकाच्या मंजुरीनंतर ते दिसेल.',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.orange, // Warning/notice color
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//                 actionsAlignment: MainAxisAlignment.center,
//                 actions: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop(); // Close the dialog
//                       Navigator.of(context).pushAndRemoveUntil(
//                         MaterialPageRoute(builder: (context) => HomeScreen()),
//                         (Route<dynamic> route) => false,
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green, // Button color
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     child: Text(
//                       'OK',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                   content:
//                       Text(jsonResponse['message'] ?? 'Submission failed')),
//             );
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text('Error submitting form: ${response.statusCode}')),
//           );
//         }
//       } catch (e) {
//         // Close loading dialog
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//         print('Error submitting form: $e');
//       }
//     }
//   }
//
//   Future<void> pickFile(String fieldName) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Select Source'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: Text('Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final XFile? picked =
//                     await _picker.pickImage(source: ImageSource.gallery);
//                 if (picked != null) _compressImage(picked.path, fieldName);
//               },
//             ),
//             ListTile(
//               title: Text('Camera'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final XFile? picked =
//                     await _picker.pickImage(source: ImageSource.camera);
//                 if (picked != null) _compressImage(picked.path, fieldName);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _compressImage(String filePath, String fieldName) async {
//     final img.Image? image = img.decodeImage(File(filePath).readAsBytesSync());
//     if (image != null) {
//       final img.Image resized = img.copyResize(image, width: 400, height: 200);
//       final compressed = File(filePath)
//         ..writeAsBytesSync(img.encodeJpg(resized, quality: 80));
//       setState(() {
//         fileValues[fieldName] = compressed;
//       });
//     }
//   }
//
//   Widget buildField(Map<String, dynamic> field) {
//     switch (field['type']) {
//       case 'text':
//       case 'email':
//       case 'number':
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: TextFormField(
//             controller: controllers[field['name']],
//             keyboardType: field['type'] == 'number'
//                 ? TextInputType.number
//                 : (field['type'] == 'email'
//                     ? TextInputType.emailAddress
//                     : TextInputType.text),
//             decoration: InputDecoration(
//               labelText: field['label'],
//               labelStyle:
//                   TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) {
//               if (field['required'] && (value == null || value.isEmpty)) {
//                 return '${field['label']} आवश्यक आहे';
//               }
//               return null;
//             },
//           ),
//         );
//
//       case 'dropdown':
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: DropdownButtonFormField<String>(
//             decoration: InputDecoration(
//               labelText: field['label'],
//               labelStyle:
//                   TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//               border: OutlineInputBorder(),
//             ),
//             items: (field['options'] as List<String>)
//                 .map((option) => DropdownMenuItem(
//                       value: option,
//                       child: Text(option),
//                     ))
//                 .toList(),
//             value: dropdownValues[field['name']],
//             onChanged: (value) => handleSubcategoryChange(value, field),
//             validator: (value) {
//               if (field['required'] && (value == null || value.isEmpty)) {
//                 return '${field['label']} आवश्यक आहे';
//               }
//               return null;
//             },
//           ),
//         );
//       case 'file':
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(field['label'],
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green)),
//               ElevatedButton(
//                 onPressed: () => pickFile(field['name']),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30)),
//                 ),
//                 child: Text('अपलोड करा (${field['label']})',
//                     style: TextStyle(fontSize: 16)),
//               ),
//               if (fileValues[field['name']] != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Image.file(fileValues[field['name']]!),
//                 ),
//             ],
//           ),
//         );
//
//       default:
//         return SizedBox.shrink();
//     }
//   }
//
//   // Helper methods to organize field positions
//   List<Widget> _buildFieldsBeforeSubcategory() {
//     List<Widget> widgets = [];
//     for (var field in fields) {
//       if (field['name'] == 'subcategory') break;
//       if (field['name'] != 'weight' && field['name'] != 'unit') {
//         widgets.add(buildField(field));
//       }
//     }
//     return widgets;
//   }
//
//   List<Widget> _buildFieldsAfterSubcategory() {
//     List<Widget> widgets = [];
//     bool foundSubcategory = false;
//     for (var field in fields) {
//       if (field['name'] == 'subcategory') {
//         foundSubcategory = true;
//         continue;
//       }
//       if (foundSubcategory &&
//           field['name'] != 'weight' &&
//           field['name'] != 'unit') {
//         widgets.add(buildField(field));
//       }
//     }
//     return widgets;
//   }
//
//   Widget buildWeightUnitRow() {
//     final weightField =
//         fields.firstWhere((f) => f['name'] == 'weight', orElse: () => {});
//     final unitField =
//         fields.firstWhere((f) => f['name'] == 'unit', orElse: () => {});
//
//     if (weightField.isEmpty || unitField.isEmpty) return SizedBox.shrink();
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           Expanded(child: buildField(weightField)),
//           SizedBox(width: 10),
//           Expanded(child: buildField(unitField)),
//         ],
//       ),
//     );
//   }
//
//   Map<String, dynamic>? _getSubcategoryField() {
//     try {
//       return fields.firstWhere((field) => field['name'] == 'subcategory');
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.categoryName,
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF2E7D32), Colors.white],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),
//       body: fields.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : Form(
//               key: _formKey,
//               child: ListView(
//                 padding: EdgeInsets.all(16),
//                 children: [
// // Subcategory dropdown
//                   if (_getSubcategoryField() != null)
//                     buildField(_getSubcategoryField()!),
//
// // Child fields
//                   ...childFields.map(buildField).toList(),
//
// // Fields after subcategory, excluding weight/unit
//                   ..._buildFieldsAfterSubcategory(),
//
// // Combined weight + unit row
//                   buildWeightUnitRow(),
// // Fields before subcategory
//                   ..._buildFieldsBeforeSubcategory(),
//
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: submitForm,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                     ),
//                     child: Text('सबमिट करा',
//                         style: TextStyle(fontSize: 16, color: Colors.white)),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

///  this is working code multiple img upload
class DynamicFormScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const DynamicFormScreen({
    Key? key,
    required this.categoryName,
    required this.categoryId,
  }) : super(key: key);

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> fields = [];
  List<Map<String, dynamic>> childFields = [];
  final Map<String, TextEditingController> controllers = {};
  final Map<String, dynamic> dropdownValues = {};
  final Map<String, List<File>> fileValues = {};

  // Controller for static address
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFormFields();
  }

  Future<void> _loadFormFields() async {
    try {
      final result = await ApiService.fetchAttributeFields(widget.categoryId);

      setState(() {
        fields = result;

        for (var field in fields) {
          if (field['type'] == 'dropdown') {
            dropdownValues[field['name']] = null;
          } else if (field['type'] != 'file') {
            controllers[field['name']] = TextEditingController();
          }
        }
      });
    } catch (e) {
      print('Error loading fields: $e');
    }
  }

  Future<void> fetchChildSubcategories(int subcatId) async {
    try {
      final result = await ApiService.fetchChildSubcategorie(subcatId);

      setState(() {
        childFields = result;
        for (var field in childFields) {
          if (field['type'] == 'dropdown') {
            dropdownValues[field['name']] = null;
          }
        }
      });
    } catch (e) {
      print('UI Error - fetchChildSubcategories: $e');
    }
  }

  void handleSubcategoryChange(String? value, Map<String, dynamic> field) {
    if (value == null) return;

    setState(() {
      dropdownValues[field['name']] = value;
    });

    if (field['name'] == 'subcategory') {
      final originalData = field['originalData'] as AttributeDetail?;
      final optionMap = originalData?.dropdownMap ?? field['optionMap'] as Map<String, String>?;

      if (optionMap != null) {
        final selectedKey = optionMap.entries.firstWhere(
              (entry) => entry.value == value,
          orElse: () => MapEntry('', ''),
        ).key;

        if (selectedKey.isNotEmpty) {
          final subcatId = int.tryParse(selectedKey);
          if (subcatId != null) {
            setState(() {
              childFields = [];
            });
            fetchChildSubcategories(subcatId);
          }
        }
      }
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('user_id') ?? '0';

        final Map<String, String> formData = {
          'user_id': userId,
          'cat_id': widget.categoryId,
        };

        // Add main form fields
        for (var field in fields) {
          final name = field['name'];
          final originalData = field['originalData'] as AttributeDetail?;

          switch (field['type']) {
            case 'dropdown':
              if (dropdownValues[name] != null) {
                if (originalData?.dropdownMap != null) {
                  final selectedEntry = originalData?.dropdownMap?.entries.firstWhere(
                        (entry) => entry.value == dropdownValues[name],
                    orElse: () => MapEntry('', ''),
                  );
                  if (selectedEntry != null && selectedEntry!.key.isNotEmpty) {
                    formData[name] = selectedEntry.key;
                  } else {
                    formData[name] = dropdownValues[name].toString();
                  }
                } else {
                  formData[name] = dropdownValues[name].toString();
                }
              }
              break;
            case 'file':
              break; // Files handled separately
            default:
              if (controllers[name]?.text.isNotEmpty ?? false) {
                formData[name] = controllers[name]!.text;
              }
          }
        }

        // Add child fields data
        for (var field in childFields) {
          final name = field['name'];
          if (field['type'] == 'dropdown' && dropdownValues[name] != null) {
            if (field['optionMap'] != null) {
              final selectedEntry = field['optionMap'].entries.firstWhere(
                    (entry) => entry.value == dropdownValues[name],
                orElse: () => MapEntry('', ''),
              );
              if (selectedEntry.key.isNotEmpty) {
                formData[name] = selectedEntry.key;
              } else {
                formData[name] = dropdownValues[name].toString();
              }
            } else {
              formData[name] = dropdownValues[name].toString();
            }
          }
        }

        // Add static address
        formData['address'] = addressController.text;


        // 🔍 Debug section
        print('\n--- FORM DATA DEBUG ---');
        formData.forEach((key, value) {
          if (value.isEmpty) {
            print('⚠️ Missing or empty field: $key');
          } else {
            print('$key: $value');
          }
        });

        print('\n--- DROPDOWN VALUES ---');
        dropdownValues.forEach((key, value) {
          print('$key: ${value ?? "null"}');
        });

        print('\n--- TEXT CONTROLLERS ---');
        controllers.forEach((key, controller) {
          print('$key: ${controller.text.isEmpty ? "⚠️ Empty" : controller.text}');
        });
        print('------------------------\n');


        var request = http.MultipartRequest(
            'POST',
            ApiService.addPostUrl
        );
        request.fields.addAll(formData);

        for (var field in fields) {
          if (field['type'] == 'file' && fileValues[field['name']] != null) {
            final files = fileValues[field['name']]!;
            for (var file in files) {
              request.files.add(await http.MultipartFile.fromPath(
                '${field['name']}[]',
                file.path,
              ));
            }
          }
        }

        print('Submitting form data: ${request.fields}');
        print('Files: ${request.files.length}');

        final response = await request.send();

        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseData);
          print('Response: $jsonResponse');

          if (jsonResponse['status'] == 'success') {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                title: Text(
                  'Submission Successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Your post has been submitted successfully!',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'It will be visible after admin approval.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('OK', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonResponse['message'] ?? 'Submission failed')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting form: ${response.statusCode}')),
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print('Error submitting form: $e');
      }
    }
  }

  Widget buildField(Map<String, dynamic> field) {
    switch (field['type']) {
      case 'text':
      case 'email':
      case 'number':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: controllers[field['name']],
            keyboardType: field['type'] == 'number'
                ? TextInputType.number
                : (field['type'] == 'email' ? TextInputType.emailAddress : TextInputType.text),
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (field['type'] == 'number') {
                if (field['required'] && (value == null || value.trim().isEmpty)) {
                  return '${field['label']} आवश्यक आहे';
                }
                final number = num.tryParse(value ?? '');
                if (number == null || number <= 0) {
                  return '${field['label']} फक्त सकारात्मक (positive) संख्या असावी';
                }
              }
              return null;
            },
          ),
        );
     /* case 'dropdown':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
            ),
            items: (field['options'] as List<String>)
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            value: dropdownValues[field['name']],
            onChanged: (value) => handleSubcategoryChange(value, field),
            validator: (value) {
              if (field['required'] && (value == null || value.isEmpty)) {
                return '${field['label']} आवश्यक आहे';
              }
              return null;
            },
          ),
        );*/

      case 'dropdown':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField2<String>(
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            isExpanded: true,
            hint: Text(
              'निवडा', // "Select" in Marathi
              style: TextStyle(fontSize: 14),
            ),
            items: (field['options'] as List<String>)
                .map((option) => DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(fontSize: 14),
              ),
            ))
                .toList(),
            value: dropdownValues[field['name']],
            onChanged: (value) => handleSubcategoryChange(value, field),
            validator: (value) {
              if (field['required'] && (value == null || value.isEmpty)) {
                return '${field['label']} आवश्यक आहे';
              }
              return null;
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              maxHeight: 200,
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        );
      case 'file':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field['label'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...?fileValues[field['name']]?.map((file) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            fileValues[field['name']]!.remove(file);
                          });
                        },
                        child: Icon(Icons.cancel, color: Colors.red),
                      )
                    ],
                  )),
                  GestureDetector(
                    onTap: () => pickFile(field['name']),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
  Future<void> pickFile(String fieldName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile>? pickedFiles = await _picker.pickMultiImage();
                if (pickedFiles != null) {
                  for (XFile file in pickedFiles) {
                    await _compressAndStore(file.path, fieldName);
                  }
                }
              },
            ),
            ListTile(
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  await _compressAndStore(picked.path, fieldName);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _compressAndStore(String filePath, String fieldName) async {
    final img.Image? image = img.decodeImage(File(filePath).readAsBytesSync());
    if (image != null) {
      final img.Image resized = img.copyResize(image, width: 400, height: 200);
      final compressed = File(filePath)..writeAsBytesSync(img.encodeJpg(resized, quality: 80));

      setState(() {
        fileValues.putIfAbsent(fieldName, () => []);
        fileValues[fieldName]!.add(compressed);
      });
    }
  }
  Widget buildStaticAddressField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: addressController,
        decoration: InputDecoration(
          labelText: 'पत्ता', // Static address label
          labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'पत्ता आवश्यक आहे'; // Validation message
          }
          return null;
        },
      ),
    );
  }

  // Helper methods to organize field positions
  List<Widget> _buildFieldsBeforeSubcategory() {
    List<Widget> widgets = [];
    for (var field in fields) {
      if (field['name'] == 'subcategory') break;
      if (field['name'] != 'weight' && field['name'] != 'unit') {
        widgets.add(buildField(field));
      }
    }
    return widgets;
  }

  List<Widget> _buildFieldsAfterSubcategory() {
    List<Widget> widgets = [];
    bool foundSubcategory = false;
    for (var field in fields) {
      if (field['name'] == 'subcategory') {
        foundSubcategory = true;
        continue;
      }
      if (foundSubcategory && field['name'] != 'weight' && field['name'] != 'unit') {
        widgets.add(buildField(field));
      }
    }
    return widgets;
  }

  Widget buildWeightUnitRow() {
    final weightField = fields.firstWhere((f) => f['name'] == 'weight', orElse: () => {});
    final unitField = fields.firstWhere((f) => f['name'] == 'unit', orElse: () => {});

    if (weightField.isEmpty || unitField.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(child: buildField(weightField)),
          SizedBox(width: 10),
          Expanded(child: buildField(unitField)),
        ],
      ),
    );
  }

  Map<String, dynamic>? _getSubcategoryField() {
    try {
      return fields.firstWhere((field) => field['name'] == 'subcategory');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: fields.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Subcategory dropdown
            if (_getSubcategoryField() != null) buildField(_getSubcategoryField()!),



            // Child fields
            ...childFields.map(buildField).toList(),

            // Fields after subcategory, excluding weight/unit
            ..._buildFieldsAfterSubcategory(),

            // Combined weight + unit row
            buildWeightUnitRow(),

            // Fields before subcategory
            ..._buildFieldsBeforeSubcategory(),
            // Static Address Field
            buildStaticAddressField(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('सबमिट करा', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class DynamicFormScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const DynamicFormScreen({
    Key? key,
    required this.categoryName,
    required this.categoryId,
  }) : super(key: key);

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> fields = [];
  List<Map<String, dynamic>> childFields = [];
  final Map<String, TextEditingController> controllers = {};
  final Map<String, dynamic> dropdownValues = {};
  // final Map<String, File?> fileValues = {};
  final Map<String, List<File>> fileValues = {};


  @override
  void initState() {
    super.initState();
    _loadFormFields();
  }

  // Future<void> fetchFormFields() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://sks.sitsolutions.co.in/attribute_list'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'cat_id': int.tryParse(widget.categoryId) ?? 1}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final attributeResponse = AttributeResponse.fromJson(data);
  //
  //       setState(() {
  //         fields = attributeResponse.details.map((e) {
  //           final bool isRequired = e.required.toLowerCase() == 'yes';
  //           List<String>? options;
  //           Map<String, String>? optionMap;
  //
  //           if (e.type == 'dropdown') {
  //             if (e.dropdownList != null) {
  //               options = e.dropdownList;
  //             } else if (e.dropdownMap != null) {
  //               optionMap = e.dropdownMap;
  //               options = e.dropdownMap!.values.toList();
  //             } else {
  //               options = ['होय', 'नाही'];
  //             }
  //           }
  //
  //           return {
  //             'type': e.type,
  //             'label': e.label,
  //             'name': e.attribute,
  //             'required': isRequired,
  //             'options': options,
  //             'optionMap': optionMap,
  //             'originalData': e,
  //           };
  //         }).toList();
  //
  //         // Initialize controllers and dropdown values
  //         for (var field in fields) {
  //           if (field['type'] == 'dropdown') {
  //             dropdownValues[field['name']] = null;
  //           } else if (field['type'] != 'file') {
  //             controllers[field['name']] = TextEditingController();
  //           }
  //         }
  //       });
  //     } else {
  //       print('Failed to fetch attributes: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching form fields: $e');
  //   }
  // }
  Future<void> _loadFormFields() async {
    try {
      final result = await ApiService.fetchAttributeFields(widget.categoryId);

      setState(() {
        fields = result;

        for (var field in fields) {
          if (field['type'] == 'dropdown') {
            dropdownValues[field['name']] = null;
          } else if (field['type'] != 'file') {
            controllers[field['name']] = TextEditingController();
          }
        }
      });
    } catch (e) {
      print('Error loading fields: $e');
    }
  }

  // Future<void> fetchChildSubcategories(int subcatId) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://sks.sitsolutions.co.in/child_subcat_list'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'subcat_id': subcatId}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final childResponse = ChildSubcategoryResponse.fromJson(data);
  //
  //       setState(() {
  //         childFields = childResponse.details.map((e) {
  //           final bool isRequired = e.required.toLowerCase() == 'yes';
  //           final options = e.dropdownValues.values.toList();
  //           final optionMap = e.dropdownValues;
  //
  //           return {
  //             'type': e.type,
  //             'label': e.label,
  //             'name': e.attribute,
  //             'required': isRequired,
  //             'options': options,
  //             'optionMap': optionMap,
  //           };
  //         }).toList();
  //
  //         // Initialize dropdown values for child fields
  //         for (var field in childFields) {
  //           if (field['type'] == 'dropdown') {
  //             dropdownValues[field['name']] = null;
  //           }
  //         }
  //       });
  //     } else {
  //       print('Failed to fetch child subcategories: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching child subcategories: $e');
  //   }
  // }
  Future<void> fetchChildSubcategories(int subcatId) async {
    try {
      final result = await ApiService.fetchChildSubcategorie(subcatId);

      setState(() {
        childFields = result;

        // Initialize dropdown values
        for (var field in childFields) {
          if (field['type'] == 'dropdown') {
            dropdownValues[field['name']] = null;
          }
        }
      });
    } catch (e) {
      print('UI Error - fetchChildSubcategories: $e');
    }
  }

  void handleSubcategoryChange(String? value, Map<String, dynamic> field) {
    if (value == null) return;

    setState(() {
      dropdownValues[field['name']] = value;
    });

    // Check if this is the subcategory dropdown
    if (field['name'] == 'subcategory') {
      final originalData = field['originalData'] as AttributeDetail?;
      final optionMap = originalData?.dropdownMap ?? field['optionMap'] as Map<String, String>?;

      if (optionMap != null) {
        // Find the key for the selected value
        final selectedKey = optionMap.entries.firstWhere(
              (entry) => entry.value == value,
          orElse: () => MapEntry('', ''),
        ).key;

        if (selectedKey.isNotEmpty) {
          final subcatId = int.tryParse(selectedKey);
          if (subcatId != null) {
            // Clear previous child fields
            setState(() {
              childFields = [];
            });

            // Fetch child subcategories dynamically
            fetchChildSubcategories(subcatId);
          }
        }
      }
    }
  }

  void initializeFieldControllers(List<Map<String, dynamic>> fieldList) {
    for (var field in fieldList) {
      if (field['type'] == 'dropdown') {
        dropdownValues[field['name']] = null;
      } else if (field['type'] != 'file') {
        controllers[field['name']] = TextEditingController();
      }
    }
  }


  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        // Get user_id from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('user_id') ?? '0';
        print("Using user_id: $userId"); // Debug print

        // Prepare form data
        final Map<String, String> formData = {
          'user_id': userId,
          'cat_id': widget.categoryId,
        };

        // Add main form fields
        for (var field in fields) {
          final name = field['name'];
          final originalData = field['originalData'] as AttributeDetail?;

          switch (field['type']) {
            case 'dropdown':
              if (dropdownValues[name] != null) {
                // For dropdowns with option maps, we need to send the key, not the value
                if (originalData?.dropdownMap != null) {
                  // Find the key for the selected value
                  final selectedEntry = originalData?.dropdownMap?.entries.firstWhere(
                        (entry) => entry.value == dropdownValues[name],
                    orElse: () => MapEntry('', ''),
                  );

                  if (selectedEntry?.key.isNotEmpty ?? false) {
                    formData[name] = selectedEntry!.key;
                  } else {
                    formData[name] = dropdownValues[name].toString();
                  }
                } else {
                  formData[name] = dropdownValues[name].toString();
                }
              }
              break;
            case 'file':
            // Files will be handled separately in multipart
              break;
            default:
              if (controllers[name]?.text.isNotEmpty ?? false) {
                formData[name] = controllers[name]!.text;
              }
          }
        }

        // Add child fields data
        for (var field in childFields) {
          final name = field['name'];
          if (field['type'] == 'dropdown' && dropdownValues[name] != null) {
            // For child dropdowns with option maps
            if (field['optionMap'] != null) {
              final selectedEntry = field['optionMap'].entries.firstWhere(
                    (entry) => entry.value == dropdownValues[name],
                orElse: () => MapEntry('', ''),
              );

              if (selectedEntry.key.isNotEmpty) {
                formData[name] = selectedEntry.key;
              } else {
                formData[name] = dropdownValues[name].toString();
              }
            } else {
              formData[name] = dropdownValues[name].toString();
            }
          }
        }

        // Create multipart request
        var request = http.MultipartRequest(
            'POST',
            ApiService.addPostUrl
          // Uri.parse('https://sks.sitsolutions.co.in/add_post'),
        );

        // Add form fields
        request.fields.addAll(formData);

        // Add files
        for (var field in fields) {
          if (field['type'] == 'file' && fileValues[field['name']] != null) {
            final files = fileValues[field['name']]!;
            for (int i = 0; i < files.length; i++) {
              final file = files[i];
              request.files.add(await http.MultipartFile.fromPath(
                '${field['name']}[]', // Use array format for field name
                file.path,
              ));
            }
          }
        }


        // Print the request data for debugging
        print('Submitting form data: ${request.fields}');
        print('Files: ${request.files.length}');

        // Send request
        final response = await request.send();

        // Close loading dialog
        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseData);
          print('Response: $jsonResponse');

          if (jsonResponse['status'] == 'success') {

            // Show approval message dialog
            await showDialog(
              context: context,
              barrierDismissible: false, // User must tap button to close
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                title: Text(
                  'Submission Successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Success color
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your post has been submitted successfully!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'It will be visible after admin approval.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange, // Warning/notice color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonResponse['message'] ?? 'Submission failed')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting form: ${response.statusCode}')),
          );
        }
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print('Error submitting form: $e');
      }
    }
  }

  Future<void> pickFile(String fieldName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile>? pickedFiles = await _picker.pickMultiImage();
                if (pickedFiles != null) {
                  for (XFile file in pickedFiles) {
                    await _compressAndStore(file.path, fieldName);
                  }
                }
              },
            ),
            ListTile(
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  await _compressAndStore(picked.path, fieldName);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _compressAndStore(String filePath, String fieldName) async {
    final img.Image? image = img.decodeImage(File(filePath).readAsBytesSync());
    if (image != null) {
      final img.Image resized = img.copyResize(image, width: 400, height: 200);
      final compressed = File(filePath)..writeAsBytesSync(img.encodeJpg(resized, quality: 80));

      setState(() {
        fileValues.putIfAbsent(fieldName, () => []);
        fileValues[fieldName]!.add(compressed);
      });
    }
  }


  Widget buildField(Map<String, dynamic> field) {
    switch (field['type']) {
      case 'text':
      case 'email':
      case 'number':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: controllers[field['name']],
            keyboardType: field['type'] == 'number'
                ? TextInputType.number
                : (field['type'] == 'email' ? TextInputType.emailAddress : TextInputType.text),
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (field['type'] == 'number') {
                if (field['required'] && (value == null || value.trim().isEmpty)) {
                  return '${field['label']} आवश्यक आहे';
                }

                final number = num.tryParse(value ?? '');
                if (number == null || number <= 0) {
                  return '${field['label']} फक्त सकारात्मक (positive) संख्या असावी';
                }
              }
              return null; // No validation for non-number fields
            },

            */
/* validator: (value) {
              if (field['required'] && (value == null || value.isEmpty)) {
                return '${field['label']} आवश्यक आहे';
              }
              return null;
            },*//*

          ),
        );

      case 'dropdown':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
            ),
            items: (field['options'] as List<String>)
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            value: dropdownValues[field['name']],
            onChanged: (value) => handleSubcategoryChange(value, field),
            validator: (value) {
              if (field['required'] && (value == null || value.isEmpty)) {
                return '${field['label']} आवश्यक आहे';
              }
              return null;
            },
          ),
        );
      case 'file':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field['label'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...?fileValues[field['name']]?.map((file) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            fileValues[field['name']]!.remove(file);
                          });
                        },
                        child: Icon(Icons.cancel, color: Colors.red),
                      )
                    ],
                  )),
                  GestureDetector(
                    onTap: () => pickFile(field['name']),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
            ],
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }

  // Helper methods to organize field positions
  List<Widget> _buildFieldsBeforeSubcategory() {
    List<Widget> widgets = [];
    for (var field in fields) {
      if (field['name'] == 'subcategory') break;
      if (field['name'] != 'weight' && field['name'] != 'unit') {
        widgets.add(buildField(field));
      }
    }
    return widgets;
  }



  List<Widget> _buildFieldsAfterSubcategory() {
    List<Widget> widgets = [];
    bool foundSubcategory = false;
    for (var field in fields) {
      if (field['name'] == 'subcategory') {
        foundSubcategory = true;
        continue;
      }
      if (foundSubcategory &&
          field['name'] != 'weight' &&
          field['name'] != 'unit') {
        widgets.add(buildField(field));
      }
    }
    return widgets;
  }
  Widget buildWeightUnitRow() {
    final weightField = fields.firstWhere((f) => f['name'] == 'weight', orElse: () => {});
    final unitField = fields.firstWhere((f) => f['name'] == 'unit', orElse: () => {});

    if (weightField.isEmpty || unitField.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(child: buildField(weightField)),
          SizedBox(width: 10),
          Expanded(child: buildField(unitField)),
        ],
      ),
    );
  }

  Map<String, dynamic>? _getSubcategoryField() {
    try {
      return fields.firstWhere((field) => field['name'] == 'subcategory');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: fields.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [



// Subcategory dropdown
            if (_getSubcategoryField() != null) buildField(_getSubcategoryField()!),

// Child fields
            ...childFields.map(buildField).toList(),

// Fields after subcategory, excluding weight/unit
            ..._buildFieldsAfterSubcategory(),

// Combined weight + unit row
            buildWeightUnitRow(),
// Fields before subcategory
            ..._buildFieldsBeforeSubcategory(),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('सबमिट करा', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class AttributeResponse {
  final String status;
  final String message;
  final List<AttributeDetail> details;

  AttributeResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory AttributeResponse.fromJson(Map<String, dynamic> json) {
    return AttributeResponse(
      status: json['status'],
      message: json['message'],
      details: List<AttributeDetail>.from(
        json['details'].map((x) => AttributeDetail.fromJson(x)),
      ),
    );
  }
}

class AttributeDetail {
  final String? id;
  final int catId;
  final String type;
  final String label;
  final String attribute;
  final String required;
  final String? dropdownValue;
  final List<String>? dropdownList;
  final Map<String, String>? dropdownMap;
  final String isDeleted;
  final String createdAt;

  AttributeDetail({
    this.id,
    required this.catId,
    required this.type,
    required this.label,
    required this.attribute,
    required this.required,
    this.dropdownValue,
    this.dropdownList,
    this.dropdownMap,
    required this.isDeleted,
    required this.createdAt,
  });

  // factory AttributeDetail.fromJson(Map<String, dynamic> json) {
  //   final dropdownValues = json['dropdown_values'];
  //
  //   List<String>? dropdownList;
  //   Map<String, String>? dropdownMap;
  //
  //   if (dropdownValues != null) {
  //     if (dropdownValues is List) {
  //       dropdownList = List<String>.from(dropdownValues);
  //     } else if (dropdownValues is Map) {
  //       dropdownMap = Map<String, String>.from(dropdownValues);
  //     }
  //   }
  //
  //   return AttributeDetail(
  //     id: json['id'],
  //     catId: int.parse(json['cat_id'].toString()),
  //     type: json['type'],
  //     label: json['label'],
  //     attribute: json['attribute'],
  //     required: json['required'],
  //     dropdownValue: json['dropdown_value'],
  //     dropdownList: dropdownList,
  //     dropdownMap: dropdownMap,
  //     isDeleted: json['isdeleted'],
  //     createdAt: json['created_at'],
  //   );
  // }
  factory AttributeDetail.fromJson(Map<String, dynamic> json) {
    List<String>? dropdownList;
    Map<String, String>? dropdownMap;

    final rawDropdownValue = json['dropdown_value'];

    if (rawDropdownValue != null) {
      if (rawDropdownValue is List) {
        dropdownList = List<String>.from(rawDropdownValue);
      } else if (rawDropdownValue is Map) {
        dropdownMap = Map<String, String>.from(rawDropdownValue.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
        ));
      } else if (rawDropdownValue is String) {
        // Split comma-separated string into list
        dropdownList = rawDropdownValue
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return AttributeDetail(
      id: json['id']?.toString(),
      catId: int.parse(json['cat_id'].toString()),
      type: json['type'],
      label: json['label'],
      attribute: json['attribute'],
      required: json['required'],
      dropdownValue: rawDropdownValue?.toString(),
      dropdownList: dropdownList,
      dropdownMap: dropdownMap,
      isDeleted: json['isdeleted'],
      createdAt: json['created_at'],
    );
  }

}

class ChildSubcategoryResponse {
  final String status;
  final String message;
  final List<ChildSubcategoryDetail> details;

  ChildSubcategoryResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory ChildSubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return ChildSubcategoryResponse(
      status: json['status'],
      message: json['message'],
      details: List<ChildSubcategoryDetail>.from(
        json['details'].map((x) => ChildSubcategoryDetail.fromJson(x)),
      ),
    );
  }
}

class ChildSubcategoryDetail {
  final int subcatId;
  final String type;
  final String label;
  final String attribute;
  final String required;
  final Map<String, String> dropdownValues;
  final String isDeleted;
  final String createdAt;

  ChildSubcategoryDetail({
    required this.subcatId,
    required this.type,
    required this.label,
    required this.attribute,
    required this.required,
    required this.dropdownValues,
    required this.isDeleted,
    required this.createdAt,
  });

  factory ChildSubcategoryDetail.fromJson(Map<String, dynamic> json) {
    return ChildSubcategoryDetail(
      subcatId: json['subcat_id'],
      type: json['type'],
      label: json['label'],
      attribute: json['attribute'],
      required: json['required'],
      dropdownValues: Map<String, String>.from(json['dropdown_values']),
      isDeleted: json['isdeleted'],
      createdAt: json['created_at'],
    );
  }
}
