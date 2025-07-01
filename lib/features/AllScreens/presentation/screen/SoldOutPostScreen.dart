import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiService/api_service.dart';
import '../../../home/presentation/screen/HomeScreen.dart';
import 'ProfileScreen.dart';

/*
class SoldOutPostScreen extends StatefulWidget {
  const SoldOutPostScreen({Key? key}) : super(key: key);

  @override
  State<SoldOutPostScreen> createState() => _SoldOutPostScreenState();
}

class _SoldOutPostScreenState extends State<SoldOutPostScreen> {
  List<SoldOutPost> soldOutPosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSoldOutPosts();
  }

  Future<void> fetchSoldOutPosts() async {
    // const url = 'https://sks.sitsolutions.co.in/sold_out_list';


    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Retrieve saved user_id
    final userId = prefs.getString('user_id') ?? '0';
    print("Saved user_id: $userId"); // Debug print to confirm value


    final body = jsonEncode({'user_id': userId});

    try {
      final response = await http.post(
        ApiService.soldOutList,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = SoldOutPostResponse.fromJson(data);
        setState(() {
          soldOutPosts = result.details;
          isLoading = false;
        });
      } else {
        showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error: ${e.toString()}');
    }
  }

  void showError(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('Sold Out Posts'),
      // ),
      appBar: AppBar(
        title: const Text('विक्री झाले', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) =>  ProfileScreen()),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchSoldOutPosts,
        child: soldOutPosts.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'कोणतीही विक्री झालेली पोस्ट आढळली नाही.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        )
            : ListView.builder(
          itemCount: soldOutPosts.length,
          itemBuilder: (context, index) {
            final post = soldOutPosts[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: post.photo.isNotEmpty
                          ? Image.network(
                        post.photo[0],
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                          : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Field List
                          _buildField("ID", post.id),
                          _buildField("वर्णन", post.description),
                          _buildField("नाव", post.name),
                          _buildField("किंमत", '₹${post.price}'),
                          _buildField("वजन", '${post.weight} ${post.unit}'),
                          _buildField("वय", post.age),
                          _buildField("दूध", post.milk),
                          _buildField("गाभण", post.isGhabhan == "Yes" ? 'होय (${post.ghabhanMonth ?? "?"} महिने)' : "नाही"),
                          _buildField("वापराचा कालावधी", post.useYear),
                          _buildField("दुकान", post.shopName),
                          _buildField("पत्ता", post.address),
                          _buildField("Views", post.views),
                          _buildField("Subcategory", post.subcategory),
                          _buildField("Child Subcategory", post.childSubcategory),
                          _buildField("Status", post.status),
                          _buildField("Sold Out", post.soldOut),
                          _buildField("Deleted", post.isDeleted),
                          _buildField("Created At", post.createdAt),
                          _buildField("पशुवैद्यकीय माहिती", post.vet),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.green, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'Sold Out',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

          // itemBuilder: (context, index) {
          //   final post = soldOutPosts[index];
          //   return Card(
          //     color: Colors.white,
          //     margin:
          //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //     elevation: 6,
          //     child: Padding(
          //       padding: const EdgeInsets.all(12.0),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           ClipRRect(
          //             borderRadius: BorderRadius.circular(8),
          //             child: post.photo != null && post.photo!.isNotEmpty
          //                 ? Image.network(
          //               post.photo[0],
          //               width: 100,
          //               height: 100,
          //               fit: BoxFit.fill,
          //               errorBuilder: (_, __, ___) => Container(
          //                 width: 100,
          //                 height: 100,
          //                 color: Colors.grey[200],
          //                 child: const Icon(Icons.broken_image),
          //               ),
          //             )
          //                 : Container(
          //               width: 100,
          //               height: 100,
          //               color: Colors.grey[200],
          //               child: const Icon(Icons.image),
          //             ),
          //           ),
          //           const SizedBox(width: 12),
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   post.description,
          //                   style: const TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                   maxLines: 2,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //                 const SizedBox(height: 6),
          //                 Text(
          //                   'Price: ₹${post.price}',
          //                   style: const TextStyle(
          //                     fontSize: 14,
          //                     color: Colors.black87,
          //                   ),
          //                 ),
          //                 if (post.weight != null &&
          //                     post.unit != null &&
          //                     post.weight!.isNotEmpty &&
          //                     post.unit!.isNotEmpty)
          //                   Text(
          //                     'Weight: ${post.weight} ${post.unit}',
          //                     style: const TextStyle(
          //                         fontSize: 13, color: Colors.grey),
          //                   ),
          //                 Text(
          //                   'Address: ${post.address}',
          //                   style: const TextStyle(
          //                       fontSize: 13, color: Colors.grey),
          //                   maxLines: 1,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //                 const SizedBox(height: 6),
          //                 Row(
          //                   children: const [
          //                     Icon(Icons.check_circle,
          //                         color: Colors.green, size: 18),
          //                     SizedBox(width: 4),
          //                     Text(
          //                       'Sold Out',
          //                       style: TextStyle(
          //                         color: Colors.green,
          //                         fontSize: 13,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // },
        ),
      ),




    );
  }
}
*/

class SoldOutPostScreen extends StatefulWidget {
  const SoldOutPostScreen({Key? key}) : super(key: key);

  @override
  State<SoldOutPostScreen> createState() => _SoldOutPostScreenState();
}

