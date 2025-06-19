import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/CategoryScreen.dart';
import 'package:http/http.dart' as http;
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../provider/calcium_mineral_product_provider.dart';
import '../../../AllScreens/presentation/screen/MyCartScreen.dart';

// class ProductListScreen extends StatelessWidget {
//   final String subCatId;
//
//   const ProductListScreen({super.key, required this.subCatId});
//
//   // Future<List<CalciumMineralMixtureProductListModel>> fetchProducts() async {
//   //   final response = await http
//   //       .get(Uri.parse('https://sks.sitsolutions.co.in/product_list'));
//   //
//   //   if (response.statusCode == 200) {
//   //     final jsonData = jsonDecode(response.body);
//   //     final List products = jsonData["details"];
//   //
//   //     return products
//   //         .map((item) => CalciumMineralMixtureProductListModel.fromJson(item))
//   //         .where((p) => p.subcatId == subCatId && p.isdeleted == "0")
//   //         .toList();
//   //   } else {
//   //     throw Exception('Failed to load products');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'उत्पादने',
//           style: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         centerTitle: false,
//         leading: Container(
//           margin: EdgeInsets.all(8),
//           child: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),
//       // AppBar(
//       //   title: const Text("उत्पादने"),
//       //   backgroundColor: Colors.green[700],
//       // ),
//       body: FutureBuilder<List<CalciumMineralMixtureProductListModel>>(
//         future: ApiService.fetchProducts(subCatId),  // Fetching products using the ApiService
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           final products = snapshot.data ?? [];
//
//           if (products.isEmpty) {
//             return const Center(child: Text("उत्पादने उपलब्ध नाहीत."));
//           }
//
//           return GridView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: products.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, // 2 items per row
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.75, // Adjust to fit content
//             ),
//             itemBuilder: (context, index) {
//               final product = products[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ProductDetailsScreen(productId: product.id),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               product.image,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               errorBuilder: (_, __, ___) => Image.asset(
//                                 'assets/images/placeholder.png',
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           product.name,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "किंमत: ${product.price}",
//                           style: const TextStyle(fontSize: 13),
//                         ),
//                         Text(
//                           "प्रमाण: ${product.quantity}",
//                           style: const TextStyle(fontSize: 13),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class ProductDetailsScreen extends StatelessWidget {
//   final String productId;
//
//   const ProductDetailsScreen({Key? key, required this.productId})
//       : super(key: key);
//
//   // Future<ProductDetails> fetchProductDetails() async {
//   //   final url = Uri.parse('https://sks.sitsolutions.co.in/product_details');
//   //   final response = await http.post(
//   //     url,
//   //     headers: {'Content-Type': 'application/json'},
//   //     body: jsonEncode({'product_id': productId}),
//   //   );
//   //
//   //   if (response.statusCode == 200) {
//   //     final jsonData = json.decode(response.body);
//   //     return ProductDetails.fromJson(jsonData['details']);
//   //   } else {
//   //     throw Exception('Failed to load product details');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'उत्पादन माहिती',
//           style: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         centerTitle: false,
//         leading: Container(
//           margin: EdgeInsets.all(8),
//           child: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),
//       // AppBar(
//       //   title: const Text("उत्पादन माहिती"),
//       //   backgroundColor: Colors.green[700],
//       // ),
//       body: FutureBuilder<ProductDetails>(
//         future: ApiService.fetchProductDetails(productId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           final product = snapshot.data!;
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       product.image,
//                       height: 250,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Image.asset(
//                         'assets/images/placeholder.png',
//                         height: 250,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(product.name,
//                     style: const TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 Text("किंमत: ${product.price}",
//                     style: const TextStyle(fontSize: 16)),
//                 Text("प्रमाण: ${product.quantity}",
//                     style: const TextStyle(fontSize: 16)),
//                 Text("वजन: ${product.weight}",
//                     style: const TextStyle(fontSize: 16)),
//                 Text("शेवटची तारीख: ${product.expiryDate}",
//                     style: const TextStyle(fontSize: 16)),
//                 const SizedBox(height: 10),
//                 const Text("वर्णन:",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 5),
//                 Text(product.description, style: const TextStyle(fontSize: 15)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalciumMineralProductProvider>(context);
    final product = provider.products.firstWhere(
          (p) => p.id == widget.productId,
      orElse: () => CalciumMineralMixtureProductListModel(
        id: '',
        name: 'Product not found',
        image: '',
        price: '0',
        quantity: '0',
        subcatId: '',
        isdeleted: '0',
        catId: '',
        description: '',
        expiryDate: '',
        weight: '',
        unit: '',
        createdAt: '',
      ),
    );

    final quantity = provider.getQuantity(product);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'उत्पादन माहिती',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            child: Consumer<CalciumMineralProductProvider>(
              builder: (context, provider, _) {
                // final cartCount = provider.selectedProducts.fold<int>(
                //   0,
                //       (sum, product) => sum + provider.getQuantity(product),
                // );
// To this (counts unique products instead of quantities):
                final cartCount = provider.selectedProducts.length;
                // final cartCount = provider.quantities.values.fold<int>(
                //   0,
                //       (sum, quantity) => sum + quantity,
                // );
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon:
                      const Icon(Icons.shopping_cart, color: Colors.white),


                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCartScreen()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            cartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Product Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  buildDetail("किंमत", "₹${product.price}"),
                  buildDetail("प्रमाण", product.quantity),
                  buildDetail("वजन", product.weight),
                  buildDetail("शेवटची तारीख", product.expiryDate),
                  const SizedBox(height: 12),
                  const Text("वर्णन",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w800,fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Add to Cart
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: quantity == 0
                  ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add_shopping_cart, color: Colors.brown,size: 20,),
                label: const Text("ADD TO CART",
                    style: TextStyle(color: Colors.brown, fontSize: 16,fontWeight:FontWeight.w800)),
                onPressed: () {
                  provider.increment(product);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Product added to cart'),
                    duration: Duration(seconds: 1),
                  ));
                },
              )
                  : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.green),
                      onPressed: () => provider.decrement(product),
                    ),
                    Text('$quantity',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () => provider.increment(product),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text("$title: ",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87,fontSize: 18)),
          Flexible(child: Text(value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w800,fontSize: 15))),
        ],
      ),
    );
  }
}

