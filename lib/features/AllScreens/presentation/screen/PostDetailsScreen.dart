// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_gawali/features/category/presentation/screen/ChildSubcategoryList.dart';
// import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';
//
// import '../../../../provider/calcium_mineral_product_provider.dart';
//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart'; // Add this import
// import 'package:smart_gawali/features/category/presentation/screen/ChildSubcategoryList.dart';
// import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';
//
// import '../../../../provider/calcium_mineral_product_provider.dart';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:smart_gawali/features/category/presentation/screen/ChildSubcategoryList.dart';
// import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';
//
// import '../../../../provider/calcium_mineral_product_provider.dart';
//
// class PostDetailsScreen extends StatelessWidget {
//   final CalculationData postDetails;
//   final String defaultPhoneNumber = '9359219134'; // Default phone number
//
//   const PostDetailsScreen({super.key, required this.postDetails});
//
//   // Function to make a phone call
//   Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
//     final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
//
//     // Try multiple approaches
//     final urlsToTry = [
//       'tel:$cleanedNumber',
//       'tel://$cleanedNumber',
//       'telprompt:$cleanedNumber',
//     ];
//
//     for (final url in urlsToTry) {
//       try {
//         if (await canLaunch(url)) {
//           await launch(url);
//           return; // Exit if successful
//         }
//       } catch (e) {
//         continue; // Try next URL
//       }
//     }
//
//     // If all attempts fail
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not launch dialer')),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final details = postDetails.details;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(details.category,
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
//             // Call button with default number
//             Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: Center(
//                 child: ElevatedButton.icon(
//                   icon: const Icon(Icons.call, color: Colors.white),
//                   label: const Text('Call Now', style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green[700],
//                     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   onPressed: () async {
//                     await _makePhoneCall(context, details.mobile);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage(String imageUrl) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.green, width: 3),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
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
// // class PostDetailsScreen extends StatelessWidget {
// //   final CalculationData postDetails;
// //
// //   const PostDetailsScreen({super.key, required this.postDetails});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final details = postDetails.details;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title:  Text(details.category,
// //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         leading: const BackButton(color: Colors.black),
// //         actions: [
// //           Container(
// //             margin: const EdgeInsets.all(7),
// //             decoration: const BoxDecoration(
// //               color: Colors.brown,
// //               shape: BoxShape.circle,
// //             ),
// //             child: Consumer<CalciumMineralProductProvider>(
// //               builder: (context, provider, _) {
// //                 final cartCount = provider.selectedProducts.fold<int>(
// //                   0,
// //                       (sum, product) => sum + provider.getQuantity(product),
// //                 );
// //
// //                 return Stack(
// //                   clipBehavior: Clip.none,
// //                   children: [
// //                     IconButton(
// //                       icon: const Icon(Icons.shopping_cart, color: Colors.white),
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (context) => MyCartScreen()),
// //                         );
// //                       },
// //                     ),
// //                     if (cartCount > 0)
// //                       Positioned(
// //                         top: -5,
// //                         right: -5,
// //                         child: Container(
// //                           padding: const EdgeInsets.all(4),
// //                           decoration: const BoxDecoration(
// //                             color: Colors.red,
// //                             shape: BoxShape.circle,
// //                           ),
// //                           constraints: const BoxConstraints(
// //                             minWidth: 20,
// //                             minHeight: 20,
// //                           ),
// //                           child: Text(
// //                             cartCount.toString(),
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 10,
// //                             ),
// //                             textAlign: TextAlign.center,
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           )
// //         ],
// //         flexibleSpace: Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _buildImage(details.photo),
// //             const SizedBox(height: 16),
// //             Text(
// //               details.description,
// //               style: const TextStyle(fontSize: 16),
// //             ),
// //             const SizedBox(height: 20),
// //             const Divider(),
// //             _buildDetailRow(Icons.category, 'Category', details.category),
// //             _buildDetailRow(Icons.label_important, 'Type', details.type),
// //             _buildDetailRow(Icons.subdirectory_arrow_right, 'Sub Type', details.subType),
// //             _buildDetailRow(Icons.currency_rupee, 'Price', '₹${details.price}'),
// //             _buildDetailRow(Icons.line_weight, 'Weight', '${details.weight} ${details.unit}'),
// //             if (details.address != null)
// //               _buildDetailRow(Icons.location_on, 'Address', details.address ?? ''),
// //             if (details.shopName != null)
// //               _buildDetailRow(Icons.store, 'Shop', details.shopName ?? ''),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildImage(String imageUrl) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         border: Border.all(color: Colors.green, width: 3), // 🔹 Border color and width
// //         borderRadius: BorderRadius.circular(12),           // 🔹 Same as ClipRRect radius
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(12), // 🔁 Match radius for smooth corners
// //         child: Image.network(
// //           imageUrl,
// //           width: double.infinity,
// //           height: 250,
// //           fit: BoxFit.cover,
// //           loadingBuilder: (context, child, loadingProgress) {
// //             if (loadingProgress == null) return child;
// //             return Container(
// //               width: double.infinity,
// //               height: 250,
// //               color: Colors.grey[200],
// //               child: const Center(child: CircularProgressIndicator()),
// //             );
// //           },
// //           errorBuilder: (context, error, stackTrace) => Container(
// //             width: double.infinity,
// //             height: 250,
// //             color: Colors.grey[300],
// //             child: const Center(
// //               child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //
// //
// //   }
// //
// //   Widget _buildDetailRow(IconData icon, String label, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Icon(icon, color: Colors.green[700], size: 22),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: RichText(
// //               text: TextSpan(
// //                 style: const TextStyle(fontSize: 20, color: Colors.black),
// //                 children: [
// //                   TextSpan(
// //                     text: '$label: ',
// //                     style: const TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                   TextSpan(text: value),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/features/category/presentation/screen/ChildSubcategoryList.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/MyCartScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';

