import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'package:smart_gawali/payment_gateway/easebuzz_backend.dart';
import 'package:smart_gawali/provider/calcium_mineral_product_provider.dart';
// import '../provider/calcium_mineral_product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/widgets/popup.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'package:smart_gawali/payment_gateway/easebuzz_backend.dart';
import 'package:smart_gawali/provider/calcium_mineral_product_provider.dart';
// import '../provider/calcium_mineral_product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/widgets/popup.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'MyPurchaseScreen.dart';
// ... All your imports remain unchanged ...

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CalciumMineralProductProvider>(context);
    final cartItems = cartProvider.selectedProducts;
    final apiService = ApiService();

    double total = cartItems.fold(0, (sum, product) {
      final quantity = cartProvider.getQuantity(product);
      final price = double.tryParse(product.price) ?? 0;
      return sum + quantity * price;
    });

    return Scaffold(
      // AppBar and UI code remain unchanged...
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
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
              child: Text(
                'कार्ट रिकामं आहे.',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                final quantity = cartProvider.getQuantity(product);
                final price = double.tryParse(product.price) ?? 0;
                final itemTotal = quantity * price;

                return Dismissible(
                  key: Key(product.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    cartProvider.removeProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} काढून टाकले'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image),
                              ),
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'रु. ${price.toStringAsFixed(2)} प्रति',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        cartProvider
                                            .decrement(product);
                                      },
                                    ),
                                    Text(quantity.toString(),
                                        style: const TextStyle(
                                            fontSize: 16)),
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        cartProvider
                                            .increment(product);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'रु. ${itemTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'एकूण रक्कम:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'रु. ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _placeOrder(context, cartProvider, apiService),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'ऑर्डर लॉक करा',
                        style: TextStyle( color: Colors.white,
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(
      BuildContext context,
      CalciumMineralProductProvider cartProvider,
      ApiService apiService,
      ) async {
    final selected = cartProvider.selectedProducts;
    final quantities = cartProvider.quantities;

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया उत्पादने जोडा")),
      );
      return;
    }

    final address = await showDialog<String>(
      context: context,
      builder: (_) =>  AddressInputDialog(),
    );

    if (address == null || address.isEmpty) return;

    final paymentMethod = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFFB2FF59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'पेमेंट पद्धत निवडा',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'तुम्ही तुमच्या ऑर्डरसाठी कोणती पेमेंट पद्धत वापरू इच्छिता?',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, false); // COD
                },
                icon: const Icon(Icons.money, color: Colors.white),
                label: const Text('Cash on Delivery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(45),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, true); // Online
                },
                icon: const Icon(Icons.credit_card, color: Colors.white),
                label: const Text('Online Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(45),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (paymentMethod == null) return;

    if (paymentMethod) {
      // Online Payment
      try {
        final prefs = await SharedPreferences.getInstance();
        final name = prefs.getString('name') ?? 'Customer';
        final phone = prefs.getString('mobile') ?? '0000000000';

        final accessKey = await ApiService.getacceesskey(
          "p1",
          name,
          "abc@gmail.com",
          phone,
          selected,
          quantities,
        );

        final success = await EasebuzzPaymentHandler.startPayment(
          context,
          accessKey,
          ApiService.paymentEnvironment,
          selected,
          quantities,
          address,
        );

        if (success) {
          cartProvider.removeAll();
          Fluttertoast.showToast(
            msg: 'पेमेंट यशस्वी! ऑर्डर प्लेस केले.',
            backgroundColor: Colors.green,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'पेमेंट अयशस्वी. कृपया पुन्हा प्रयत्न करा.',
            backgroundColor: Colors.red,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'त्रुटी: ${e.toString()}',
          backgroundColor: Colors.orange,
        );
      }
    } else {
      // COD Payment
      try {
        final result = await apiService.placeOrder(selected, quantities, address);
        if (result.toLowerCase().contains("placed order successfully")) {
          cartProvider.removeAll();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("ऑर्डर यशस्वी!")),
          );

          Future.delayed(const Duration(seconds: 0), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyPurchaseScreen()),
                  (Route<dynamic> route) => route.isFirst,
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("त्रुटी: ${e.toString()}")),
        );
      }
    }
  }
}
class AddressInputDialog extends StatefulWidget {
  const AddressInputDialog({super.key});

  @override
  State<AddressInputDialog> createState() => _AddressInputDialogState();
}

