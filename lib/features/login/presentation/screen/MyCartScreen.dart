import 'dart:convert';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'package:smart_gawali/provider/calcium_mineral_product_provider.dart';
// import '../provider/calcium_mineral_product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// class MyCartScreen extends StatelessWidget {
//   const MyCartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CalciumMineralProductProvider>(context);
//     final cartItems = cartProvider.selectedProducts;
//     final _easebuzzFlutterPlugin = EasebuzzFlutter();
//
//     double total = 0;
//     for (var product in cartItems) {
//       final quantity = cartProvider.getQuantity(product);
//       final price = double.tryParse(product.price) ?? 0;
//       total += quantity * price;
//     }
//
//     Future<void> initiatePayment() async {
//       try {
//         // First place the order
//         final apiService = ApiService();
//         String orderResult = await apiService.placeOrder(
//             cartProvider.selectedProducts, cartProvider.quantities);
//
//         if (!orderResult.toLowerCase().contains("placed order successfully.")) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(orderResult)),
//           );
//           return;
//         }
//
//         // Then initiate payment
//         String accessKey = "test_b5ef9aeb61ef4a1"; // Replace with actual key
//         String payMode = "test"; // Use "production" for live mode
//
//         final String? paymentResult = await _easebuzzFlutterPlugin.payWithEasebuzz(
//           accessKey,
//           payMode,
//         );
//
//         if (paymentResult == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Payment cancelled or failed.')),
//           );
//           return;
//         }
//
//         final Map<String, dynamic> paymentResponse = jsonDecode(paymentResult);
//
//         if (paymentResponse['status'] == 'success') {
//           cartProvider.removeAll();
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Payment successful! Order placed.')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Payment failed: ${paymentResponse['error_message'] ?? 'Unknown error'}')),
//           );
//         }
//       } on PlatformException catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Payment error: ${e.message}')),
//         );
//       }
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'माझं कार्ट',
//           style: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         centerTitle: false,
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
//       body: cartItems.isEmpty
//           ? const Center(child: Text('कार्ट रिकामं आहे.'))
//           : Column(
//         children: [
//           Expanded(
//             child: ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemCount: cartItems.length,
//               separatorBuilder: (context, index) =>
//               const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final product = cartItems[index];
//                 final quantity = cartProvider.getQuantity(product);
//
//                 return Card(
//                   color: Colors.white,
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Image.network(
//                               product.image,
//                               height: 80,
//                               width: 80,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) =>
//                                   Image.asset(
//                                     'assets/images/placeholder.png',
//                                     height: 80,
//                                     width: 80,
//                                     fit: BoxFit.cover,
//                                   ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     product.name,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'रु. ${product.price}',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove),
//                               onPressed: () {
//                                 cartProvider.decrement(product);
//                               },
//                             ),
//                             Text(quantity.toString()),
//                             IconButton(
//                               icon: const Icon(Icons.add),
//                               onPressed: () {
//                                 cartProvider.increment(product);
//                               },
//                             ),
//                             const Spacer(),
//                             OutlinedButton(
//                               style: OutlinedButton.styleFrom(
//                                 side: const BorderSide(color: Colors.red),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(8)),
//                               ),
//                               onPressed: () {
//                                 cartProvider.removeProduct(product);
//                               },
//                               child: const Text('काढा',
//                                   style: TextStyle(color: Colors.red)),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: cartItems.isEmpty
//           ? null
//           : Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: const BoxDecoration(
//           border: Border(
//             top: BorderSide(color: Colors.grey),
//           ),
//         ),
//         child: Row(
//           children: [
//             Text(
//               'रु. $total',
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: initiatePayment,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30)),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 24, vertical: 12),
//               ),
//               child: const Text('ऑर्डर लॉक करा'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CalciumMineralProductProvider>(context);
    final cartItems = cartProvider.selectedProducts;

    double total = 0;
    double originalTotal = 0;

    for (var product in cartItems) {
      final quantity = cartProvider.getQuantity(product);
      final price = double.tryParse(product.price) ?? 0;
      total += quantity * price;

      // If original price (MRP) was available, replace with actual
      originalTotal += quantity * price; // Replace with original if needed
    }


    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'माझं कार्ट',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
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
      body: cartItems.isEmpty
          ? const Center(child: Text('कार्ट रिकामं आहे.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      final quantity = cartProvider.getQuantity(product);

                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    product.image,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/placeholder.png',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              'रु. ${product.price}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      cartProvider.decrement(product);
                                    },
                                  ),
                                  Text(quantity.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      cartProvider.increment(product);
                                    },
                                  ),
                                  const Spacer(),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.red),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      cartProvider.removeProduct(product);
                                    },
                                    child: const Text('काढा',
                                        style: TextStyle(color: Colors.red)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'रु. $total',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      // Handle order confirmation
                      final selected = cartProvider.selectedProducts;
                      final quantities = cartProvider.quantities;
                      if (selected.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please add the products")));
                        return;
                      }

                      // if (selectedDate2 == null) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text("Please enter delivery date")));
                      //   return;
                      // }
                      // placeOrderPopUp(
                      //     context, selectedDate2!, selected, quantities);
                      print("Selected Products: $selected");
                      // String result = await ApiService.placeOrder(selected, quantities);
                      String result = await apiService.placeOrder(
                          selected, quantities);

                      print(
                          "--------------------------------------place order result: $result");

                      if (result
                          .toLowerCase()
                          .contains("placed order successfully.")) {
                        cartProvider.removeAll();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(result)), // Show success message
                        );
                      } else {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(result)), // Show failure message
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                      child: const Text('ऑर्डर लॉक करा'),
                  )
                ],
              ),
            ),
    );
  }
}
