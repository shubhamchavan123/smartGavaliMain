import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/CategoryScreen.dart';
import 'package:http/http.dart' as http;
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../provider/calcium_mineral_product_provider.dart';
import '../../../login/presentation/screen/MyCartScreen.dart';

// class ChildSubcategoryList extends StatelessWidget {
//   final String subCatId;
//
//   const ChildSubcategoryList({super.key, required this.subCatId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           'उपउपवर्ग',
//           style: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         centerTitle: false,
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
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
//       body: FutureBuilder<List<ChildSubcategoryModel>>(
//         future: ApiService.fetchChildSubcategories(subCatId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           final subcategories = snapshot.data ?? [];
//
//           if (subcategories.isEmpty) {
//             return const Center(child: Text("उपउपवर्ग उपलब्ध नाहीत."));
//           }
//
//           return GridView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: subcategories.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.75,
//             ),
//             itemBuilder: (context, index) {
//               final item = subcategories[index];
//               return Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           item.image,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           errorBuilder: (_, __, ___) => Image.asset(
//                             'assets/images/placeholder.png',
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4),
//                       child: Text(
//                         item.childSubcat,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 15),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

/*
class ChildSubcategoryList extends StatelessWidget {
  final String subCatId;
  final String subcategoryName; // Add this to pass the subcategory name

  const ChildSubcategoryList({
    super.key,
    required this.subCatId,
    required this.subcategoryName, // Require the subcategory name
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          subcategoryName, // Use the passed subcategory name
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
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
      body: FutureBuilder<List<ChildSubcategoryModel>>(
        future: ApiService.fetchChildSubcategories(subCatId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final subcategories = snapshot.data ?? [];

          // If no child subcategories are available, automatically show posts
          if (subcategories.isEmpty) {
            // Use a post-frame callback to navigate after build completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChildSubcategoryPosts(
                    subcategoryId: subCatId,
                    title: subcategoryName, // Use the same name
                  ),
                ),
              );
            });

            // Show loading indicator while navigation happens
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: subcategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final item = subcategories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildSubcategoryPosts(
                        childSubcategoryId: item.id,
                        subcategoryId: subCatId,
                        title: item.childSubcat,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.image,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.childSubcat,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
*/
class ChildSubcategoryList extends StatefulWidget {
  final String subCatId;
  final String subcategoryName;

  const ChildSubcategoryList({
    super.key,
    required this.subCatId,
    required this.subcategoryName,
  });

  @override
  State<ChildSubcategoryList> createState() => _ChildSubcategoryListState();
}

class _ChildSubcategoryListState extends State<ChildSubcategoryList> {
  late Future<List<ChildSubcategoryModel>> _futureSubcategories;

  @override
  void initState() {
    super.initState();
    _futureSubcategories = ApiService.fetchChildSubcategories(widget.subCatId);
    _checkAndRedirect();
  }