/*
class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalciumMineralProductProvider>(context);
    final product = provider.products.firstWhere(
          (p) => p.id == widget.productId,
      orElse: () => CalciumMineralMixtureProductListModel(
        id: '',
        name: 'Product not found',
        image: '',
        price: '0',
        quantity: '0',
        subcatId: '',
        isdeleted: '0', catId: '', description: '', expiryDate: '', weight: '', unit: '', createdAt: '',
      ),
    );

    final quantity = provider.getQuantity(product);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'उत्पादन माहिती',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            child: Consumer<CalciumMineralProductProvider>(
              builder: (context, provider, _) {
                final cartCount = provider.selectedProducts.length;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCartScreen()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            cartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
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
      body: SingleChildScrollView(
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
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "किंमत: ${product.price}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "प्रमाण: ${product.quantity}",
              style: const TextStyle(fontSize: 16),
            ),
    Text("वजन: ${product.weight}",
                    style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
    Text("शेवटची तारीख: ${product.expiryDate}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                const Text("वर्णन:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(product.description, style: const TextStyle(fontSize: 15)),
            // Add to cart section
            Center(
              child: quantity == 0
                  ? Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  child: const Text(
                    "ADD TO CART",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    provider.increment(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product added to cart'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              )
                  : Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      color: Colors.blue,
                      onPressed: quantity > 0
                          ? () => provider.decrement(product)
                          : null,
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.blue,
                      onPressed: () => provider.increment(product),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
*/

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
