import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../ApiService/api_service.dart';
import '../../../home/presentation/screen/HomeScreen.dart';

// class MyPostScreen extends StatefulWidget {
//   const MyPostScreen({super.key});
//
//   @override
//   State<MyPostScreen> createState() => _MyPostScreenState();
// }
//
// class _MyPostScreenState extends State<MyPostScreen> {
//   List<PostDetail> posts = [];
//   bool isLoading = true;
//   String errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserPosts();
//   }
//
//   Future<void> fetchUserPosts() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString('user_id') ?? '0';
//
//       final url = Uri.parse('https://sks.sitsolutions.co.in/view_user_post');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'user_id': userId}),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final postResponse = PostListResponse.fromJson(jsonResponse);
//
//         if (postResponse.status == 'success') {
//           setState(() {
//             posts = postResponse.details;
//             isLoading = false;
//             errorMessage = '';
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//             errorMessage = postResponse.message;
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Server error: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error: ${e.toString()}';
//       });
//     }
//   }
//
//
//   void _confirmDelete(String postId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Post'),
//         content: const Text('Are you sure you want to delete this post?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deletePost(postId.toString());
//             // because the API expects a stringified post ID
//
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _deletePost(String postId) async {
//     setState(() => isLoading = true); // Optional: Show loading
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://sks.sitsolutions.co.in/delete_post'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'post_id': postId}),
//       );
//
//       if (response.statusCode == 200) {
//         final result = json.decode(response.body);
//         final deleteResponse = DeletePostResponse.fromJson(result);
//
//         if (deleteResponse.status == 'success') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(deleteResponse.message)),
//           );
//           fetchUserPosts(); // Refresh list
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(deleteResponse.message)),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Server Error: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => isLoading = false); // Hide loading
//     }
//   }
//
//   Widget _buildPostDetails(PostDetail post) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           post.name?.isNotEmpty == true
//               ? post.name!
//               : (post.description?.isNotEmpty == true ? post.description! : 'Untitled Post'),
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         if (post.categoryName != null) Text('कॅटेगरी: ${post.categoryName}'),
//         if (post.subcategoryName != null) Text('प्रकार: ${post.subcategoryName}'),
//         if (post.childSubcategory != null) Text('उपप्रकार: ${post.childSubcategory}'),
//         if (post.weight != null && post.unit != null) Text('वजन: ${post.weight} ${post.unit}'),
//         if (post.age != null) Text('वय: ${post.age}'),
//         if (post.milk != null) Text('दूध: ${post.milk} लिटर'),
//         if (post.price != null) Text('किंमत: ₹${post.price}'),
//         if (post.useYear != null) Text('वापर: ${post.useYear} वर्षे'),
//         if (post.shopName != null) Text('दुकान: ${post.shopName}'),
//         if (post.address != null) Text('स्थान: ${post.address}'),
//         if (post.isGhabhan == "होय") Text('गाभण: होय (${post.ghabhanMonth ?? ''} महिने)'),
//         if (post.vet != null) Text('पशुवैद्यकीय माहिती: ${post.vet}'),
//       ],
//     );
//   }
//
//   Widget _buildPostFooter(PostDetail post) {
//     return Row(
//       children: [
//         const Icon(Icons.calendar_today, size: 16),
//         const SizedBox(width: 4),
//         Text(post.createdAt.split(' ').first.replaceAll('-', '/')),
//         const Spacer(),
//         Chip(
//           backgroundColor: post.status == "1" ? Colors.green[50] : Colors.red[50],
//           label: Text(
//             post.status == "1" ? 'सक्रिय' : 'निष्क्रिय',
//             style: TextStyle(
//               color: post.status == "1" ? Colors.green : Colors.red,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'माझ्या पोस्ट',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
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
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//           ? Center(child: Text(errorMessage))
//           : posts.isEmpty
//           ? const Center(child: Text('कोणत्याही पोस्ट आढळल्या नाहीत'))
//           : ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: posts.length,
//         itemBuilder: (context, index) {
//           final post = posts[index];
//           return Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Row(
//                   //   children: [
//                   //     Text(
//                   //       'पोस्ट ${index + 1}',
//                   //       style: const TextStyle(fontWeight: FontWeight.bold),
//                   //     ),
//                   //     const Spacer(),
//                   //     IconButton(
//                   //       icon: const Icon(Icons.more_vert),
//                   //       onPressed: () => _showPostOptions(post),
//                   //     ),
//                   //   ],
//                   // ),
//
//                   Row(
//                     children: [
//                       Text(
//                         'पोस्ट ${index + 1}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const Spacer(),
//                       // PopupMenuButton<PostMenuAction>(
//                       //   icon: const Icon(Icons.more_vert),
//                       //   onSelected: (action) {
//                       //     if (action == PostMenuAction.edit) {
//                       //       // TODO: Navigate to edit screen
//                       //     } else if (action == PostMenuAction.delete) {
//                       //       _confirmDelete(post.id);
//                       //     }
//                       //   },
//                       //   itemBuilder: (context) => [
//                       //     const PopupMenuItem<PostMenuAction>(
//                       //       value: PostMenuAction.edit,
//                       //       child: Text('Edit Post'),
//                       //     ),
//                       //     const PopupMenuItem<PostMenuAction>(
//                       //       value: PostMenuAction.delete,
//                       //       child: Text('Delete Post', style: TextStyle(color: Colors.red)),
//                       //     ),
//                       //   ],
//                       // ),
//                       PopupMenuButton<PostMenuAction>(
//                         icon: const Icon(Icons.more_vert),
//                         onSelected: (action) async {
//                           if (action == PostMenuAction.edit) {
//                             final result = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => EditPostScreen(post: posts[index]),
//                               ),
//                             );
//
//                             if (result == true) {
//                               // Refresh the posts if the edit was successful
//                               fetchUserPosts();
//                             }
//                           } else if (action == PostMenuAction.delete) {
//                             _confirmDelete(post.id);
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           const PopupMenuItem<PostMenuAction>(
//                             value: PostMenuAction.edit,
//                             child: Text('Edit Post'),
//                           ),
//                           const PopupMenuItem<PostMenuAction>(
//                             value: PostMenuAction.delete,
//                             child: Text('Delete Post', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (post.photo != null)
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             post.photo!,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => Container(
//                               width: 100,
//                               height: 100,
//                               color: Colors.grey[200],
//                               child: const Icon(Icons.broken_image),
//                             ),
//                           ),
//                         ),
//                       const SizedBox(width: 12),
//                       Expanded(child: _buildPostDetails(post)),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   _buildPostFooter(post),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'MyPostDetailScreen.dart';


class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  List<PostDetail> posts = [];
  bool isLoading = true;
  String errorMessage = '';
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }

  Future<void> fetchUserPosts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '0';

      final response = await http.post(
        ApiService.viewUserPostUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final postResponse = PostListResponse.fromJson(jsonResponse);

        if (postResponse.status == 'success') {
          setState(() {
            // posts = postResponse.details;
            posts = postResponse.details.reversed.toList(); // 🔁 Reverse the list
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = postResponse.message;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> markPostAsSoldOut(String postId) async {
    try {
      setState(() => isLoading = true);

      final response = await http.post(
        ApiService.soldOutPostUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'post_id': postId}),
      );

      print('Response Body: ${response.body}'); // 🔍 Print raw response

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final soldOutResponse = SoldOutResponse.fromJson(result);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(soldOutResponse.message)),
        // );
        Fluttertoast.showToast(
          msg: soldOutResponse.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (soldOutResponse.status == 'success') {
          await fetchUserPosts();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _confirmDelete(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePost(postId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePost(String postId) async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        ApiService.deletePostUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'post_id': postId}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final deleteResponse = DeletePostResponse.fromJson(result);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(deleteResponse.message)),
        );

        if (deleteResponse.status == 'success') {
          await fetchUserPosts();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  Widget _buildPostDetails(PostDetail post) {
    TextStyle labelStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 18
    );
    TextStyle valueStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    Widget infoRow(String label, String? value) {
      if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const Text(
              ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.name?.isNotEmpty == true || post.description?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              post.name?.isNotEmpty == true
                  ? post.name!
                  : post.description ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        infoRow('कॅटेगरी', post.categoryName),
        infoRow('सबकॅटेगरी', post.typeMarathi),
        infoRow('प्रकार', post.subcategoryName),
        infoRow('वजन', (post.weight != null && post.unit != null) ? '${post.weight} ${post.unit}' : null),
        infoRow('वय', post.age),
        infoRow('दूध', post.milk != null ? '${post.milk} लिटर' : null),
        infoRow('किंमत', post.price != null ? '₹${post.price}' : null),
        infoRow('वापराचा कालावधी', post.useYear != null ? '${post.useYear} वर्षे' : null),
        infoRow('दुकान', post.shopName),
        infoRow('ठिकाण', post.address),
        if (post.isGhabhan == "Yes")
          infoRow('गाभण', post.ghabhanMonth != null ? 'होय (${post.ghabhanMonth} महिने)' : 'होय'),
      ],
    );
  }

  /*Widget _buildPostDetails(PostDetail post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.name?.isNotEmpty == true
              ? post.name!
              : (post.description?.isNotEmpty == true
                  ? post.description!
                  : ''),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (post.categoryName != null && post.categoryName!.trim().isNotEmpty)
          Text('कॅटेगरी: ${post.categoryName}'),
        if (post.typeMarathi != null && post.typeMarathi!.trim().isNotEmpty)
          Text('सबकॅटेगरी : ${post.typeMarathi}'),

        if (post.subcategoryName != null && post.subcategoryName!.trim().isNotEmpty)
          Text('प्रकार: ${post.subcategoryName}'),




        if (post.weight != null && post.unit != null)
          Text('वजन: ${post.weight} ${post.unit}'),
        if (post.age != null)
          Text('वय: ${post.age}'),
        if (post.milk != null)
          Text('दूध: ${post.milk} लिटर'),
        if (post.price != null)
          Text('किंमत: ₹${post.price}'),
        if (post.useYear != null)
          Text('वापराचा कालावधी: ${post.useYear} वर्षे'),
        if (post.shopName != null)
          Text('दुकान: ${post.shopName}'),
        if (post.address != null)
          Text('ठिकाण: ${post.address}'),
        if (post.isGhabhan == "Yes")
          Text('गाभण: होय (${post.ghabhanMonth ?? ''} महिने)'),
        // if (post.vet != null)
        //   Text('पशुवैद्यकीय माहिती: ${post.vet}'),

        *//*if (post.categoryName != null) Text('Category: ${post.categoryName}'),
        if (post.subcategoryName != null) Text('Type: ${post.subcategoryName}'),
        if (post.childSubcategory != null && !RegExp(r'^\d+$').hasMatch(post.childSubcategory!))
          Text('Subtype: ${post.childSubcategory}'),
        if (post.weight != null && post.unit != null)
          Text('Weight: ${post.weight} ${post.unit}'),
        if (post.age != null) Text('Age: ${post.age}'),
        if (post.milk != null) Text('Milk: ${post.milk} liters'),
        if (post.price != null) Text('Price: ₹${post.price}'),
        if (post.useYear != null) Text('Usage: ${post.useYear} years'),
        if (post.shopName != null) Text('Shop: ${post.shopName}'),
        if (post.address != null) Text('Location: ${post.address}'),
        if (post.isGhabhan == "Yes")
          Text('Pregnant: Yes (${post.ghabhanMonth ?? ''} months)'),
        if (post.vet != null) Text('Veterinary Info: ${post.vet}'),*//*
      ],
    );
  }
*/
  Widget _buildPostFooter(PostDetail post) {
    return Row(
      children: [
        Text('Views:'),
        const Icon(Icons.remove_red_eye, size: 20, color: Colors.grey),
        const SizedBox(width: 4),
        Text(post.views,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const Spacer(),
        post.status == "1"
            ? TextButton(
                onPressed: () => markPostAsSoldOut(post.id),
                style: TextButton.styleFrom(backgroundColor: Colors.orange[50]),
                child: const Text(
                  'Sold Out',
                  style: TextStyle(color: Colors.orange),
                ),
              )
            : Chip(
                backgroundColor: Colors.grey[300],
                label: const Text('Sold Out',
                    style: TextStyle(color: Colors.grey)),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('माझी पोस्ट्स',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              );
            },
          ),
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
        // body: RefreshIndicator(
        //   backgroundColor: Colors.white,
        //   color: Colors.green,
        //   onRefresh: fetchUserPosts,
        //   child: isLoading
        //       ? const Center(
        //           child: CircularProgressIndicator(
        //           color: Colors.green,
        //         ))
        //       : errorMessage.isNotEmpty
        //           ? Center(child: Text('पोस्ट उपलब्ध नाहीत',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),))
        //           : posts.isEmpty
        //               ? const Center(child: Text('पोस्ट उपलब्ध नाहीत',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),))
        //               : ListView.builder(
        //                   physics: const AlwaysScrollableScrollPhysics(),
        //                   padding: const EdgeInsets.all(12),
        //                   itemCount: posts.length,
        //                   itemBuilder: (context, index) {
        //                     final post = posts[index];
        //                     return GestureDetector(
        //                       onTap: () {
        //                         Navigator.push(
        //                           context,
        //                           MaterialPageRoute(
        //                             builder: (_) => MyPostDetailScreen(post: post),
        //                           ),
        //                         );
        //                       },
        //                       child: Card(
        //                         color: Colors.white,
        //                         margin: const EdgeInsets.only(bottom: 16),
        //                         elevation: 2,
        //                         shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(12),
        //                         ),
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(12),
        //                           child: Column(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             children: [
        //                               Row(
        //                                 children: [
        //                                   Text('Post ${index + 1}',
        //                                       style: const TextStyle(
        //                                           fontWeight: FontWeight.bold)),
        //                                   const Spacer(),
        //                                   const Icon(Icons.calendar_today,
        //                                       size: 16),
        //                                   const SizedBox(width: 4),
        //                                   Text(post.createdAt
        //                                       .split(' ')
        //                                       .first
        //                                       .replaceAll('-', '/')),
        //                                 ],
        //                               ),
        //                               const SizedBox(height: 8),
        //
        //                               Column(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.center,
        //                                 children: [
        //
        //                                   Column(
        //                                     children: [
        //                                       ClipRRect(
        //                                         borderRadius: BorderRadius.circular(8),
        //                                         child: post.photo != null && post.photo!.isNotEmpty
        //                                             ? SizedBox(
        //                                           height: 200, // Set consistent height
        //                                           width: double.infinity,
        //                                           child: CarouselSlider(
        //                                             options: CarouselOptions(
        //                                               height: 200, // Must match SizedBox height
        //                                               viewportFraction: 1.0,
        //                                               enableInfiniteScroll: false,
        //                                               enlargeCenterPage: false,
        //                                               onPageChanged: (index, reason) {
        //                                                 setState(() {
        //                                                   _currentImageIndex = index;
        //                                                 });
        //                                               },
        //                                             ),
        //                                             items: post.photo!.map((url) {
        //                                               return Container(
        //                                                 width: double.infinity,
        //                                                 height: 200,
        //                                                 child: ClipRRect(
        //                                                   borderRadius: BorderRadius.circular(8),
        //                                                   child: Image.network(
        //                                                     url,
        //                                                     fit: BoxFit.fill, // ✅ Best fit for carousels
        //                                                     width: double.infinity,
        //                                                     height: double.infinity,
        //                                                     loadingBuilder: (context, child, loadingProgress) {
        //                                                       if (loadingProgress == null) return child;
        //                                                       return Container(
        //                                                         color: Colors.grey[200],
        //                                                         child: const Center(child: CircularProgressIndicator()),
        //                                                       );
        //                                                     },
        //                                                     errorBuilder: (_, __, ___) => Container(
        //                                                       color: Colors.grey[200],
        //                                                       child: const Icon(Icons.broken_image, size: 40),
        //                                                     ),
        //                                                   ),
        //                                                 ),
        //                                               );
        //                                             }).toList(),
        //                                           ),
        //                                         )
        //                                             : Container(
        //                                           height: 200,
        //                                           width: double.infinity,
        //                                           color: Colors.grey[200],
        //                                           child: const Center(
        //                                             child: Icon(Icons.image, size: 50),
        //                                           ),
        //                                         ),
        //                                       ),
        //
        //                                       if (post.photo != null && post.photo!.length > 1)
        //                                         Padding(
        //                                           padding: const EdgeInsets.only(top: 8),
        //                                           child: AnimatedSmoothIndicator(
        //                                             activeIndex: _currentImageIndex,
        //                                             count: post.photo!.length,
        //                                             effect: ExpandingDotsEffect(
        //                                               activeDotColor: Colors.green,
        //                                               dotColor: Colors.grey.shade300,
        //                                               dotHeight: 8,
        //                                               dotWidth: 10,
        //                                             ),
        //                                           ),
        //                                         ),
        //                                     ],
        //                                   ),
        //
        //
        //                                   const SizedBox(width: 12),
        //                                   _buildPostDetails(post),
        //                                 ],
        //                               ),
        //
        //                               const SizedBox(height: 12),
        //                               _buildPostFooter(post),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                 ),
        // ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.green,
          onRefresh: fetchUserPosts,
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          )
              : errorMessage.isNotEmpty
              ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, // Adjust as needed
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.info_outline, // You can use Icons.remove_shopping_cart_outlined if preferred
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'पोस्ट उपलब्ध नाहीत',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ],
          )
              : posts.isEmpty
              ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 200),
              Center(
                child: Text(
                  'पोस्ट उपलब्ध नाहीत',
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyPostDetailScreen(post: post),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Post ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4),
                            Text(post.createdAt
                                .split(' ')
                                .first
                                .replaceAll('-', '/')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: post.photo != null &&
                                  post.photo!.isNotEmpty
                                  ? SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 200,
                                    viewportFraction: 1.0,
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: false,
                                    onPageChanged:
                                        (index, reason) {
                                      setState(() {
                                        _currentImageIndex = index;
                                      });
                                    },
                                  ),
                                  items: post.photo!.map((url) {
                                    return Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(
                                            8),
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: double.infinity,
                                          loadingBuilder: (context,
                                              child,
                                              loadingProgress) {
                                            if (loadingProgress ==
                                                null) return child;
                                            return Container(
                                              color:
                                              Colors.grey[200],
                                              child: const Center(
                                                  child:
                                                  CircularProgressIndicator()),
                                            );
                                          },
                                          errorBuilder: (_, __,
                                              ___) =>
                                              Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                    Icons.broken_image,
                                                    size: 40),
                                              ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                                  : Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.image,
                                      size: 50),
                                ),
                              ),
                            ),
                            if (post.photo != null &&
                                post.photo!.length > 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: AnimatedSmoothIndicator(
                                  activeIndex: _currentImageIndex,
                                  count: post.photo!.length,
                                  effect: ExpandingDotsEffect(
                                    activeDotColor: Colors.green,
                                    dotColor: Colors.grey.shade300,
                                    dotHeight: 8,
                                    dotWidth: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        _buildPostDetails(post),
                        const SizedBox(height: 12),
                        _buildPostFooter(post),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

      ),
    );
  }
}



class SoldOutResponse {
  final String status;
  final String message;
  final SoldOutDetails? details;

  SoldOutResponse({
    required this.status,
    required this.message,
    this.details,
  });

  factory SoldOutResponse.fromJson(Map<String, dynamic> json) {
    return SoldOutResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details: json['details'] != null
          ? SoldOutDetails.fromJson(json['details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': details?.toJson(),
    };
  }
}

class SoldOutDetails {
  final int id;

  SoldOutDetails({required this.id});

  factory SoldOutDetails.fromJson(Map<String, dynamic> json) {
    return SoldOutDetails(
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

/*
class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  List<PostDetail> posts = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }

  Future<void> fetchUserPosts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '0';

      final response = await http.post(
          ApiService.viewUserPostUrl,
        // Uri.parse('https://sks.sitsolutions.co.in/view_user_post'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final postResponse = PostListResponse.fromJson(jsonResponse);

        if (postResponse.status == 'success') {
          setState(() {
            posts = postResponse.details;
            isLoading = false;
          });
          debugPrint('✅ Fetched ${posts.length} posts');
        } else {
          setState(() {
            isLoading = false;
            errorMessage = postResponse.message;
          });
          debugPrint('❌ API Error: ${postResponse.message}');
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Server error: ${response.statusCode}';
        });
        debugPrint('❌ Server Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
      debugPrint('❌ Exception: ${e.toString()}');
    }
  }

  void _confirmDelete(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePost(postId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePost(String postId) async {
    setState(() => isLoading = true);
    debugPrint('🗑️ Deleting post $postId');

    try {
      final response = await http.post(
          ApiService.deletePostUrl,
        // Uri.parse('https://sks.sitsolutions.co.in/delete_post'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'post_id': postId}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final deleteResponse = DeletePostResponse.fromJson(result);

        if (deleteResponse.status == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(deleteResponse.message)),
          );
          debugPrint('✅ Post deleted successfully');
          await fetchUserPosts();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(deleteResponse.message)),
          );
          debugPrint('❌ Delete failed: ${deleteResponse.message}');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
        );
        debugPrint('❌ Server Error: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      debugPrint('❌ Exception: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildPostDetails(PostDetail post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.name?.isNotEmpty == true
              ? post.name!
              : (post.description?.isNotEmpty == true ? post.description! : 'Untitled Post'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (post.categoryName != null) Text('Category: ${post.categoryName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.subcategoryName != null) Text('Type: ${post.subcategoryName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.childSubcategory != null) Text('Subtype: ${post.childSubcategory}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.weight != null && post.unit != null) Text('Weight: ${post.weight} ${post.unit}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.age != null) Text('Age: ${post.age}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.milk != null) Text('Milk: ${post.milk} liters', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.price != null) Text('Price: ₹${post.price}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.useYear != null) Text('Usage: ${post.useYear} years', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.shopName != null) Text('Shop: ${post.shopName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.address != null) Text('Location: ${post.address}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.isGhabhan == "Yes") Text('Pregnant: Yes (${post.ghabhanMonth ?? ''} months)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
        if (post.vet != null) Text('Veterinary Info: ${post.vet}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),

      ],
    );
  }

  Widget _buildPostFooter(PostDetail post) {
    return Row(
      children: [
        // const Icon(Icons.calendar_today, size: 16),
        // const SizedBox(width: 4),
        // Text(post.createdAt.split(' ').first.replaceAll('-', '/')),
        // const Spacer(),
        Text('Views:'),
        const Icon(Icons.remove_red_eye, size: 20, color: Colors.grey),
        const SizedBox(width: 4),

        Text(
          post.views,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const Spacer(),
        Chip(
          backgroundColor: post.status == "1" ? Colors.green[50] : Colors.red[50],
          label: Text(
            post.status == "1" ? 'Active' : 'Inactive',
            style: TextStyle(
              color: post.status == "1" ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
              (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'My Posts',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false,
              );
            },
          ),
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
        body: RefreshIndicator(
          onRefresh: fetchUserPosts,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : posts.isEmpty
              ? const Center(child: Text('No posts found'))
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                color: Colors.green.shade50,
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Post ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 4),
                          Text(post.createdAt.split(' ').first.replaceAll('-', '/')),
                          // PopupMenuButton<PostMenuAction>(
                          //   icon: const Icon(Icons.more_vert),
                          //   onSelected: (action) async {
                          //     if (action == PostMenuAction.edit) {
                          //       debugPrint('✏️ Editing post ${post.id}');
                          //       final updatedPost = await Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (_) => EditPostScreen(post: post),
                          //         ),
                          //       );
                          //
                          //       if (updatedPost != null && updatedPost is PostDetail) {
                          //         debugPrint('🔄 Received updated post:');
                          //         debugPrint('   ID: ${updatedPost.id}');
                          //         debugPrint('   Name: ${updatedPost.name}');
                          //         debugPrint('   Price: ${updatedPost.price}');
                          //
                          //         setState(() {
                          //           posts[index] = updatedPost;
                          //         });
                          //         ScaffoldMessenger.of(context).showSnackBar(
                          //           const SnackBar(content: Text('Post updated successfully')),
                          //         );
                          //       }
                          //     } else if (action == PostMenuAction.delete) {
                          //       _confirmDelete(post.id);
                          //     }
                          //   },
                          //   itemBuilder: (context) => [
                          //     const PopupMenuItem<PostMenuAction>(
                          //       value: PostMenuAction.edit,
                          //       child: Text('Edit Post'),
                          //     ),
                          //     const PopupMenuItem<PostMenuAction>(
                          //       value: PostMenuAction.delete,
                          //       child: Text('Delete Post', style: TextStyle(color: Colors.red)),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.photo != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                post.photo!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(child: _buildPostDetails(post)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildPostFooter(post),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
*/

enum PostMenuAction { edit, delete }

// MODEL CLASSES

// models/post_list_response.dart
class PostListResponse {
  final String status;
  final String message;
  final List<PostDetail> details;

  PostListResponse({
    required this.status,
    required this.message,
    required this.details,
  });
  factory PostListResponse.fromJson(Map<String, dynamic> json) {
    return PostListResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details: json['details'] != null
          ? (json['details'] as List<dynamic>)
              .map((item) => PostDetail.fromJson(item))
              .toList()
          : [], // Return empty list if details is null
    );
  }

}

class PostDetail {
  // ────────── ids ──────────
  final String id;
  final String userId;
  final String catId;
  final String subcategory;
  final String? childSubcategory;

  // ────────── attributes ───
  final String? age;
  final String? vet;
  final String? milk;
  final String? isGhabhan;
  final String? ghabhanMonth;
  final String? weight;
  final String? unit;
  final String? name;
  final String? price;
  final String? useYear;
  final String? shopName;
  final List<String> photo; // Changed from String? photo
  final String? description;
  final String? address;
  final String mobile;

  // ────────── meta ─────────
  final String status;
  final String views;
  final String isDeleted;
  final String createdAt;

  // Optional Marathi keys
  final String? typeMarathi;
  final String? categoryName; // "कॅटेगरी"
  final String? subcategoryName; // "प्रकार"

  PostDetail({
    required this.id,
    required this.userId,
    required this.catId,
    required this.subcategory,
    this.childSubcategory,
    this.age,
    this.vet,
    this.milk,
    this.isGhabhan,
    this.ghabhanMonth,
    this.weight,
    this.unit,
    this.name,
    this.price,
    this.useYear,
    this.shopName,
    required this.photo,
    this.description,
    this.address,
    required this.mobile,
    required this.status,
    required this.views,
    required this.isDeleted,
    required this.createdAt,
    this.typeMarathi,
    this.categoryName,
    this.subcategoryName,
  });
  factory PostDetail.fromJson(Map<String, dynamic> j) {
    var baseUrl = ApiService.post.toString();
        // 'https://sks.sitsolutions.co.in/public/Backend-Assets/images/Post/';
    List<String> photos = [];

    if (j['photo'] != null && j['photo'].toString().isNotEmpty) {
      photos = j['photo']
          .toString()
          .split(',')
          .map((e) => e.trim().startsWith('http') ? e.trim() : baseUrl + e.trim())
          .toList();
    }

    return PostDetail(
      id: j['id'] ?? '',
      userId: j['user_id'] ?? '',
      catId: j['cat_id'] ?? '',
      subcategory: j['subcategory'] ?? '',
      childSubcategory: j['child_subcategory'],
      age: j['age'],
      vet: j['vet'],
      milk: j['milk'],
      isGhabhan: j['is_ghabhan'],
      ghabhanMonth: j['ghabhan_month'],
      weight: j['weight'],
      unit: j['unit'],
      name: j['name'],
      price: j['price'],
      useYear: j['use_year'],
      shopName: j['shop_name'],
      photo: photos,
      description: j['description'],
      address: j['address'],
      mobile: j['mobile'],
      status: j['status'] ?? '0',
      views: j['views'] ?? '0',
      isDeleted: j['isdeleted'] ?? '0',
      createdAt: j['created_at'] ?? '',
      typeMarathi: j['प्रकार'],
      categoryName: j['कॅटेगरी'],
      subcategoryName: j['उप-प्रकार'],
    );
  }


  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'cat_id': catId,
        'subcategory': subcategory,
        'child_subcategory': childSubcategory,
        'age': age,
        'vet': vet,
        'milk': milk,
        'is_ghabhan': isGhabhan,
        'ghabhan_month': ghabhanMonth,
        'weight': weight,
        'unit': unit,
        'name': name,
        'price': price,
        'use_year': useYear,
        'shop_name': shopName,
         'photo': photo,
        'description': description,
        'address': address,
        'mobile': mobile,
        'status': status,
        'views': views,
        'isdeleted': isDeleted,
        'created_at': createdAt,
        'प्रकार': typeMarathi,
        'कॅटेगरी': categoryName,
        'उप-प्रकार': subcategoryName,
      };
}

class DeletePostResponse {
  final String status;
  final String message;
  final DeletePostDetails details;

  DeletePostResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) {
    return DeletePostResponse(
      status: json['status'],
      message: json['message'],
      details: DeletePostDetails.fromJson(json['details']),
    );
  }
}

class DeletePostDetails {
  final int id;

  DeletePostDetails({required this.id});

  factory DeletePostDetails.fromJson(Map<String, dynamic> json) {
    return DeletePostDetails(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
    );
  }
}

class EditPostScreen extends StatefulWidget {
  final PostDetail post;

  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  // ───────────────────────────────── controllers
  late final _nameC = TextEditingController(text: widget.post.name ?? '');
  late final _descC =
      TextEditingController(text: widget.post.description ?? '');
  late final _ageC = TextEditingController(text: widget.post.age ?? '');
  late final _vetC = TextEditingController(text: widget.post.vet ?? '');
  late final _milkC = TextEditingController(text: widget.post.milk ?? '');
  late final _weightC = TextEditingController(text: widget.post.weight ?? '');
  late final _priceC = TextEditingController(text: widget.post.price ?? '');
  late final _useYearC = TextEditingController(text: widget.post.useYear ?? '');
  late final _shopNameC =
      TextEditingController(text: widget.post.shopName ?? '');
  late final _addressC = TextEditingController(text: widget.post.address ?? '');
  late final _ghabhanC =
      TextEditingController(text: widget.post.ghabhanMonth ?? '');

  // ───────────────────────────────── pickers
  final _ghabhanChoices = ['होय', 'नाही'];
  List<String> _units = [];
  String? _selectedUnit;
  String? _isGhabhan;

  bool _loadingUnits = true;
  bool _saving = false;

  // ───────────────────────────────── life-cycle
  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.post.unit;
    _isGhabhan = widget.post.isGhabhan;
    _loadUnits();
  }

  @override
  void dispose() {
    for (final c in [
      _nameC,
      _descC,
      _ageC,
      _vetC,
      _milkC,
      _weightC,
      _priceC,
      _useYearC,
      _shopNameC,
      _addressC,
      _ghabhanC
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ───────────────────────────────── helpers
  Future<void> _loadUnits() async {
    try {
      final catId = widget.post.catId ?? '';
      if (catId.isEmpty) throw Exception('cat_id missing');

      final response = await http.post(
        ApiService.unitListUrl,
        // Uri.parse('https://sks.sitsolutions.co.in/unit_list'),
        headers: {'Content-Type': 'application/json'}, // ← JSON!
        body: jsonEncode({'cat_id': catId}), // ← only cat_id
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] == 'success') {
        _units =
            (data['details'] as List).map((e) => e['unit'].toString()).toList();
      } else {
        throw Exception(data['message'] ?? 'Unknown error');
      }
    } catch (e) {
      _units = ['Guntha', 'Shekada', 'kg', 'liter']; // fallback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Using default units: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingUnits = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final sp = await SharedPreferences.getInstance();
      final userId = sp.getString('user_id') ?? '';
      if (userId.isEmpty) throw Exception('User id not found.');

      final req = http.MultipartRequest(
        'POST',
        ApiService.updatePostUrl,
        // Uri.parse('https://sks.sitsolutions.co.in/update_post'),
      );

      // REQUIRED fields
      req.fields
        ..['id'] = widget.post.id
        ..['user_id'] = userId
        ..['cat_id'] = widget.post.catId
        ..['subcategory'] = widget.post.subcategory
        ..['address'] = _addressC.text;

      // Optional fields - only add if they exist in the original post
      if (widget.post.name != null) req.fields['name'] = _nameC.text;
      if (widget.post.description != null)
        req.fields['description'] = _descC.text;
      if (widget.post.age != null) req.fields['age'] = _ageC.text;
      if (widget.post.vet != null) req.fields['vet'] = _vetC.text;
      if (widget.post.milk != null) req.fields['milk'] = _milkC.text;
      if (widget.post.weight != null) req.fields['weight'] = _weightC.text;
      if (_selectedUnit != null) req.fields['unit'] = _selectedUnit!;
      if (widget.post.price != null) req.fields['price'] = _priceC.text;
      if (widget.post.useYear != null) req.fields['use_year'] = _useYearC.text;
      if (widget.post.shopName != null)
        req.fields['shop_name'] = _shopNameC.text;
      if (_isGhabhan != null) req.fields['is_ghabhan'] = _isGhabhan!;
      if (widget.post.ghabhanMonth != null)
        req.fields['ghabhan_month'] = _ghabhanC.text;

      debugPrint('➡️ Sending request with fields:');
      req.fields.forEach((key, value) {
        debugPrint('   $key: "$value"');
      });

      final res = await req.send();
      final body = await res.stream.bytesToString();
      final decoded = json.decode(body);

      debugPrint('🔄 Response: $decoded');

      if (res.statusCode == 200 && decoded['status'] == 'success') {
        // Create updated post object with both original and new values
        final updatedPost = PostDetail(
          id: widget.post.id,
          userId: userId,
          catId: widget.post.catId,
          subcategory: widget.post.subcategory,
          childSubcategory: widget.post.childSubcategory,
          age: _ageC.text.isNotEmpty ? _ageC.text : null,
          vet: _vetC.text.isNotEmpty ? _vetC.text : null,
          milk: _milkC.text.isNotEmpty ? _milkC.text : null,
          isGhabhan: _isGhabhan,
          ghabhanMonth: _ghabhanC.text.isNotEmpty ? _ghabhanC.text : null,
          weight: _weightC.text.isNotEmpty ? _weightC.text : null,
          unit: _selectedUnit,
          name: _nameC.text.isNotEmpty ? _nameC.text : null,
          price: _priceC.text.isNotEmpty ? _priceC.text : null,
          useYear: _useYearC.text.isNotEmpty ? _useYearC.text : null,
          shopName: _shopNameC.text.isNotEmpty ? _shopNameC.text : null,
          photo: widget.post.photo,
          description: _descC.text.isNotEmpty ? _descC.text : null,
          address: _addressC.text,
          status: widget.post.status,
          views: widget.post.views,
          isDeleted: widget.post.isDeleted,
          createdAt: widget.post.createdAt,
          categoryName: widget.post.categoryName,
          subcategoryName: widget.post.subcategoryName,
          mobile:widget.post.mobile,
        );

        debugPrint('✅ Updated Post Data:');
        debugPrint('   ID: ${updatedPost.id}');
        debugPrint('   Name: ${updatedPost.name}');
        debugPrint('   Description: ${updatedPost.description}');
        debugPrint('   Price: ${updatedPost.price}');
        debugPrint('   Address: ${updatedPost.address}');
        // Add more fields as needed...

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded['message'] ?? 'Updated successfully')),
        );

        // Return the complete updated post object
        Navigator.pop(context, updatedPost);
      } else {
        throw Exception(decoded['message'] ?? 'Update failed');
      }
    } catch (e) {
      debugPrint('❌ Error updating post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ───────────────────────────────── ui widgets
  Widget _txt(TextEditingController c, String label, {bool number = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: c,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              labelText: label, border: const OutlineInputBorder()),
        ),
      );

  Widget _drop(String? value, List<String> items, String label,
          ValueChanged<String?> onChg) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChg,
          decoration: InputDecoration(
              labelText: label, border: const OutlineInputBorder()),
        ),
      );

  // ───────────────────────────────── build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('पोस्ट संपादित करा',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),

        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.save),
        //     onPressed: _saving ? null : _save,
        //   ),
        // ],
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
      body: _loadingUnits
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (widget.post.photo != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 2, // Border width
                          ),
                        ),
                        child: Image.network(
                          widget.post.photo[0]!,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),

                  // Only show name field if post has name
                  if (widget.post.name != null && widget.post.name!.isNotEmpty)
                    _txt(_nameC, 'नाव'),

                  // Only show description field if post has description
                  if (widget.post.description != null &&
                      widget.post.description!.isNotEmpty)
                    _txt(_descC, 'वर्णन'),

                  // Only show age field if post has age
                  if (widget.post.age != null && widget.post.age!.isNotEmpty)
                    _txt(_ageC, 'वय'),

                  // Only show vet field if post has vet info
                  if (widget.post.vet != null && widget.post.vet!.isNotEmpty)
                    _txt(_vetC, 'व्हेट माहिती'),

                  // Only show milk field if post has milk info
                  if (widget.post.milk != null && widget.post.milk!.isNotEmpty)
                    _txt(_milkC, 'दूध (ली.)', number: true),

                  // Only show weight/unit fields if post has weight
                  if (widget.post.weight != null &&
                      widget.post.weight!.isNotEmpty)
                    Row(
                      children: [
                        Expanded(child: _txt(_weightC, 'वजन', number: true)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _drop(
                            _selectedUnit,
                            _units,
                            'एकक',
                            (v) => setState(() => _selectedUnit = v),
                          ),
                        ),
                      ],
                    ),

                  // Only show price field if post has price
                  if (widget.post.price != null &&
                      widget.post.price!.isNotEmpty)
                    _txt(_priceC, 'किंमत', number: true),

                  // Only show use year field if post has use year
                  if (widget.post.useYear != null &&
                      widget.post.useYear!.isNotEmpty)
                    _txt(_useYearC, 'वापर वर्षे', number: true),

                  // Only show shop name field if post has shop name
                  if (widget.post.shopName != null &&
                      widget.post.shopName!.isNotEmpty)
                    _txt(_shopNameC, 'दुकान नाव'),

                  // Always show address field as it's required
                  _txt(_addressC, 'पत्ता'),

                  // Only show ghabhan fields if post has ghabhan info
                  if (widget.post.isGhabhan != null)
                    _drop(
                      _isGhabhan,
                      _ghabhanChoices,
                      'गाभण?',
                      (v) => setState(() => _isGhabhan = v),
                    ),

                  if (_isGhabhan == 'होय' &&
                      widget.post.ghabhanMonth != null &&
                      widget.post.ghabhanMonth!.isNotEmpty)
                    _txt(_ghabhanC, 'गाभण महिने', number: true),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('सेव्ह करा',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// Minimal response model – keep it simple

class UnitListResponse {
  final String status;
  final String message;
  final List<UnitDetail> details;

  UnitListResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory UnitListResponse.fromJson(Map<String, dynamic> json) {
    return UnitListResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details: (json['details'] as List<dynamic>)
          .map((item) => UnitDetail.fromJson(item))
          .toList(),
    );
  }
}