  void _checkAndRedirect() async {
    final subcategories = await _futureSubcategories;
    if (subcategories.isEmpty && mounted) {
      // Navigate to posts screen only if no child subcategories
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChildSubcategoryPosts(
            subcategoryId: widget.subCatId,
            title: widget.subcategoryName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.subcategoryName,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
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
      body: FutureBuilder<List<ChildSubcategoryModel>>(
        future: _futureSubcategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final subcategories = snapshot.data ?? [];

          // ✅ No need to navigate here — handled in initState
          if (subcategories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: subcategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final item = subcategories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildSubcategoryPosts(
                        childSubcategoryId: item.id,
                        subcategoryId: widget.subCatId,
                        title: item.childSubcat,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.image,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.childSubcat,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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

class ChildSubcategoryPosts extends StatefulWidget {
  final String? childSubcategoryId; // Make optional
  final String subcategoryId; // Keep required
  final String title;

  const ChildSubcategoryPosts({
    super.key,
    this.childSubcategoryId,
    required this.subcategoryId,
    required this.title,
  });

  @override
  State<ChildSubcategoryPosts> createState() => _ChildSubcategoryPostsState();
}

class _ChildSubcategoryPostsState extends State<ChildSubcategoryPosts> {
  late Future<ViewCategoryPostModel> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      if (widget.childSubcategoryId != null) {
        // Fetch posts with both subcategory and child subcategory
        _postsFuture = ApiService.fetchCategoryPosts(
          widget.subcategoryId,
          widget.childSubcategoryId!,
        );
      } else {
        // Create a modified version of fetchCategoryPosts that only needs subcategoryId
        _postsFuture = ApiService.fetchCategoryPostsBySubcategoryOnly(widget.subcategoryId);
      }
    } catch (e) {
      // Handle error
      _postsFuture = Future.error(e);
      _showToast('Failed to load posts: $e');
      debugPrint('Error loading posts: $e');
    }
  }

  Future<void> _addViewToPost(String postId) async {
    try {
      debugPrint('Attempting to add view for post: $postId');
// Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Retrieve saved user_id
      // final userId = prefs.getString('user_id') ?? '0';
      final userId = int.parse(prefs.getString('user_id') ?? '0');
      final response = await ApiService.addView(userId: userId, postId: postId);

      if (response['status'] == 'success') {
        _showToast('View added successfully');
        debugPrint('View added successfully for post: $postId');
      } else {
        _showToast(response['message'] ?? 'View not added');
        debugPrint('View tracking message: ${response['message']}');
      }
    } catch (e) {
      _showToast('Failed to track view');
      debugPrint('Error adding view: $e');
    }
  }
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Future<ViewCategoryPostModel> _fetchPostsForSubcategoryOnly(String subcategoryId) async {
  //   final url = Uri.parse('https://sks.sitsolutions.co.in/view_category_post');
  //
  //   print('Making POST request to: $url');
  //   print('Request body: {"subcategory": "$subcategoryId"}');
  //
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'subcategory': subcategoryId,
  //       // Don't include child_subcategory parameter
  //     }),
  //   );
  //
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     return ViewCategoryPostModel.fromJson(jsonData);
  //   } else {
  //     throw HttpException(
  //         'Failed to load posts. Status code: ${response.statusCode}');
  //   }
  // }



  void _navigateToPostDetails(String postId) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Track view before navigating
      await _addViewToPost(postId);
      // Fetch post details
      final postDetails = await ApiService.fetchPostDetails(postId);
      debugPrint('Post details fetched: ${postDetails.toString()}');

      // Close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();


      // Navigate to post details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailsScreen(postDetails: postDetails),
        ),
      );
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();

      _showToast('Error loading post details');
      debugPrint('Error in _navigateToPostDetails: $e');
      // Show error
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error loading post details: $e')),
      // );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
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
      body: FutureBuilder<ViewCategoryPostModel>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadPosts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final posts = snapshot.data?.details ?? [];
          debugPrint('Loaded ${posts.length} posts');


          if (posts.isEmpty) {
            return const Center(child: Text("No posts available."));
          }

          return RefreshIndicator(
            onRefresh: _loadPosts,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.90, // Adjust this to fit your content better
              ),
              itemBuilder: (context, index) {
                final post = posts[index];
                return InkWell(
                  onTap: () => _navigateToPostDetails(post.id),
                  child: Card( color: Colors.cyan.shade50,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            post.photo,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 120,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: 120,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (post.name != null) ...[
                                  Text(
                                    post.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 4),
                                // if (post.price != null) ...[
                                //   Text(
                                //     '₹${post.price}',
                                //     style: const TextStyle(
                                //       fontSize: 16,
                                //       color: Colors.green,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ],
                                if (post.price != null || post.views.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (post.price != null)
                                        Text(
                                          '₹${post.price}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      Row(
                                        children: [
                                          const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            post.views,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );


          //   RefreshIndicator(
          //   onRefresh: _loadPosts,
          //   child: GridView.builder(
          //     padding: const EdgeInsets.all(12),
          //     itemCount: posts.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2, // 2 items per row
          //       mainAxisSpacing: 12,
          //       crossAxisSpacing: 12,
          //       childAspectRatio: 1.1, // Adjust for card height vs width
          //     ),
          //     itemBuilder: (context, index) {
          //       final post = posts[index];
          //       return InkWell(
          //         onTap: () => _navigateToPostDetails(post.id),
          //         child: Card(
          //           elevation: 3,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               ClipRRect(
          //                 borderRadius: const BorderRadius.only(
          //                   topLeft: Radius.circular(12),
          //                   topRight: Radius.circular(12),
          //                 ),
          //                 child: Image.network(
          //                   post.photo,
          //                   fit: BoxFit.cover,
          //                   width: double.infinity,
          //                   height: 120,
          //                   errorBuilder: (_, __, ___) => Image.asset(
          //                     'assets/images/placeholder.png',
          //                     fit: BoxFit.cover,
          //                     width: double.infinity,
          //                     height: 80,
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(10),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     if (post.name != null) ...[
          //                       Text(
          //                         post.name!,
          //                         maxLines: 1,
          //                         overflow: TextOverflow.ellipsis,
          //                         style: const TextStyle(
          //                           fontSize: 16,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                     ],
          //                     const SizedBox(height: 0),
          //                     if (post.price != null) ...[
          //                       Text(
          //                         '₹${post.price}',
          //                         style: const TextStyle(
          //                           fontSize: 14,
          //                           color: Colors.green,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                     ],
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // );

        },
      ),
    );
  }
}






class ViewCategoryPostModel {
  final String status;
  final String message;
  final List<PostDetail> details;

  ViewCategoryPostModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory ViewCategoryPostModel.fromJson(Map<String, dynamic> json) {
    return ViewCategoryPostModel(
      status: json['status']?.toString() ?? 'error', // Default to 'error'
      message: json['message']?.toString() ?? '',
      details: json['details'] != null
          ? List<PostDetail>.from(
        json['details'].map((x) => PostDetail.fromJson(x ?? {})),
      )
          : [],
    );
  }
}

class PostDetail {
  final String id;
  final String photo;
  final String price;
  final String? name; // Keep as nullable if it can be null
  final String views;

  PostDetail({
    required this.id,
    required this.photo,
    required this.price,
    this.name,
    required this.views,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
      id: json['id']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      price: json['price']?.toString() ?? '0', // Default to '0' if null
      name: json['name']?.toString(), // Can be null
      views: json['views'] ?? '0',
    );
  }
}


class ChildSubcategoryModel {
  final String id;
  final String catId;
  final String subcatId;
  final String childSubcat;
  final String image;
  final String isdeleted;
  final String createdAt;

  ChildSubcategoryModel({
    required this.id,
    required this.catId,
    required this.subcatId,
    required this.childSubcat,
    required this.image,
    required this.isdeleted,
    required this.createdAt,
  });

  factory ChildSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return ChildSubcategoryModel(
      id: json['id']?.toString() ?? '', // Handle null and convert to String
      catId: json['cat_id']?.toString() ?? '',
      subcatId: json['subcat_id']?.toString() ?? '',
      childSubcat: json['child_subcat']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isdeleted: json['isdeleted']?.toString() ?? '0', // Default to '0'
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}


class PostDetailsScreen extends StatelessWidget {
  final CalculationData postDetails;

  const PostDetailsScreen({super.key, required this.postDetails});

  @override
  Widget build(BuildContext context) {
    final details = postDetails.details;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(details.category,
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
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3), // 🔹 Border color and width
        borderRadius: BorderRadius.circular(12),           // 🔹 Same as ClipRRect radius
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // 🔁 Match radius for smooth corners
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
//
//       body: SingleChildScrollView(
//         padding:  EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     details.photo,
//                     width: double.infinity,
//                     height: 250,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 250,
//                       color: Colors.grey[300],
//                       child: const Center(child: Icon(Icons.error)),
//                     ),
//                   ),
//                 ),
//                /* Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.share, color: Colors.white),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.favorite_border, color: Colors.white),
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                 ),*/
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               details.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 16),
//             _buildDetailRow('Category', details.category),
//             _buildDetailRow('Type', details.type),
//             _buildDetailRow('Sub Type', details.subType),
//             _buildDetailRow('Price', '₹${details.price}'),
//             _buildDetailRow('Weight', '${details.weight} ${details.unit}'),
//             if (details.address != null) _buildDetailRow('Address', details.address ?? ''),
//
//             if (details.shopName != null) _buildDetailRow('Shop', details.shopName!),
//             // Add more fields as needed
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, {IconData? icon}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (icon != null)
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: Icon(icon, size: 20, color: Colors.green),
//             ),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 style: const TextStyle(fontSize: 16, color: Colors.black87),
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
//
// }


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
  final String photo;
  final String description;
  final String? address;  // Made nullable
  final String status;
  final String isDeleted;
  final String createdAt;
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
    this.address,  // Made nullable
    required this.status,
    required this.isDeleted,
    required this.createdAt,
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
      photo: json['photo']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString(),  // Can be null
      status: json['status']?.toString() ?? '',
      isDeleted: json['isdeleted']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      category: json['कॅटेगरी']?.toString() ?? '',
      type: json['प्रकार']?.toString() ?? '',
      subType: json['उप-प्रकार']?.toString() ?? '',
    );
  }
}