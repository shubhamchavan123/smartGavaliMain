import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/CategoryScreen.dart';
import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_screen.dart';
import 'package:smart_gawali/features/category/presentation/screen/category_model.dart';
import 'package:smart_gawali/features/category/presentation/screen/subcategory_model.dart';
import 'package:smart_gawali/features/home/data/model/banner_model.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyPostScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/ProfileScreen.dart';
import 'package:smart_gawali/screens/add_to_cart.dart';

import '../../../login/presentation/screen/CharaArjaFormScreen.dart';
import '../../../login/presentation/screen/MachineArjaFormScreen.dart';
import '../../../login/presentation/screen/member_ship_dialog.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.shopping_cart,
    Icons.qr_code,
    Icons.person,
  ];

  final List<Widget> _screens = [
    Container(), // Home content
    Center(child: CategoriesScreen()),
    Center(child: MyPostScreen()),
    Center(child: ProfileScreen()),
  ];

  final ApiService apiService = ApiService();

  List<CategoryDetail> categoryItems = [];


  List<String> bannerImages = [];
  List<String> advertiseImages = [];
  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchBannerImages("Banner");
  //   fetchBannerImages("Advertise");
  //   fetchCategories();
  // }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    try {
      final fetchedCategories = await ApiService.fetchCategories();
      final fetchedBanners = await ApiService.fetchBannerImages("Banner");
      final fetchedAds = await ApiService.fetchBannerImages("Advertise");

      setState(() {
        categoryItems = fetchedCategories;
        bannerImages = fetchedBanners;
        advertiseImages = fetchedAds;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading home data: $e');
    }
  }
 /* Future<void> fetchCategories() async {
    final url = Uri.parse('https://sks.sitsolutions.co.in/category_list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final model = categoryModelFromJson(response.body);
        setState(() {
          categoryItems = model.details;
        });
      } else {
        print('Failed to fetch categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchBannerImages(String type) async {
    final url = Uri.parse('https://sks.sitsolutions.co.in/banner_list');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"type": type}),
    );

    if (response.statusCode == 200) {
      final bannerModel = bannerModelFromJson(response.body);
      setState(() {
        if (type == "Banner") {
          bannerImages =
              bannerModel.details.map((detail) => detail.image).toList();
        } else if (type == "Advertise") {
          advertiseImages =
              bannerModel.details.map((detail) => detail.image).toList();
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load $type banners');
    }
  }
*/
  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2E7D32),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'शोधा',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.mic),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.notifications, color: Colors.green),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : CarouselSlider(
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      autoPlayInterval: Duration(seconds: 3),
                    ),
                    items: bannerImages.map((imageUrl) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                  ),
          ),

          // Heading and GridView
          // Heading and GridView
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 4), // Reduced bottom padding
                child: Text(
                  'तुमच्यासाठी खास व्यापार',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              isLoading
                  ? _buildShimmerGrid()
                  :GridView.builder(
                itemCount: categoryItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubCategoryScreen(
                            categoryId: categoryItems[index].id.toString(),
                            categoryName: categoryItems[index].category,
                          ),
                        ),
                      );
                    },
                    child: CategoryItem(
                      label: categoryItems[index].category,
                      image: categoryItems[index].image ?? '',
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Text(
                  'तुमच्यासाठी खास निवड',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width, // full screen width
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 220,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0, // ensures it uses the full width
                    ),
                    items: advertiseImages.map((imageUrl) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: Offset(2, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:
          _bottomNavIndex == 0 ? buildHomeContent() : _screens[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.4, // 40% of screen height
                width: MediaQuery.of(context).size.width, // 90% of screen width
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => MembershipDialog(),
                          );
                        },
                        child: const Text(
                          'प्राणी',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MachineArjaFormScreen()),
                            );
                          },
                          child: const Text(
                            'मशीन्स',
                            style: TextStyle(fontSize: 16),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CharaArjaFormScreen()),
                            );
                          },
                          child: const Text(
                            'चारा',
                            style: TextStyle(fontSize: 16),
                          )),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'आहार',
                            style: TextStyle(fontSize: 16),
                          )),
                      TextButton(
                          onPressed: () {},
                          child:
                              const Text('खत', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.green : Colors.grey;
          return Icon(iconList[index], color: color, size: 28);
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        backgroundColor: Colors.white,
        borderColor: Colors.green,
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String label;
  final String image;

  const CategoryItem({super.key, required this.label, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(2, 2), // Shadow only on right & bottom
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
              child: Image.network(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(image, fit: BoxFit.contain);
            },
          )),
          const SizedBox(height: 4),
          Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}



class SubCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const SubCategoryScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late Future<List<Details>> _subcategoriesFuture;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = ApiService.fetchSubCategories(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Details>>(
        future: _subcategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerGrid();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading subcategories'));
          }


          final subcategories = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: subcategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final sub = subcategories[index];
                return animalCard(
                  context,
                  sub.image ?? 'assets/images/gav.png',
                  sub.subcategory,
                  sub.id,
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Widget animalCard(BuildContext context, String imagePath, String label, String subCatId) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ProductListScreen(subCatId: subCatId),
  //         ),
  //       );
  //     },
  //     child: Card(
  //       color: Colors.white,
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       child: Container(
  //         padding: const EdgeInsets.all(8),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(8),
  //                 child: Image.network(
  //                   imagePath,
  //                   fit: BoxFit.cover,
  //                   width: double.infinity,
  //                   errorBuilder: (context, error, stackTrace) {
  //                     return Image.asset(
  //                       'assets/images/placeholder.png',
  //                       fit: BoxFit.cover,
  //                       width: double.infinity,
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 6),
  //             Text(
  //               label,
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(fontSize: 14),
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
Widget _buildShimmerGrid() {
  return GridView.builder(
    itemCount: 6, // Show 6 shimmer items
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    },
  );
}