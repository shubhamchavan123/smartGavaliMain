import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/CategoryScreen.dart';
import 'package:http/http.dart' as http;
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatelessWidget {
  final String subCatId;

  const ProductListScreen({super.key, required this.subCatId});

  // Future<List<CalciumMineralMixtureProductListModel>> fetchProducts() async {
  //   final response = await http
  //       .get(Uri.parse('https://sks.sitsolutions.co.in/product_list'));
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     final List products = jsonData["details"];
  //
  //     return products
  //         .map((item) => CalciumMineralMixtureProductListModel.fromJson(item))
  //         .where((p) => p.subcatId == subCatId && p.isdeleted == "0")
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'उत्पादने',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      // AppBar(
      //   title: const Text("उत्पादने"),
      //   backgroundColor: Colors.green[700],
      // ),
      body: FutureBuilder<List<CalciumMineralMixtureProductListModel>>(
        future: ApiService.fetchProducts(subCatId),  // Fetching products using the ApiService
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("उत्पादने उपलब्ध नाहीत."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // Adjust to fit content
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(productId: product.id),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "किंमत: ${product.price}",
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          "प्रमाण: ${product.quantity}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  // Future<ProductDetails> fetchProductDetails() async {
  //   final url = Uri.parse('https://sks.sitsolutions.co.in/product_details');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'product_id': productId}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     return ProductDetails.fromJson(jsonData['details']);
  //   } else {
  //     throw Exception('Failed to load product details');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'उत्पादन माहिती',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      // AppBar(
      //   title: const Text("उत्पादन माहिती"),
      //   backgroundColor: Colors.green[700],
      // ),
      body: FutureBuilder<ProductDetails>(
        future: ApiService.fetchProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final product = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/placeholder.png',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("किंमत: ${product.price}",
                    style: const TextStyle(fontSize: 16)),
                Text("प्रमाण: ${product.quantity}",
                    style: const TextStyle(fontSize: 16)),
                Text("वजन: ${product.weight}",
                    style: const TextStyle(fontSize: 16)),
                Text("शेवटची तारीख: ${product.expiryDate}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                const Text("वर्णन:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(product.description, style: const TextStyle(fontSize: 15)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProductDetails {
  final String id;
  final String name;
  final String image;
  final String description;
  final String price;
  final String quantity;
  final String expiryDate;
  final String weight;

  ProductDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.quantity,
    required this.expiryDate,
    required this.weight,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
      expiryDate: json['expiry_date'],
      weight: json['weight'],
    );
  }
}