class _AddressInputDialogState extends State<AddressInputDialog> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'डिलिव्हरीचा पत्ता भरा',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _addressController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'संपूर्ण पत्ता व लँडमार्क लिहा',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया पत्ता लिहा';
                  }
                  if (value.length < 5) {
                    return 'पत्ता खूप लहान आहे';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: const Text('रद्द करा'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _addressController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('सबमिट'),
        ),
      ],
    );
  }
}
/*
class MyCartScreen extends StatelessWidget {
  const MyCartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CalciumMineralProductProvider>(context);
    final cartItems = cartProvider.selectedProducts;
    final apiService = ApiService();
    // Debug print product names
    for (var product in cartItems) {
      debugPrint('Product Name: ${product.name}');
    }

    double total = cartItems.fold(0, (sum, product) {
      final quantity = cartProvider.getQuantity(product);
      final price = double.tryParse(product.price) ?? 0;
      return sum + quantity * price;
    });

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
              child: Text(
                'कार्ट रिकामं आहे.',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                final quantity = cartProvider.getQuantity(product);
                final price = double.tryParse(product.price) ?? 0;
                final itemTotal = quantity * price;

                return Dismissible(
                  key: Key(product.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    cartProvider.removeProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} काढून टाकले'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'रु. ${price.toStringAsFixed(2)} प्रति',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Quantity Controls
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        cartProvider.decrement(product);
                                      },
                                    ),
                                    Text(
                                      quantity.toString(),
                                      style:
                                      const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon:
                                      const Icon(Icons.add, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        cartProvider.increment(product);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'रु. ${itemTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Order Summary
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'एकूण रक्कम:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'रु. ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          _placeOrder(context, cartProvider, apiService),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'ऑर्डर लॉक करा',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(
      BuildContext context,
      CalciumMineralProductProvider cartProvider,
      ApiService apiService,
      ) async {
    final selected = cartProvider.selectedProducts;
    final quantities = cartProvider.quantities;

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया उत्पादने जोडा")),
      );
      return;
    }

    // Show address input dialog
    final address = await showDialog<String>(
      context: context,
      builder: (context) => const AddressInputDialog(),
    );

    if (address == null || address.isEmpty) {
      return; // User cancelled or didn't enter address
    }

    // Show payment option dialog
    final paymentMethod = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFFB2FF59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'पेमेंट पद्धत निवडा',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'तुम्ही तुमच्या ऑर्डरसाठी कोणती पेमेंट पद्धत वापरू इच्छिता?',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pop(context, false), // Cash on Delivery
                icon: const Icon(Icons.money, color: Colors.white),
                label: const Text('Cash on Delivery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true), // Online Payment
                icon: const Icon(Icons.credit_card, color: Colors.white),
                label: const Text('Online Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (paymentMethod == null) return; // User cancelled

    if (paymentMethod) {
      // Online payment
      try {
        final prefs = await SharedPreferences.getInstance();

// Retrieve data from SharedPreferences
        String name = prefs.getString('name') ?? 'Customer';
        String email = prefs.getString('user_email') ?? '';
        String phone = prefs.getString('mobile') ?? '0000000000';

        String accessKey = await ApiService.getacceesskey(
          "p1",
          name,
          "abc@gmail.com",
          phone,
          selected,
          quantities,
        );

        bool startPaymentResult = await EasebuzzPaymentHandler.startPayment(
          context,
          accessKey,
          ApiService.paymentEnvironment,
          selected,
          quantities,
          address,
        );

        if (startPaymentResult) {
          cartProvider.removeAll();// removed the data from cart
          Fluttertoast.showToast(
            msg: 'पेमेंट यशस्वी! ऑर्डर प्लेस केले.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'पेमेंट अयशस्वी. कृपया पुन्हा प्रयत्न करा.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'त्रुटी: ${e.toString()}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // Cash on Delivery
      try {
        String result =
        await apiService.placeOrder(selected, quantities, address);

        if (result.toLowerCase().contains("placed order successfully.")) {
          cartProvider.removeAll();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('त्रुटी: ${e.toString()}')),
        );
      }
    }
  }
}

class AddressInputDialog extends StatefulWidget {
  const AddressInputDialog({super.key});

  @override
  State<AddressInputDialog> createState() => _AddressInputDialogState();
}

class _AddressInputDialogState extends State<AddressInputDialog> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'डिलिव्हरीचा पत्ता भरा',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _addressController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'संपूर्ण पत्ता व लँडमार्क लिहा',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया पत्ता लिहा';
                  }
                  if (value.length < 5) {
                    return 'पत्ता खूप लहान आहे';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: const Text('रद्द करा'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _addressController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('सबमिट'),
        ),
      ],
    );
  }
}
*/