class UnitDetail {
  final String unit;

  UnitDetail({required this.unit});

  factory UnitDetail.fromJson(Map<String, dynamic> json) {
    return UnitDetail(
      unit: json['unit'] ?? '',
    );
  }
}

class PostUpdateResponse {
  final String status;
  final String message;
  final UpdatedData? updatedData;

  PostUpdateResponse({
    required this.status,
    required this.message,
    this.updatedData,
  });

  factory PostUpdateResponse.fromJson(Map<String, dynamic> json) {
    return PostUpdateResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      updatedData: json['updated_data'] != null
          ? UpdatedData.fromJson(json['updated_data'])
          : null,
    );
  }
}

class UpdatedData {
  final String id; // post id
  final String userId;
  final String catId;
  final String subcategory;
  final String address;
  // add every nullable field you use in the form
  final String? name,
      description,
      age,
      vet,
      milk,
      weight,
      unit,
      price,
      useYear,
      shopName,
      photo,
      isGhabhan,
      ghabhanMonth;

  UpdatedData({
    required this.id,
    required this.userId,
    required this.catId,
    required this.subcategory,
    required this.address,
    this.name,
    this.description,
    this.age,
    this.vet,
    this.milk,
    this.weight,
    this.unit,
    this.price,
    this.useYear,
    this.shopName,
    this.photo,
    this.isGhabhan,
    this.ghabhanMonth,
  });

  factory UpdatedData.fromJson(Map<String, dynamic> j) => UpdatedData(
        id: j['id'].toString(),
        userId: j['user_id'].toString(),
        catId: j['cat_id'].toString(),
        subcategory: j['subcategory'].toString(),
        address: j['address'] ?? '',
        name: j['name'],
        // … repeat for every field …
      );
}
