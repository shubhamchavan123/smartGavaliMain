// import 'dart:ffi';
//
// import 'package:flutter/material.dart';
// import 'package:smart_gawali/features/login/presentation/screen/AnimalArjaFormScreen.dart';
//
// class MembershipDialog extends StatelessWidget {
//   const MembershipDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               '"गाय आणि म्हैस विक्रीसाठी!\nफक्त ₹29 मध्ये सदस्यता घ्या!\nआजच नोंदणी करा!"',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'सहज प्राणी अपलोड करा\nखरेदीदारांपर्यंत पोहोचा\nजल्द विक्री आणि सोपी प्रक्रिया',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFFFD700),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(8),
//                       bottomLeft: Radius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'एका महिन्यासाठी',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical:12),
//                   decoration: const BoxDecoration(
//                     color: Colors.brown,
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(8),
//                       bottomRight: Radius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     '₹२९',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 onPressed: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (_) => AnimalArjaFormScreen(
//                   //       categoryName: category.category,
//                   //     ),
//                   //   ),
//                   // );
//
//                 },
//                 child: const Text(
//                   'सुरू ठेवा',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/payment_gateway/easebuzz_payment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:easebuzz_flutter/easebuzz_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:easebuzz_flutter/easebuzz_flutter.dart';
import 'package:flutter/services.dart';

import '../../../../payment_gateway/easebuzz_backend.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easebuzz_flutter/easebuzz_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easebuzz_flutter/easebuzz_flutter.dart';

import '../../../ApiService/api_service.dart';

class SubscriptionPlanResponse {
  final String status;
  final String message;
  final List<SubscriptionPlanDetail> details;

  SubscriptionPlanResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanResponse(
      status: json['status'],
      message: json['message'],
      details: (json['details'] as List)
          .map((e) => SubscriptionPlanDetail.fromJson(e))
          .toList(),
    );
  }
}

class SubscriptionPlanDetail {
  final String id;
  final String name;
  final String price;
  final String postLimit;
  final String durationDays;
  final String description;
  final String isDeleted;
  final String createdAt;

  SubscriptionPlanDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.postLimit,
    required this.durationDays,
    required this.description,
    required this.isDeleted,
    required this.createdAt,
  });

  factory SubscriptionPlanDetail.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanDetail(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      postLimit: json['post_limit'],
      durationDays: json['duration_days'],
      description: json['description'],
      isDeleted: json['isdeleted'],
      createdAt: json['created_at'],
    );
  }
}


