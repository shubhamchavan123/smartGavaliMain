import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';

import 'package:smart_gawali/features/category/presentation/screen/subcategory_model.dart';
import 'package:smart_gawali/features/login/presentation/screen/HirvaCharaListingScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/NewMachineListingScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/OldMachineListingScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/PraniListingScreen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_gawali/screens/add_to_cart.dart';
import '../../../../provider/calcium_mineral_product_provider.dart';
import 'calcium_mineral_mixture_product_list_screen.dart';
import 'category_model.dart'; // Make sure this file contains your CategoryModel and Detail classes

// class CategoryService {
//   static const String apiUrl = 'https://sks.sitsolutions.co.in/category_list';
//   static const String subcatUrl =
//       'https://sks.sitsolutions.co.in/subcategory_list';
//
//   static Future<List<CategoryDetail>> fetchCategories() async {
//     final response = await http.get(Uri.parse(apiUrl));
//
//     if (response.statusCode == 200) {
//       final categoryModel = categoryModelFromJson(response.body);
//       return categoryModel.details
//           .where((element) => element.isDeleted == "0")
//           .toList(); // Filter deleted
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
//
//   static Future<List<Details>> fetchsubCategories(String subCatId) async {
//     final response = await http.post(
//       Uri.parse(subcatUrl),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "cat_id": subCatId,
//       }),
//     );
//
//     print("Response Body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       try {
//         final subcategoryModel = subcategoryModelFromJson(response.body);
//         return subcategoryModel.details
//             .where((element) => element.isdeleted == "0")
//             .toList();
//       } catch (e) {
//         throw Exception('Parsing failed: $e');
//       }
//     } else {
//       throw Exception('API failed: ${response.statusCode}');
//     }
//   }
// }

class CategoriesScreen extends StatefulWidget {
  // final String subCatId; // Add this

  const CategoriesScreen({
    Key? key,
  }) : super(key: key); // Add this

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<CategoryDetail>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService.fetchCategories(); // Fetch categories

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: FutureBuilder<List<CategoryDetail>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];

          // Sort by id (as int)
          categories.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

          /// Group categories by their category name (e.g., प्राणी, मशीन)
          // Then group
          final Map<String, List<CategoryDetail>> groupedCategories = {};
          for (var item in categories) {
            if (!groupedCategories.containsKey(item.category)) {
              groupedCategories[item.category] = [];
            }
            groupedCategories[item.category]!.add(item);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedCategories.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeader(entry.key),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Details>>(
                      future: ApiService.fetchSubCategories(
                          entry.value.first.id),
                      builder: (context, subSnapshot) {
                        if (subSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildShimmerGrid(); // Show shimmer for subcategories
                        } else if (subSnapshot.hasError) {
                          return Center(
                              child: Text('Error loading subcategories'));
                        }

                        final subcategories = subSnapshot.data ?? [];

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: subcategories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                            final subItem = subcategories[index];
                            return animalCard(
                              context,
                              subItem.image ?? 'assets/images/gav.png',
                              subItem.subcategory, // display subcategory name
                              subItem
                                  .id, // use this as subCatId for navigation or logic
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'कॅटेगरी',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      centerTitle: false,
      leading: Container(
        margin: EdgeInsets.all(8),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
  /*    actions: [
        Container(
          margin: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.brown,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCartScreen()),
              );
            },
          ),
        )
      ],*/

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget animalCard(
      BuildContext context, String imagePath, String label, String categoryId) {
    return InkWell(
        onTap: () {
          if (categoryId == "10") {
            // this is demo
            print("***************************tapped $categoryId");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddToCart(subCatId: categoryId),
              ),
            );
          } else {
            print("*************************** $categoryId");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(subCatId: categoryId),
              ),
            );
          }
        },
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }

}

///  प्राणी
Widget PraniCard(BuildContext context, String imagePath, String label) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CowListingScreen(),
        ),
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 80, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildShimmerLoading() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer(
          child: Container(
            height: 30,
            width: 200,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        _buildShimmerGrid(),
        const SizedBox(height: 24),
        Shimmer(
          child: Container(
            height: 30,
            width: 200,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        _buildShimmerGrid(),
      ],
    ),
  );
}