class PostDetailsScreen extends StatelessWidget {
  final CalculationData postDetails;
  final String defaultPhoneNumber = '9359219134';

  const PostDetailsScreen({super.key, required this.postDetails});

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final urlsToTry = [
      'tel:$cleanedNumber',
      'tel://$cleanedNumber',
      'telprompt:$cleanedNumber'
    ];

    for (final url in urlsToTry) {
      try {
        if (await canLaunch(url)) {
          await launch(url);
          return;
        }
      } catch (e) {
        continue;
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  //
  // bool _shouldShowField(String? value) {
  //   return value != null && value.trim().isNotEmpty && value.trim().toLowerCase() != 'null';
  // }
  bool _shouldShowField(String? value) {
    return value != null &&
        value.trim().isNotEmpty &&
        value.trim().toLowerCase() != 'null' &&
        value.trim() != '0';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(details.photo),
            const SizedBox(height: 16),
            if (_shouldShowField(details.description))
              Text(
                details.description,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            const Divider(),

            // Basic Information Section
            if (_shouldShowField(details.category) ||
                _shouldShowField(details.type) ||
                _shouldShowField(details.subType))
              _buildSectionHeader('मूलभूत माहिती'),
            if (_shouldShowField(details.category))
              _buildDetailRow(Icons.category, 'श्रेणी', details.category),
            if (_shouldShowField(details.type))
              _buildDetailRow(Icons.label_important, 'प्रकार', details.type),
            if (_shouldShowField(details.subType))
              _buildDetailRow(
                  Icons.subdirectory_arrow_right, 'उप प्रकार', details.subType),
            // if (_shouldShowField(details.subcategory))
            //   _buildDetailRow(Icons.person, 'Subcategory', details.subcategory),
            // if (_shouldShowField(details.childSubcategory))
            //   _buildDetailRow(Icons.child_care, 'उपवर्ग', details.childSubcategory),
            if (_shouldShowField(details.name))
              _buildDetailRow(Icons.assignment, 'नाव', details.name!),

            // Pricing and Measurements
            if (_shouldShowField(details.price) ||
                _shouldShowField(details.weight))
              _buildSectionHeader('किंमत आणि मोजमाप'),
            if (_shouldShowField(details.price))
              _buildDetailRow(
                  Icons.currency_rupee, 'किंमत', '₹${details.price}'),
            if (_shouldShowField(details.weight))
              _buildDetailRow(Icons.line_weight, 'वजन',
                  '${details.weight} ${details.unit}'),

            // Animal Specific Details
            if (_shouldShowField(details.age) ||
                _shouldShowField(details.vet) ||
                _shouldShowField(details.milk) ||
                _shouldShowField(details.isGhabhan) ||
                _shouldShowField(details.ghabhanMonth))
              _buildSectionHeader('प्राण्यांचे तपशील'),
            if (_shouldShowField(details.age))
              _buildDetailRow(Icons.cake, 'वय', details.age!),
            if (_shouldShowField(details.vet))
              _buildDetailRow(Icons.medical_services, 'वेत', details.vet!),
            if (_shouldShowField(details.milk))
              _buildDetailRow(Icons.local_drink, 'दूध', details.milk!),
            if (_shouldShowField(details.isGhabhan))
              _buildDetailRow(
                  Icons.pregnant_woman, 'गभन आहे', details.isGhabhan!),
            if (_shouldShowField(details.ghabhanMonth))
              _buildDetailRow(
                  Icons.calendar_today, 'गाभन महिना', details.ghabhanMonth!),

            // Usage and Shop Information
            if (_shouldShowField(details.useYear) ||
                _shouldShowField(details.shopName) ||
                _shouldShowField(details.address))
              _buildSectionHeader('अतिरिक्त माहिती'),
            if (_shouldShowField(details.useYear))
              _buildDetailRow(
                  Icons.calendar_view_month, 'वर्ष वापर', details.useYear!),
            if (_shouldShowField(details.shopName))
              _buildDetailRow(Icons.store, 'दुकानाचे नाव', details.shopName!),
            if (_shouldShowField(details.address))
              _buildDetailRow(Icons.location_on, 'पत्ता', details.address!),
            if (_shouldShowField(details.mobile))
              _buildDetailRow(Icons.phone, 'मोबाईल', details.mobile),

            // Status and Metadata
            if (_shouldShowField(details.status) ||
                _shouldShowField(details.isDeleted) ||
                _shouldShowField(details.createdAt))
              _buildSectionHeader('पोस्ट दिनांक'),
            // if (_shouldShowField(details.status))
            //   _buildDetailRow(Icons.info, 'Status', details.status),
            // if (_shouldShowField(details.isDeleted))
            //   _buildDetailRow(Icons.delete, 'Is Deleted', details.isDeleted == '1' ? 'Yes' : 'No'),
            if (_shouldShowField(details.createdAt))
              _buildDetailRow(Icons.date_range, 'तारीख', details.createdAt),

            // Call button (only shown if mobile number is available)
            if (_shouldShowField(details.mobile))
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text('Call Now',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
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
    if (!_shouldShowField(imageUrl)) {
      return Container(
        width: double.infinity,
        height: 250,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    }

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
          fit: BoxFit.fill,
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

  Widget _buildImageCarousel(List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      return Container(
        width: double.infinity,
        height: 250,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    }

    final PageController controller = PageController(viewportFraction: 0.9);

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: controller,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = imageUrls[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
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
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: controller,
          count: imageUrls.length,
          effect: WormEffect(
            dotColor: Colors.grey.shade400,
            activeDotColor: Colors.green,
            dotHeight: 10,
            dotWidth: 10,
          ),
        ),
      ],
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
                style: const TextStyle(fontSize: 16, color: Colors.black),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
    );
  }
}
class CalculationData {
  final String status;
  final String message;
  final CalculationDetails details;

  CalculationData({
    required this.status,
    required this.message,
    required this.details,
  });

  factory CalculationData.fromJson(Map<String, dynamic> json) {
    return CalculationData(
      status: json['status'],
      message: json['message'],
      details: CalculationDetails.fromJson(json['details']),
    );
  }
}

class CalculationDetails {
  final String id;
  final String userId;
  final String catId;
  final String subcategory;
  final String childSubcategory;
  final String? age;
  final String? vet;
  final String? milk;
  final String? isGhabhan;
  final String? ghabhanMonth;
  final String weight;
  final String unit;
  final String? name;
  final String price;
  final String? useYear;
  final String? shopName;
  final List<String> photo;
  final String description;
  final String? address; // Made nullable
  final String status;
  final String isDeleted;
  final String createdAt;
  final String mobile;
  final String category;
  final String type;
  final String subType;

  CalculationDetails({
    required this.id,
    required this.userId,
    required this.catId,
    required this.subcategory,
    required this.childSubcategory,
    this.age,
    this.vet,
    this.milk,
    this.isGhabhan,
    this.ghabhanMonth,
    required this.weight,
    required this.unit,
    this.name,
    required this.price,
    this.useYear,
    this.shopName,
    required this.photo,
    required this.description,
    this.address, // Made nullable
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.mobile,
    required this.category,
    required this.type,
    required this.subType,
  });

  factory CalculationDetails.fromJson(Map<String, dynamic> json) {
    return CalculationDetails(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      catId: json['cat_id']?.toString() ?? '',
      subcategory: json['subcategory']?.toString() ?? '',
      childSubcategory: json['child_subcategory']?.toString() ?? '',
      age: json['age']?.toString(),
      vet: json['vet']?.toString(),
      milk: json['milk']?.toString(),
      isGhabhan: json['is_ghabhan']?.toString(),
      ghabhanMonth: json['ghabhan_month']?.toString(),
      weight: json['weight']?.toString() ?? '0',
      unit: json['unit']?.toString() ?? '',
      name: json['name']?.toString(),
      price: json['price']?.toString() ?? '0',
      useYear: json['use_year']?.toString(),
      shopName: json['shop_name']?.toString(),
      photo: List<String>.from(json['photo'] ?? []),
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString(), // Can be null
      status: json['status']?.toString() ?? '',
      isDeleted: json['isdeleted']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      category: json['कॅटेगरी']?.toString() ?? '',
      type: json['प्रकार']?.toString() ?? '',
      subType: json['उप-प्रकार']?.toString() ?? '',
    );
  }
}
