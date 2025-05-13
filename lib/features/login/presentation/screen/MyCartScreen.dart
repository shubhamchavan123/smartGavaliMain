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

    // Future<String> placeOrder(
    //   List<CalciumMineralMixtureProductListModel> productList,
    //   Map<String, int> quantities,
    // ) async {
    //   try {
    //     // Convert products to JSON-serializable map
    //     List<Map<String, dynamic>> productJson = productList.map((product) {
    //       return {
    //         "product_id": product.id,
    //         "quantity": quantities[product.id] ?? 0,
    //       };
    //     }).toList();
    //     final response = await http.post(
    //       Uri.parse("https://sks.sitsolutions.co.in/place_order"),
    //       headers: <String, String>{
    //         'Content-Type': 'application/json',
    //       },
    //       body: jsonEncode(<String, dynamic>{
    //         "product": productJson,
    //         "user_id": 4,
    //         "order_type": "Cash On Delivery",
    //       }),
    //     );
    //
    //     if (kDebugMode) {
    //       print(
    //           "Constant.placeOrder https://sks.sitsolutions.co.in/place_orde");
    //       print("placeOrder response:${response.body}");
    //     }
    //
    //     if (response.statusCode == 200 || response.statusCode == 201) {
    //       final jsonresponse = jsonDecode(response.body);
    //       if (kDebugMode) {
    //         print("jsonresponse: $jsonresponse");
    //       }
    //
    //       if (jsonresponse['status'] == "success") {
    //         String message = jsonresponse["message"];
    //         print("******************************placeOrder message $message");
    //
    //         return message; // Return the message string
    //       }
    //     } else if (response.statusCode == 400) {
    //       final jsonresponse = jsonDecode(response.body);
    //       if (kDebugMode) {
    //         print("jsonresponse400: $jsonresponse");
    //       }
    //
    //       if (jsonresponse['status'] == false) {
    //         String message = jsonresponse["errors"];
    //         print(
    //             "******************************placeOrder message400 $message");
    //
    //         return message; // Return the message string
    //       }
    //     } else if (response.statusCode == 401) {
    //       final jsonresponse = jsonDecode(response.body);
    //       if (kDebugMode) {
    //         print("jsonresponse400: $jsonresponse");
    //       }
    //
    //       if (jsonresponse['status'] == false) {
    //         String message = jsonresponse["message"];
    //         print(
    //             "******************************placeOrder message400 $message");
    //
    //         return message; // Return the message string
    //       }
    //     }
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print("placeOrder Error $e");
    //     }
    //     return "Error occurred while placeOrder ";
    //   }
    //   return "Verification failed";
    // }

    // Initialize ApiService instance
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
