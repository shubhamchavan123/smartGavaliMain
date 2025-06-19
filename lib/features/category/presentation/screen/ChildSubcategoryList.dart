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
import 'package:smart_gawali/features/AllScreens/presentation/screen/PostDetailsScreen.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';

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
  final String? childSubcategoryId;
  final String subcategoryId;
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPosts();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    try {
      if (widget.childSubcategoryId != null) {
        _postsFuture = ApiService.fetchCategoryPosts(
          widget.subcategoryId,
          widget.childSubcategoryId!,
        );
      } else {
        _postsFuture =
            ApiService.fetchCategoryPostsBySubcategoryOnly(widget.subcategoryId);
      }
    } catch (e) {
      _postsFuture = Future.error(e);
      _showToast('Failed to load posts: $e');
    }
  }

  Future<void> _addViewToPost(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = int.parse(prefs.getString('user_id') ?? '0');
      final response =
      await ApiService.addView(userId: userId, postId: postId);

      if (response['status'] == 'success') {
        debugPrint('View added successfully for post: $postId');
      } else {
        _showToast(response['message'] ?? 'View not added');
      }
    } catch (e) {
      _showToast('Failed to track view');
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

  void _navigateToPostDetails(String postId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await _addViewToPost(postId);
      final postDetails = await ApiService.fetchPostDetails(postId);

      if (!mounted) return;
      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailsScreen(postDetails: postDetails),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      _showToast('Error loading post details');
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: TextField(
          //     controller: _searchController,
          //     decoration: InputDecoration(
          //       hintText: 'Search by location...',
          //       prefixIcon: Icon(Icons.search),
          //       suffixIcon: _searchQuery.isNotEmpty
          //           ? IconButton(
          //         icon: Icon(Icons.clear),
          //         onPressed: () {
          //           _searchController.clear();
          //         },
          //       )
          //           : null,
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
                    : null,

                // Border when not focused
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                ),

                // Border when focused
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                ),

                // Border when there's an error (optional)
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),

                // Border when focused and there's an error (optional)
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),

                // Default border fallback
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<ViewCategoryPostModel>(
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

                // 🔍 Filter by location address
                final filteredPosts = posts.where((post) {
                  final address = post.address?.toLowerCase() ?? '';
                  return address.contains(_searchQuery);
                }).toList();

                if (filteredPosts.isEmpty) {
                  return const Center(child: Text("No posts found."));
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final crossAxisCount = screenWidth < 600
                        ? 2
                        : screenWidth < 900
                        ? 3
                        : 4;
                    final spacing = 12.0;
                    final totalHorizontalPadding =
                        spacing * (crossAxisCount + 1);
                    final itemWidth =
                        (screenWidth - totalHorizontalPadding) / crossAxisCount;
                    final itemHeight = 240;
                    final aspectRatio = itemWidth / itemHeight;

                    return RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.green,
                      onRefresh: _loadPosts,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredPosts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final post = filteredPosts[index];
                          return InkWell(
                            onTap: () => _navigateToPostDetails(post.id),
                            child: Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 140,
                                    child: post.photo.isNotEmpty
                                        ? PageView.builder(
                                      itemCount: post.photo.length,
                                      itemBuilder: (context, index) {
                                        return ClipRRect(
                                          borderRadius:
                                          const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                          child: Image.network(
                                            post.photo[index],
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Image.asset(
                                                    'assets/images/placeholder.png',
                                                    fit: BoxFit.cover),
                                          ),
                                        );
                                      },
                                    )
                                        : Image.asset(
                                      'assets/images/placeholder.png',
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '₹${post.price}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              if (post.category != null)
                                                Expanded(
                                                  child: Text(
                                                    _buildTypeText(post),
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w800,

                                                    ),
                                                  ),
                                                ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.remove_red_eye,
                                                      size: 16,
                                                      color: Colors.grey),
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _buildTypeText(PostDetail post) {
    if (post.type != null && post.subType != null) {
      return '${post.type} > ${post.subType}';
    } else if (post.type != null) {
      return post.type!;
    } else if (post.subType != null) {
      return post.subType!;
    } else {
      return '';
    }
  }
}

// String _buildTypeText(PostDetail post) {
//   final category = post.category?.trim() ?? '';
//   final type = post.type?.trim() ?? '';
//   final subType = post.subType?.trim() ?? '';
//
//   final parts = [category, type, subType].where((part) => part.isNotEmpty).toList();
//   return parts.join(' - ');
// }
String _buildTypeText(PostDetail post) {
  final category = post.category?.trim() ?? '';
  final type = post.type?.trim() ?? '';
  final subType = post.subType?.trim() ?? '';

  // Full list with all non-empty values
  final parts = [category, type, subType].where((part) => part.isNotEmpty).toList();

  final fullText = parts.join(' - ');

  // If it matches specific format with category at the beginning, remove category
  if (category == 'चारा' && parts.length == 3) {
    return [type, subType].where((p) => p.isNotEmpty).join(' - ');
  }

  return fullText;
}

// String _buildTypeText(PostDetail post) {
//   final type = post.type?.trim() ?? '';
//   final subType = post.subType?.trim() ?? '';
//
//   if (type.isNotEmpty && subType.isNotEmpty) {
//     return '$type - $subType'; // 👉 हिरवा चारा-मका
//   } else if (type.isNotEmpty) {
//     return type; // 👉 हिरवा चारा
//   } else {
//     return '';
//   }
// }

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
      status: json['status']?.toString() ?? 'error',
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
  final List<String> photo;
  final String price;
  final String? name;
  final String views;
  final String? category;
  final String? type;     // प्रकार
  final String? subType;  // उप-प्रकार
  final String? address;  // Add this line

  PostDetail({
    required this.id,
    required this.photo,
    required this.price,
    this.name,
    required this.views,
    this.category,
    this.type,
    this.subType,
    this.address, // Add this line
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
      id: json['id']?.toString() ?? '',
      photo: (json['photo'] as String?)
          ?.split(',')
          .map((e) => e.trim())
          .toList() ?? [],
      price: json['price']?.toString() ?? '0',
      name: json['name']?.toString(),
      views: json['views']?.toString() ?? '0',
      category: json['कॅटेगरी']?.toString(),
      type: json['प्रकार']?.toString(),
      subType: json['उप-प्रकार']?.toString(),
      address: json['address']?.toString(), // Parse address here
    );
  }
}

// class PostDetail {
//   final String id;
//   final List<String> photo;
//   final String price;
//   final String? name;
//   final String views;
//   final String? category;
//   final String? type;     // प्रकार
//   final String? subType;  // उप-प्रकार
//
//   PostDetail({
//     required this.id,
//     required this.photo,
//     required this.price,
//     this.name,
//     required this.views,
//     this.category,
//     this.type,
//     this.subType,
//   });
//
//   factory PostDetail.fromJson(Map<String, dynamic> json) {
//     return PostDetail(
//       id: json['id']?.toString() ?? '',
//       photo: (json['photo'] as String?)
//           ?.split(',')
//           .map((e) => e.trim())
//           .toList() ?? [],
//       price: json['price']?.toString() ?? '0',
//       name: json['name']?.toString(),
//       views: json['views']?.toString() ?? '0',
//       category: json['कॅटेगरी']?.toString(),
//       type: json['प्रकार']?.toString(),
//       subType: json['उप-प्रकार']?.toString(),
//     );
//   }
// }




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