class _SoldOutPostScreenState extends State<SoldOutPostScreen> {
  List<SoldOutPost> soldOutPosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSoldOutPosts();
  }

  Future<void> fetchSoldOutPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '0';
    print("Saved user_id: $userId");

    final body = jsonEncode({'user_id': userId});

    try {
      final response = await http.post(
        ApiService.soldOutList,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = SoldOutPostResponse.fromJson(data);
        setState(() {
          soldOutPosts = result.details.reversed.toList(); // Reverse to show latest first
          isLoading = false;
          // soldOutPosts = result.details;
          // isLoading = false;
        });
      } else {
        showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error: ${e.toString()}');
    }
  }

  void showError(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('विक्री झाले', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchSoldOutPosts,
        child: soldOutPosts.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'कोणतीही विक्री झालेली पोस्ट आढळली नाही.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        )
            : ListView.builder(
          itemCount: soldOutPosts.length,
          itemBuilder: (context, index) {
            final post = soldOutPosts[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: post.photo.isNotEmpty
                          ? Image.network(
                        post.photo[0],
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                          : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // if (post.id.isNotEmpty) _buildField("ID", post.id),
                          if (post.category?.isNotEmpty ?? false) _buildField("कॅटेगरी", post.category),
                          if (post.subcategory?.isNotEmpty ?? false) _buildField("प्रकार", post.subcategory),
                          if (post.description?.isNotEmpty ?? false) _buildField("वर्णन", post.description),
                          if (post.name?.isNotEmpty ?? false) _buildField("नाव", post.name),
                          if (post.price?.isNotEmpty ?? false) _buildField("किंमत", '₹${post.price}'),
                          if (post.weight?.isNotEmpty ?? false && post.unit!.isNotEmpty ?? false)
                            _buildField("वजन", '${post.weight} ${post.unit}'),
                          if (post.age?.isNotEmpty ?? false) _buildField("वय", post.age),
                          if (post.milk?.isNotEmpty ?? false) _buildField("दूध", post.milk),
                          if (post.liter?.isNotEmpty ?? false) _buildField("लिटर", post.liter),
                          if (post.isGhabhan == "होय")
                            _buildField("गाभण", 'होय (${post.ghabhanMonth ?? "?"} महिने)'),
                          if (post.useYear?.isNotEmpty ?? false) _buildField("वापराचा कालावधी", post.useYear),
                          if (post.shopName?.isNotEmpty ?? false) _buildField("दुकान", post.shopName),
                          if (post.address.isNotEmpty) _buildField("पत्ता", post.address),
                          // if (post.views.isNotEmpty) _buildField("व्ह्यूज", post.views),

                          // if (post.vet?.isNotEmpty ?? false) _buildField("पशुवैद्यकीय माहिती", post.vet),

                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.green, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'Sold Out',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? '—',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class SoldOutPostResponse {
  final String status;
  final String message;
  final List<SoldOutPost> details;

  SoldOutPostResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory SoldOutPostResponse.fromJson(Map<String, dynamic> json) {
    return SoldOutPostResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details: (json['details'] as List<dynamic>)
          .map((item) => SoldOutPost.fromJson(item))
          .toList(),
    );
  }
}

class SoldOutPost {
  final String id;
  final String userId;
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
  final List<String> photo; // Split by comma
  final String? description;
  final String address;
  final String status;
  final String views;
  final String soldOut;
  final String isDeleted;
  final String createdAt;
  final String? liter;
  final String? category; // "कॅटेगरी"
  final String? subcategory; // "प्रकार"

  SoldOutPost({
    required this.id,
    required this.userId,
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
    required this.address,
    required this.status,
    required this.views,
    required this.soldOut,
    required this.isDeleted,
    required this.createdAt,
    this.liter,
    this.category,
    this.subcategory,
  });

  factory SoldOutPost.fromJson(Map<String, dynamic> json) {
    return SoldOutPost(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      age: json['age'],
      vet: json['vet'],
      milk: json['milk'],
      isGhabhan: json['is_ghabhan'],
      ghabhanMonth: json['ghabhan_month'],
      weight: json['weight'],
      unit: json['unit'],
      name: json['name'],
      price: json['price'],
      useYear: json['use_year'],
      shopName: json['shop_name'],
      photo: (json['photo'] as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      description: json['description'],
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      views: json['views'] ?? '',
      soldOut: json['sold_out'] ?? '',
      isDeleted: json['isdeleted'] ?? '',
      createdAt: json['created_at'] ?? '',
      liter: json['Liter'],
      category: json['कॅटेगरी'],
      subcategory: json['प्रकार'],
    );
  }
}


/*
class SoldOutPostResponse {
  final String status;
  final String message;
  final List<SoldOutPost> details;

  SoldOutPostResponse({
    required this.status,
    required this.message,
    required this.details,
  });

  factory SoldOutPostResponse.fromJson(Map<String, dynamic> json) {
    return SoldOutPostResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => SoldOutPost.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class SoldOutPost {
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
  final String address;
  final String status;
  final String views;
  final String soldOut;
  final String isDeleted;
  final String createdAt;

  SoldOutPost({
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
    required this.address,
    required this.status,
    required this.views,
    required this.soldOut,
    required this.isDeleted,
    required this.createdAt,
  });

  factory SoldOutPost.fromJson(Map<String, dynamic> json) {
    return SoldOutPost(
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
      weight: json['weight']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      name: json['name']?.toString(),
      price: json['price']?.toString() ?? '',
      useYear: json['use_year']?.toString(),
      shopName: json['shop_name']?.toString(),
      photo: (json['photo'] ?? '').toString().split(','),
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      views: json['views']?.toString() ?? '',
      soldOut: json['sold_out']?.toString() ?? '',
      isDeleted: json['isdeleted']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
*/