// class SubscriptionEasebuzzPaymentHandler {
//   static final EasebuzzFlutter _easebuzzFlutter = EasebuzzFlutter();
//
//   static Future<bool> initiatePayment({
//     required BuildContext context,
//     required String accessKey,
//     required String environment,
//     required SubscriptionPlanDetail plan,
//     required int userId,
//   }) async {
//     try {
//       // Step 1: Initiate Easebuzz payment
//       final response = await _easebuzzFlutter.payWithEasebuzz(
//         accessKey,
//         environment,
//       );
//
//       final parsedResponse = jsonDecode(response!);
//
//       if (parsedResponse['result'] == 'payment_successfull') {
//         final paymentResponse = parsedResponse['payment_response'];
//
//         // Step 2: Process payment confirmation with your backend
//         final processSuccess = await _processPaymentConfirmation(
//           context: context,
//           paymentData: {
//             "firstname": paymentResponse['firstname'],
//             "error": paymentResponse['error'] ?? "Success",
//             "addedon": paymentResponse['addedon'] ?? DateTime.now().toString(),
//             "mode": paymentResponse['mode'] ?? "Online Payment",
//             "email": paymentResponse['email'],
//             "txnid": paymentResponse['txnid'],
//             "amount": paymentResponse['amount'],
//             "phone": paymentResponse['phone'],
//             "productinfo": plan.id, // Using plan ID instead of name
//             "user_id": userId,
//             "order_type": "Online",
//           },
//
//         );
//         // Print all key-value pairs
//
//
//         if (processSuccess) {
//
//           await _showPaymentDialog(
//             context,
//             'Payment Successful',
//             'Transaction ID: ${paymentResponse['txnid']}\n'
//                 'Plan: ${plan.name}\n'
//                 'Amount: ₹${plan.price}',
//           );
//           return true;
//         }
//         return false;
//       } else {
//         await _showPaymentDialog(
//           context,
//           'Payment Cancel',
//           parsedResponse['payment_response']['error_Message'] ??
//               'Payment failed',
//         );
//         return false;
//       }
//     } on PlatformException catch (e) {
//       await _showPaymentDialog(context, 'Error', e.message ?? 'Payment error');
//       return false;
//     } catch (e) {
//       await _showPaymentDialog(context, 'Error', e.toString());
//       return false;
//     }
//   }
//
//   static Future<bool> _processPaymentConfirmation({
//     required BuildContext context,
//     required Map<String, dynamic> paymentData,
//   }) async {
//     try {
//       final response = await http.post(
//           ApiService.subscriptionPaymentProcess,
//         // Uri.parse('https://sks.sitsolutions.co.in/subscription_payment_process'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(paymentData),
//       );
//       paymentData.forEach((key, value) {
//         print('pay$key: $value');
//       });
//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         if (result['status'] == 'success') {
//           return true;
//         } else {
//           await _showPaymentDialog(
//             context,
//             'Processing Error',
//             result['message'] ?? 'Failed to process payment confirmation',
//           );
//           return false;
//         }
//       } else {
//         await _showPaymentDialog(
//           context,
//           'Server Error',
//           'Failed to confirm payment (Status: ${response.statusCode})',
//         );
//         return false;
//       }
//     } catch (e) {
//       await _showPaymentDialog(
//         context,
//         'Network Error',
//         'Failed to connect to server: ${e.toString()}',
//       );
//       return false;
//     }
//   }
//
//   static Future<void> _showPaymentDialog(
//       BuildContext context, String title, String message) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false, // Optional: disable tap outside to close
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.cancel_rounded, color: Colors.red,size: 50,),
//             const SizedBox(width: 8),
//               // Expanded(
//               //   child: Text(
//               //     title,
//               //     style: const TextStyle(fontWeight: FontWeight.bold),
//               //   ),
//               // ),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Text(
//             title,
//             style: const TextStyle(fontSize: 25, height: 1.5),
//           ),
//         ),
//         actionsPadding: const EdgeInsets.only(right: 16, bottom: 8),
//         actions: [
//           Center(
//             child: TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'OK',
//                 style: TextStyle( fontSize: 20,
//                   color: Colors.green.shade700,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class SubscriptionEasebuzzPaymentHandler {
  static final EasebuzzFlutter _easebuzzFlutter = EasebuzzFlutter();

  static Future<bool> initiatePayment({
    required BuildContext context,
    required String accessKey,
    required String environment,
    required SubscriptionPlanDetail plan,
    required int userId,
  }) async {
    try {
      final response = await _easebuzzFlutter.payWithEasebuzz(
        accessKey,
        environment,
      );

      final parsedResponse = jsonDecode(response!);

      if (parsedResponse['result'] == 'payment_successfull') {
        final paymentResponse = parsedResponse['payment_response'];

        final processSuccess = await _processPaymentConfirmation(
          context: context,
          paymentData: {
            "firstname": paymentResponse['firstname'],
            "error": paymentResponse['error'] ?? "Success",
            "addedon":  DateTime.now().toString(),
            "mode": paymentResponse['mode'] ?? "Online Payment",
            "email": paymentResponse['email'],
            "txnid": paymentResponse['txnid'],
            "amount": paymentResponse['amount'],
            "phone": paymentResponse['phone'],
            "productinfo": plan.id,
            "user_id": userId,
            "order_type": "Online",
          },
        );

        if (processSuccess) {
          await _showSuccessDialog(
            context,
            'Transaction ID: ${paymentResponse['txnid']}\n'
                'Plan: ${plan.name}\n'
                'Amount: ₹${plan.price}',
          );
          return true;
        }
        return false;
      } else {
        await _showErrorOrCancelDialog(
          context,
          parsedResponse['payment_response']['error_Message'] ?? 'Payment failed',
        );
        return false;
      }
    } on PlatformException catch (e) {
      await _showErrorOrCancelDialog(context, e.message ?? 'Payment error');
      return false;
    } catch (e) {
      await _showErrorOrCancelDialog(context, e.toString());
      return false;
    }
  }

  static Future<bool> _processPaymentConfirmation({
    required BuildContext context,
    required Map<String, dynamic> paymentData,
  }) async {
    try {
      final response = await http.post(
        ApiService.subscriptionPaymentProcess,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(paymentData),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          return true;
        } else {
          await _showErrorOrCancelDialog(
            context,
            result['message'] ?? 'Failed to process payment confirmation',
          );
          return false;
        }
      } else {
        await _showErrorOrCancelDialog(
          context,
          'Failed to confirm payment (Status: ${response.statusCode})',
        );
        return false;
      }
    } catch (e) {
      await _showErrorOrCancelDialog(
        context,
        'Failed to connect to server: ${e.toString()}',
      );
      return false;
    }
  }

  /// ✅ Dialog for Payment Success
  static Future<void> _showSuccessDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 50),
            SizedBox(height: 8),
            Text(
              'Payment Successful',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 8),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ❌ Dialog for Payment Cancel/Error
  static Future<void> _showErrorOrCancelDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cancel_rounded, color: Colors.red, size: 50),
            SizedBox(height: 8),
            Text(
              'Payment Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // content: Text(
        //   message,
        //   style: const TextStyle(fontSize: 16, height: 1.5),
        // ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 8),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MembershipDialog extends StatefulWidget {
//   const MembershipDialog({super.key});
//
//   @override
//   State<MembershipDialog> createState() => _MembershipDialogState();
// }
//
// class _MembershipDialogState extends State<MembershipDialog> {
//   SubscriptionPlanDetail? selectedPlan;
//   bool isLoading = true;
//   bool isProcessingPayment = false;
//   String? errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPlans();
//   }
//
//   Future<void> _loadPlans() async {
//     setState(() => isLoading = true);
//     try {
//       final response = await SubscriptionService.fetchPlans();
//       if (response.details.isNotEmpty) {
//         setState(() => selectedPlan = response.details.first);
//       } else {
//         setState(() => errorMessage = 'No subscription plans available');
//       }
//     } catch (e) {
//       setState(() => errorMessage = 'Failed to load plans: ${e.toString()}');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _initiatePayment() async {
//     if (selectedPlan == null) return;
//
//     setState(() {
//       isProcessingPayment = true;
//       errorMessage = null;
//     });
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final paymentData = {
//         'productinfo': 'Subscription: ${selectedPlan!.name}',
//         'firstname': prefs.getString('user_name') ?? 'Customer',
//         'email': prefs.getString('user_email') ?? 'customer@example.com',
//         'phone': prefs.getString('user_phone') ?? '0000000000',
//         'plan_id': selectedPlan!.id,
//         'amount': selectedPlan!.price,
//       };
//
//
//       final userId = int.tryParse(prefs.getString('user_id') ?? '0') ?? 0;
//
//       final accessKey = await _getPaymentAccessKey(paymentData);
//
//       final paymentSuccess = await SubscriptionEasebuzzPaymentHandler.initiatePayment(
//         context: context,
//         accessKey: accessKey,
//         environment: 'test', // Change to 'production' for live
//         plan: selectedPlan!,
//         userId: userId,
//       );
//
//       if (paymentSuccess && mounted) {
//         // await _saveSubscription(paymentData);
//         Navigator.pop(context, true);
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text('Subscription activated successfully!')),
//         // );
//       }
//     } catch (e) {
//       setState(() => errorMessage = e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment failed: ${e.toString()}')),
//       );
//     } finally {
//       if (mounted) setState(() => isProcessingPayment = false);
//     }
//   }
//
//   Future<String> _getPaymentAccessKey(Map<String, dynamic> paymentData) async {
//     try {
//       // Ensure we're only sending the numeric plan ID
//       final planId = paymentData['plan_id'].toString().replaceAll(RegExp(r'[^0-9]'), '');
//
//       final response = await http.post(
//         Uri.parse('https://sks.sitsolutions.co.in/subscription_payment'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "productinfo": planId, // Send only numeric ID
//           "firstname": paymentData['firstname'],
//           "email": paymentData['email'],
//           "phone": paymentData['phone'],
//           "plan_id": planId, // Send again as backup
//           "amount": paymentData['amount'],
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         final paymentResponse = SubscriptionPaymentResponse.fromJson(responseData);
//
//         if (paymentResponse.status == 'success') {
//           return paymentResponse.accessKey;
//         }
//         throw Exception('Payment gateway error: ${paymentResponse.status}');
//       } else {
//         throw Exception('API request failed with status ${response.statusCode}');
//       }
//     } on FormatException {
//       throw Exception('Invalid server response format');
//     } catch (e) {
//       throw Exception('Payment initialization failed: $e');
//     }
//   }
//
//   Future<void> _saveSubscription(Map<String, dynamic> data) async {
//     await SubscriptionService.saveSubscription({
//       ...data,
//       'user_id': (await SharedPreferences.getInstance()).getString('user_id'),
//       'plan_name': selectedPlan!.name,
//       'duration_days': selectedPlan!.durationDays,
//       'payment_date': DateTime.now().toIso8601String(),
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: _buildContent(),
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     if (isLoading) return const Center(child: CircularProgressIndicator());
//     if (errorMessage != null) return _buildErrorState();
//     if (selectedPlan == null) return const Text('No plans available');
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildPlanDetails(),
//         const SizedBox(height: 16),
//         _buildPaymentButton(),
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildErrorState() => Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Text(errorMessage!, style: const TextStyle(color: Colors.red)),
//       const SizedBox(height: 16),
//       ElevatedButton(
//         onPressed: _loadPlans,
//         child: const Text('Retry'),
//       ),
//     ],
//   );
//
//   Widget _buildPlanDetails() => Column(
//     children: [
//       Text(
//         '"${selectedPlan!.name}!\nफक्त ₹${selectedPlan!.price} मध्ये सदस्यता घ्या!\nआजच नोंदणी करा!"',
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//       ),
//       const SizedBox(height: 16),
//       Text(
//         selectedPlan!.description,
//         textAlign: TextAlign.center,
//         style: const TextStyle(color: Colors.grey),
//       ),
//       const SizedBox(height: 16),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
//             decoration: const BoxDecoration(
//               color: Color(0xFFFFD700),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 bottomLeft: Radius.circular(8),
//               ),
//             ),
//             child: Text(
//               '${selectedPlan!.durationDays} दिवसांसाठी',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             decoration: const BoxDecoration(
//               color: Colors.brown,
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(8),
//                 bottomRight: Radius.circular(8),
//               ),
//             ),
//             child: Text(
//               '₹${selectedPlan!.price}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
//
//   Widget _buildPaymentButton() => SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 12),
//       ),
//       onPressed: isProcessingPayment ? null : _initiatePayment,
//       child: isProcessingPayment
//           ? const CircularProgressIndicator(color: Colors.white)
//           : const Text(
//         'सुरू ठेवा',
//         style: TextStyle(fontSize: 16, color: Colors.white),
//       ),
//     ),
//   );
// }

// class SubscriptionService {
//   static Future<SubscriptionPlanResponse> fetchPlans() async {
//     final response = await http.get(
//       Uri.parse('https://sks.sitsolutions.co.in/subscription_plan_list'),
//     );
//     if (response.statusCode == 200) {
//       return SubscriptionPlanResponse.fromJson(jsonDecode(response.body));
//     }
//     throw Exception('Failed to load plans: ${response.statusCode}');
//   }
//
//   static Future<void> saveSubscription(Map<String, dynamic> data) async {
//     final response = await http.post(
//       Uri.parse('https://sks.sitsolutions.co.in/save_subscription'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(data),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to save subscription: ${response.statusCode}');
//     }
//     final result = jsonDecode(response.body);
//     if (result['status'] != 'success') {
//       throw Exception(result['message'] ?? 'Subscription save failed');
//     }
//   }
// }

class MembershipDialog extends StatefulWidget {
  const MembershipDialog({super.key});

  @override
  State<MembershipDialog> createState() => _MembershipDialogState();
}

class _MembershipDialogState extends State<MembershipDialog> {
  SubscriptionPlanDetail? selectedPlan;
  bool isLoading = true;
  bool isProcessingPayment = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => isLoading = true);
    try {
      final response = await SubscriptionService.fetchPlans();
      if (response.details.isNotEmpty) {
        setState(() => selectedPlan = response.details.first);
      } else {
        setState(() => errorMessage = 'No subscription plans available');
      }
    } catch (e) {
      setState(() => errorMessage = 'Failed to load plans: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _initiatePayment() async {
    if (selectedPlan == null) return;

    setState(() {
      isProcessingPayment = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentData = {
        'productinfo': 'Subscription: ${selectedPlan!.name}',
        'firstname': prefs.getString('name') ?? 'Customer',
        'email': prefs.getString('user_email') ?? 'customer@example.com',
        'phone': prefs.getString('mobile') ?? '0000000000',
        'plan_id': selectedPlan!.id,
        'amount': selectedPlan!.price,
      };

      final userId = int.tryParse(prefs.getString('user_id') ?? '0') ?? 0;

      final accessKey = await _getPaymentAccessKey(paymentData);

      final paymentSuccess =
          await SubscriptionEasebuzzPaymentHandler.initiatePayment(
        context: context,
        accessKey: accessKey,
        environment: ApiService.paymentEnvironment, // use from ApiService, // Change to 'production' for live
        plan: selectedPlan!,
        userId: userId,
      );

      if (paymentSuccess && mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => isProcessingPayment = false);
    }
  }

  Future<String> _getPaymentAccessKey(Map<String, dynamic> paymentData) async {
    try {
      final planId =
          paymentData['plan_id'].toString().replaceAll(RegExp(r'[^0-9]'), '');

      final response = await http.post(
          ApiService.subscriptionPayment,
        // Uri.parse('https://sks.sitsolutions.co.in/subscription_payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "productinfo": planId,
          "firstname": paymentData['firstname'],
          "email": paymentData['email'],
          "phone": paymentData['phone'],
          "plan_id": planId,
          "amount": paymentData['amount'],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final paymentResponse =
            SubscriptionPaymentResponse.fromJson(responseData);

        if (paymentResponse.status == 'success') {
          return paymentResponse.accessKey;
        }
        throw Exception('Payment gateway error: ${paymentResponse.status}');
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}');
      }
    } on FormatException {
      throw Exception('Invalid server response format');
    } catch (e) {
      throw Exception('Payment initialization failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Important to make gradient visible
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) return _buildErrorState();
    if (selectedPlan == null || SubscriptionService.plans.isEmpty) {
      return const Text('No plans available');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Available Subscription Plans',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black87),
        ),
        const SizedBox(height: 16),
        _buildPlansList(),
        const SizedBox(height: 0),
        if (selectedPlan != null) _buildSelectedPlanDetails(),
        const SizedBox(height: 16),
        _buildPaymentButton(),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',style: TextStyle(color: Colors.red,fontSize: 20),),
        ),
      ],
    );
  }

  Widget _buildPlansList() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: SubscriptionService.plans.length,
        itemBuilder: (context, index) {
          final plan = SubscriptionService.plans[index];
          return _buildPlanItem(plan);
        },
      ),
    );
  }

  Widget _buildPlanItem(SubscriptionPlanDetail plan) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: selectedPlan?.id == plan.id ? Colors.blue[100] : null,
      child: ListTile(
        title: Text(plan.name),
        subtitle: Text('₹${plan.price} for ${plan.durationDays} days'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          setState(() {
            selectedPlan = plan;
          });
        },
      ),
    );
  }

  Widget _buildSelectedPlanDetails() {
    return Column(
      children: [
        Text(
          'Selected Plan: ${selectedPlan!.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Price: ₹${selectedPlan!.price}',
          style: const TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Duration: ${selectedPlan!.durationDays} days',
          style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
            'PostLimit: ${selectedPlan!.postLimit}',

            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        Text(
          selectedPlan!.description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
        ),

      ],
    );
  }

  Widget _buildErrorState() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPlans,
            child: const Text('Retry'),
          ),
        ],
      );

  Widget _buildPaymentButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: isProcessingPayment ? null : _initiatePayment,
          child:

           Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
        ),
      );
}

