import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/features/category/presentation/screen/ChildSubcategoryList.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import 'package:smart_gawali/features/category/presentation/screen/ChildSubcategoryList.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_gawali/features/category/presentation/screen/ChildSubcategoryList.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';

class PostDetailsScreen extends StatelessWidget {
  final CalculationData postDetails;
  final String defaultPhoneNumber = '9359219134'; // Default phone number

  const PostDetailsScreen({super.key, required this.postDetails});

  // Function to make a phone call
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // Try multiple approaches
    final urlsToTry = [
      'tel:$cleanedNumber',
      'tel://$cleanedNumber',
      'telprompt:$cleanedNumber',
    ];

    for (final url in urlsToTry) {
      try {
        if (await canLaunch(url)) {
          await launch(url);
          return; // Exit if successful
        }
      } catch (e) {
        continue; // Try next URL
      }
    }

    // If all attempts fail
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final details = postDetails.details;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(details.category,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          Container(
            margin: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            child: Consumer<CalciumMineralProductProvider>(
              builder: (context, provider, _) {
                final cartCount = provider.selectedProducts.fold<int>(
                  0,
                      (sum, product) => sum + provider.getQuantity(product),
                );

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyCartScreen()),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(details.photo),
            const SizedBox(height: 16),
            Text(
              details.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(),
            _buildDetailRow(Icons.category, 'Category', details.category),
            _buildDetailRow(Icons.label_important, 'Type', details.type),
            _buildDetailRow(Icons.subdirectory_arrow_right, 'Sub Type', details.subType),
            _buildDetailRow(Icons.currency_rupee, 'Price', '₹${details.price}'),
            _buildDetailRow(Icons.line_weight, 'Weight', '${details.weight} ${details.unit}'),
            if (details.address != null)
              _buildDetailRow(Icons.location_on, 'Address', details.address ?? ''),
            if (details.shopName != null)
              _buildDetailRow(Icons.store, 'Shop', details.shopName ?? ''),
            // Call button with default number
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text('Call Now', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    await _makePhoneCall(context, details.mobile);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 250,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green[700], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 20, color: Colors.black),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class PostDetailsScreen extends StatelessWidget {
//   final CalculationData postDetails;
//
//   const PostDetailsScreen({super.key, required this.postDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     final details = postDetails.details;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title:  Text(details.category,
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         actions: [
//           Container(
//             margin: const EdgeInsets.all(7),
//             decoration: const BoxDecoration(
//               color: Colors.brown,
//               shape: BoxShape.circle,
//             ),
//             child: Consumer<CalciumMineralProductProvider>(
//               builder: (context, provider, _) {
//                 final cartCount = provider.selectedProducts.fold<int>(
//                   0,
//                       (sum, product) => sum + provider.getQuantity(product),
//                 );
//
//                 return Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.shopping_cart, color: Colors.white),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => MyCartScreen()),
//                         );
//                       },
//                     ),
//                     if (cartCount > 0)
//                       Positioned(
//                         top: -5,
//                         right: -5,
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           constraints: const BoxConstraints(
//                             minWidth: 20,
//                             minHeight: 20,
//                           ),
//                           child: Text(
//                             cartCount.toString(),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           )
//         ],
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
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildImage(details.photo),
//             const SizedBox(height: 16),
//             Text(
//               details.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             const Divider(),
//             _buildDetailRow(Icons.category, 'Category', details.category),
//             _buildDetailRow(Icons.label_important, 'Type', details.type),
//             _buildDetailRow(Icons.subdirectory_arrow_right, 'Sub Type', details.subType),
//             _buildDetailRow(Icons.currency_rupee, 'Price', '₹${details.price}'),
//             _buildDetailRow(Icons.line_weight, 'Weight', '${details.weight} ${details.unit}'),
//             if (details.address != null)
//               _buildDetailRow(Icons.location_on, 'Address', details.address ?? ''),
//             if (details.shopName != null)
//               _buildDetailRow(Icons.store, 'Shop', details.shopName ?? ''),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage(String imageUrl) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.green, width: 3), // 🔹 Border color and width
//         borderRadius: BorderRadius.circular(12),           // 🔹 Same as ClipRRect radius
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12), // 🔁 Match radius for smooth corners
//         child: Image.network(
//           imageUrl,
//           width: double.infinity,
//           height: 250,
//           fit: BoxFit.cover,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) return child;
//             return Container(
//               width: double.infinity,
//               height: 250,
//               color: Colors.grey[200],
//               child: const Center(child: CircularProgressIndicator()),
//             );
//           },
//           errorBuilder: (context, error, stackTrace) => Container(
//             width: double.infinity,
//             height: 250,
//             color: Colors.grey[300],
//             child: const Center(
//               child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
//             ),
//           ),
//         ),
//       ),
//     );
//
//
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.green[700], size: 22),
//           const SizedBox(width: 12),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 style: const TextStyle(fontSize: 20, color: Colors.black),
//                 children: [
//                   TextSpan(
//                     text: '$label: ',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: value),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