Widget _buildShimmerGrid() {
  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 6, // Show 6 shimmer items00000
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.9,
    ),
    itemBuilder: (context, index) {
      return Shimmer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.grey[300],
              ),
              const SizedBox(height: 4),
              Container(
                height: 12,
                width: 80,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      );
    },
  );
}



class PraniItem {
  final String imagePath;
  final String label;

  PraniItem({required this.imagePath, required this.label});

  // Optional: If you are fetching from an API
  factory PraniItem.fromJson(Map<String, dynamic> json) {
    return PraniItem(
      imagePath: json['imagePath'], // e.g., URL or asset path
      label: json['label'],
    );
  }
}

List<PraniItem> praniCategories =
    responseData.map((e) => PraniItem.fromJson(e)).toList();
List<Map<String, dynamic>> responseData = [
  {'imagePath': 'assets/images/gav.png', 'label': 'गाय'},
  {'imagePath': 'assets/images/gav.png', 'label': 'म्हैस'},
  {'imagePath': 'assets/images/gav.png', 'label': 'जर्सी गाय'},
];

///  नवीन मशीन्स

Widget NewMachineCard(BuildContext context, String imagePath, String label) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewMachineListingScreen(),
        ),
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 80, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}

class NewMachineItem {
  final String imagePath;
  final String label;

  NewMachineItem({required this.imagePath, required this.label});

  // Optional: If you are fetching from an API
  factory NewMachineItem.fromJson(Map<String, dynamic> json) {
    return NewMachineItem(
      imagePath: json['imagePath'], // e.g., URL or asset path
      label: json['label'],
    );
  }
}

List<NewMachineItem> newmachineCategories =
    newmachineresponseData.map((e) => NewMachineItem.fromJson(e)).toList();
List<Map<String, dynamic>> newmachineresponseData = [
  {'imagePath': 'assets/images/machine.png', 'label': 'कडबा कुट्टी'},
  {'imagePath': 'assets/images/machine.png', 'label': 'मिल्किंग मशीन'},
];

///===========  जुने मशीन्स

Widget OldMachineCard(BuildContext context, String imagePath, String label) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OldMachineListingScreen(),
        ),
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 80, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}

class OldMachineItem {
  final String imagePath;
  final String label;

  OldMachineItem({required this.imagePath, required this.label});

  // Optional: If you are fetching from an API
  factory OldMachineItem.fromJson(Map<String, dynamic> json) {
    return OldMachineItem(
      imagePath: json['imagePath'], // e.g., URL or asset path
      label: json['label'],
    );
  }
}

List<OldMachineItem> oldmachineCategories =
    oldmachineresponseData.map((e) => OldMachineItem.fromJson(e)).toList();
List<Map<String, dynamic>> oldmachineresponseData = [
  {'imagePath': 'assets/images/machine.png', 'label': 'कडबा कुट्टी '},
  // {'imagePath': 'assets/images/machine.png', 'label': 'मिल्किंग मशीन'},
];

/// ======   हिरवा चारा

Widget HirvaCharaCard(BuildContext context, String imagePath, String label) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HirvaCharaListingScreen(),
        ),
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 80, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}

class HirvaCharaItem {
  final String imagePath;
  final String label;

  HirvaCharaItem({required this.imagePath, required this.label});

  // Optional: If you are fetching from an API
  factory HirvaCharaItem.fromJson(Map<String, dynamic> json) {
    return HirvaCharaItem(
      imagePath: json['imagePath'], // e.g., URL or asset path
      label: json['label'],
    );
  }
}

List<HirvaCharaItem> hirvacharaCategories =
    hirvachararesponseData.map((e) => HirvaCharaItem.fromJson(e)).toList();
List<Map<String, dynamic>> hirvachararesponseData = [
  {'imagePath': 'assets/images/chara.png', 'label': ' मका '},
  {'imagePath': 'assets/images/chara.png', 'label': ' घास '},
  {'imagePath': 'assets/images/chara.png', 'label': ' कडवळ'},
  // {'imagePath': 'assets/images/machine.png', 'label': 'मिल्किंग मशीन'},
];
