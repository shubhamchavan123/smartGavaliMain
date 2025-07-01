// import 'dart:convert';
// import 'package:easebuzz_flutter/easebuzz_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart'; // Add to pubspec.yaml: crypto: ^3.0.3
//
// class EasebuzzPaymentService {
//   static const String _merchantKey = "NQ4X2JVOF";
//   static const String _salt = "M8PAB4Q45";
//   static const String _productInfo = "Test Product";
//   static const String _surl = "https://example.com/success";
//   static const String _furl = "https://example.com/failure";
//
//   static final EasebuzzFlutter _easebuzzFlutter = EasebuzzFlutter();
//
//   static String _generateHash({
//     required String txnid,
//     required String amount,
//     required String firstname,
//     required String email,
//   }) {
//     String hashString =
//         "$_merchantKey|$txnid|$amount|$_productInfo|$firstname|$email|||||||||||$_salt";
//
//     return sha512.convert(utf8.encode(hashString)).toString();
//   }
//
//   static Future<void> initiatePayment({
//     required String txnid,
//     required String amount,
//     required String firstname,
//     required String email,
//     required String phone,
//     required bool isProduction,
//   }) async {
//     try {
//       // 1. Generate hash
//       final hash = _generateHash(
//         txnid: txnid,
//         amount: amount,
//         firstname: firstname,
//         email: email,
//       );
//       var boddy = {
//         "key": _merchantKey,
//         "txnid": txnid,
//         "amount": amount,
//         "productinfo": _productInfo,
//         "firstname": firstname,
//         "email": email,
//         "phone": phone,
//         "surl": _surl,
//         "furl": _furl,
//         "hash": hash,
//       };
//       print("Request body: $boddy");
//
//       // 2. Make POST request to initiateLink API
//       final response = await http.post(
//         Uri.parse("https://testpay.easebuzz.in/payment/initiateLink"),
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           "key": _merchantKey,
//           "txnid": txnid,
//           "amount": amount,
//           "productinfo": _productInfo,
//           "firstname": firstname,
//           "email": email,
//           "phone": phone,
//           "surl": _surl,
//           "furl": _furl,
//           "hash": hash,
//         },
//       );
//       print("Response status: ${response.body}");
//       // print("body: $response.body");
//       final data = json.decode(response.body);
//
//       if (response.statusCode == 200 && data['status'] == 1) {
//         final accessKey = data['data'];
//         // 3. Start payment
//         await _easebuzzFlutter.payWithEasebuzz(
//           accessKey,
//           isProduction ? 'production' : 'test',
//         );
//       } else {
//         print("Easebuzz Error: ${data['data']['message'] ?? 'Unknown error'}");
//       }
//     } on PlatformException catch (e) {
//       print("PlatformException during payment: ${e.message}");
//     } catch (e) {
//       print("Error initiating payment: $e");
//     }
//   }
// }