class SubscriptionService {
  static List<SubscriptionPlanDetail> plans = [];

  static Future<SubscriptionPlanResponse> fetchPlans() async {
    final response = await http.get(
        ApiService.subscriptionPlanList,
      // Uri.parse('https://sks.sitsolutions.co.in/subscription_plan_list'),
    );
    if (response.statusCode == 200) {
      final result =
          SubscriptionPlanResponse.fromJson(jsonDecode(response.body));
      plans = result.details;
      return result;
    }
    throw Exception('Failed to load plans: ${response.statusCode}');
  }

  static Future<void> saveSubscription(Map<String, dynamic> data) async {
    final response = await http.post(
        ApiService.saveSubscription,
      // Uri.parse('https://sks.sitsolutions.co.in/save_subscription'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save subscription: ${response.statusCode}');
    }
    final result = jsonDecode(response.body);
    if (result['status'] != 'success') {
      throw Exception(result['message'] ?? 'Subscription save failed');
    }
  }
}

class SubscriptionPaymentResponse {
  final String status;
  final String accessKey;
  final String transactionId;

  SubscriptionPaymentResponse({
    required this.status,
    required this.accessKey,
    required this.transactionId,
  });

  factory SubscriptionPaymentResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaymentResponse(
      status: json['status'] ?? '',
      accessKey: json['access_key'] ?? '',
      transactionId: json['transaction_id'] ?? '',
    );
  }
}
