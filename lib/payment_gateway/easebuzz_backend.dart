import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easebuzz_flutter/easebuzz_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'package:smart_gawali/features/home/presentation/screen/HomeScreen.dart';

import '../features/ApiService/api_service.dart';
class EasebuzzPaymentHandler {
  static final EasebuzzFlutter _easebuzzFlutter = EasebuzzFlutter();

  static Future<bool> startPayment(
      BuildContext context,
      String accessKey,
      String environment,
      List<CalciumMineralMixtureProductListModel> productList,
      Map<String, int> quantities,
      String address, // Add address parameter
      ) async {
    try {
      final response = await _easebuzzFlutter.payWithEasebuzz(
        accessKey,
        environment,
      );

      print("Payment Success Response: $response");

      final parsedResponse = jsonDecode(response!);

      if (parsedResponse['result'] == 'payment_successfull') {

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            title: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)], // green gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Payment Successful',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Transaction ID: ${parsedResponse['payment_response']['txnid']}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) =>  HomeScreen()),
                        (route) => false,
                  );
                },
                child: const Text(
                  'Go to Home',
                  style: TextStyle(
                    color: Color(0xFF388E3C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );


        // showDialog(
        //   context: context,
        //   builder: (_) =>
        //       AlertDialog(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(16),
        //     ),
        //     elevation: 5,
        //     title: Row(
        //       children: [
        //         Icon(Icons.check_circle, color: Colors.green),
        //         SizedBox(width: 8),
        //         Text(
        //           'Payment Successful',
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),
        //     content: Text(
        //       'Transaction ID: ${parsedResponse['payment_response']['txnid']}',
        //       style: TextStyle(fontSize: 16),
        //     ),
        //     actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         child: Text(
        //           'OK',
        //           style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
        //         ),
        //       ),
        //     ],
        //   ),
        // );


        await sendPaymentDataToBackend(
          parsedResponse['payment_response'],
          productList,
          quantities,
          address, // Pass address to backend
        );
        return true;
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Payment Cancel'),
            // content: Text(parsedResponse['payment_response']['error_Message'] ??
            //     'Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return false;
      }
    } on PlatformException catch (e) {
      print("Payment failed: ${e.message}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(e.message ?? 'Platform error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
  }

  static Future<void> sendPaymentDataToBackend(
      Map<String, dynamic> paymentData,
      List<CalciumMineralMixtureProductListModel> productList,
      Map<String, int> quantities,
      String address, // Add address parameter
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = int.parse(prefs.getString('user_id') ?? '0');

    // Convert product list and quantities to JSON
    List<Map<String, dynamic>> productJson = productList.map((product) {
      return {
        "product_id": product.id,
        "quantity": quantities[product.id] ?? 0,
      };
    }).toList();

    // var backendUrl = ApiService.placeOnlineProcess;
        // 'https://sks.sitsolutions.co.in/place_online_process';

    final response = await http.post(
      ApiService.placeOnlineProcess,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "firstname": paymentData['firstname']!,
        "error": paymentData['error'],
        "addedon": DateTime.now().toString(),
        "mode": paymentData['mode'],
        "email": paymentData['email']!,
        "txnid": paymentData['txnid']!,
        "amount": paymentData['amount']!,
        "phone": paymentData['phone']!,
        "productinfo": paymentData['productinfo']!,
        "user_id": userId,
        "order_type": 'online',
        "address": address, // Use the passed address
        "product": productJson,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response from backend: $data');
      if (data['status'] == 'success') {
        print('Payment and product data sent successfully');
      } else {
        print('Backend returned error: ${data['message']}');
      }
    } else {
      print('Failed to send data to backend: ${response.body}');
    }
  }
}
/*
class EasebuzzPaymentHandler {
  static final EasebuzzFlutter _easebuzzFlutter = EasebuzzFlutter();

  static Future<bool> startPayment(
    BuildContext context,
    String accessKey,
    String environment,
    List<CalciumMineralMixtureProductListModel> productList,
    Map<String, int> quantities,
  ) async {
    try {
      final response = await _easebuzzFlutter.payWithEasebuzz(
        accessKey,
        environment,
      );

      print("Payment Success Response: $response");

      final parsedResponse = jsonDecode(response!);

      if (parsedResponse['result'] == 'payment_successfull') {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Payment Successful'),
            content: Text(
                'Transaction ID: ${parsedResponse['payment_response']['txnid']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        await sendPaymentDataToBackend(
          parsedResponse['payment_response'],
          productList,
          quantities,
        );
        return true;
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Payment Failed'),
            content: Text(parsedResponse['payment_response']['error_Message'] ??
                'Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return false;
      }
    } on PlatformException catch (e) {
      print("Payment failed: ${e.message}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(e.message ?? 'Platform error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
  }

  static Future<void> sendPaymentDataToBackend(
    Map<String, dynamic> paymentData,
    List<CalciumMineralMixtureProductListModel> productList,
    Map<String, int> quantities,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = int.parse(prefs.getString('user_id') ?? '0');

    // Convert product list and quantities to JSON
    List<Map<String, dynamic>> productJson = productList.map((product) {
      return {
        "product_id": product.id,
        "quantity": quantities[product.id] ?? 0,
      };
    }).toList();

    const backendUrl = 'https://sks.sitsolutions.co.in/place_online_process';

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        // "payment_response": paymentData,
        "firstname": paymentData['firstname']!,
        "error": paymentData['error'],
        "addedon": paymentData['addedon'],
        "mode": paymentData['mode'],
        "email": paymentData['email']!,
        "txnid": paymentData['txnid']!,
        "amount": paymentData['amount']!,
        "phone": paymentData['phone']!,
        "productinfo": paymentData['productinfo']!,
        "user_id": userId,
        "order_type": 'online',
        "address": paymentData['address'], // ✅ Added address
        "product": productJson,
        // "user_id": userId,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response from backend: $data');
      if (data['status'] == 'success') {
        print('Payment and product data sent successfully');
      } else {
        print('Backend returned error: ${data['message']}');
      }
    } else {
      print('Failed to send data to backend: ${response.body}');
    }
  }
}
*/
