
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/CategoryScreen.dart';
import 'package:smart_gawali/features/category/presentation/screen/category_model.dart';
import 'package:smart_gawali/features/category/presentation/screen/subcategory_model.dart';
import 'package:smart_gawali/features/login/presentation/screen/DynamicFormScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyPostScreen.dart';
import 'package:smart_gawali/features/login/presentation/screen/ProfileScreen.dart';
import 'package:smart_gawali/screens/add_to_cart.dart';

import '../../../NotificationScreen/notification_screen.dart';
import '../../../category/presentation/screen/ChildSubcategoryList.dart';
import '../../../services/get_server_key.dart';
import '../../../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  NotificationService notificationService = NotificationService();
  final GetServerKey _getServerKey = GetServerKey();



  int _bottomNavIndex = 0;

  // final iconList = <IconData>[
  //   Icons.home,
  //   Icons.category_outlined,
  //   Icons.post_add,
  //   Icons.person,
  // ];
  final navItems = <Map<String, dynamic>>[
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.category_outlined, 'label': 'Category'},
    {'icon': Icons.post_add, 'label': 'Post'},
    {'icon': Icons.person, 'label': 'Profile'},
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
  int _notificationCount = 0;    // ← new
  @override
  void initState() {
    super.initState();
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    // notificationService.firebaseInit(context);
    // notificationService.setupInteractMessage(context);
    _initializeNotifications();
    getServiceToken();
    fetchData();
    // Listen for new messages and bump the counter
    notificationService.initialize().then((_) {
      notificationService.firebaseInit(context);
      notificationService.setupInteractMessage(context);
    });



    // Listen for new messages and bump the counter
    FirebaseMessaging.onMessage.listen((message) {
      setState(() {
        _notificationCount = notificationService.notifications.length;
      });
    });
  }

  Future<void> _initializeNotifications() async {
    await notificationService.initialize();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);

    // Listen for new messages
    FirebaseMessaging.onMessage.listen((message) {
      setState(() {
        _notificationCount = notificationService.notifications.length;
      });
    });
  }

  Future<void> getServiceToken() async {
    String serverToken = await _getServerKey.getServerKeyToken();
    print("Server Token => $serverToken");
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

  Widget buildHomeContent() {
    return RefreshIndicator(
      onRefresh: () async {
        // Call your data fetching methods here
        await fetchData();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
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
                  // Stack(
                  //   children: [
                  //
                  //     GestureDetector(
                  //       onTap: () {
                  //         setState(() => _notificationCount = 0);
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => NotificationScreen(
                  //               notifications: notificationService.notifications,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //       child: CircleAvatar(
                  //         backgroundColor: Colors.white,
                  //         child: Icon(Icons.notifications, color: Colors.green),
                  //       ),
                  //     ),
                  //    /* GestureDetector(
                  //       onTap: () {
                  //
                  //         setState(() => _notificationCount = 0);
                  //
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => NotificationScreen(),
                  //           ),
                  //         );
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(builder: (context) => NotificationScreen()),
                  //         // );
                  //       },
                  //       child: CircleAvatar(
                  //         backgroundColor: Colors.white,
                  //         child: Icon(Icons.notifications, color: Colors.green),
                  //       ),
                  //     ),*/
                  //     // Notification count badge
                  //     // 2) Badge, only if > 0
                  //     if (_notificationCount > 0)
                  //       Positioned(
                  //         right: 4,
                  //         top: 4,
                  //         child: Container(
                  //           padding: EdgeInsets.all(2),
                  //           decoration: BoxDecoration(
                  //             color: Colors.red,
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                  //           child: Text(
                  //             '$_notificationCount',
                  //             style: TextStyle(color: Colors.white, fontSize: 10),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //       ),
                  //     // Positioned(
                  //     //   right: 4,
                  //     //   top: 4,
                  //     //   child: Container(
                  //     //     padding: EdgeInsets.all(2),
                  //     //     decoration: BoxDecoration(
                  //     //       color: Colors.red,
                  //     //       borderRadius: BorderRadius.circular(10),
                  //     //     ),
                  //     //     constraints: BoxConstraints(
                  //     //       minWidth: 16,
                  //     //       minHeight: 16,
                  //     //     ),
                  //     //     child: Text(
                  //     //       '3', // <-- Replace with dynamic count
                  //     //       style: TextStyle(
                  //     //         color: Colors.white,
                  //     //         fontSize: 10,
                  //     //       ),
                  //     //       textAlign: TextAlign.center,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //   ],
                  // )
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() => _notificationCount = 0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(
                                message: null,
                                notifications: notificationService.notifications,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.notifications, color: Colors.green),
                        ),
                      ),
                      if (_notificationCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$_notificationCount',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  )
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
                ),
                SizedBox(height: 20,)
              ],
            ),
          ],
        ),
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
                height: MediaQuery.of(context).size.height * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: categoryItems.length,
                    itemBuilder: (context, index) {
                      final category = categoryItems[index];
                      return ListTile(
                        title: Text(category.category),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DynamicFormScreen(
                                categoryName: category.category,
                                categoryId: category.id,
                              )
                              //     AnimalArjaFormScreen(
                              //   categoryName: category.category,
                              //   // catId: int.tryParse(category.id) ?? 0,
                              //
                              // ),
                            ),
                          );

                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubCategoryScreen(
                                categoryId: category.id.toString(),
                                categoryName: category.category,
                              ),
                            ),
                          );*/
                          ///
                        /*  showDialog(
                                                  context: context,
                                                  builder: (context) => MembershipDialog(),
                                                );*/
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },


      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: AnimatedBottomNavigationBar.builder(
      //   itemCount: iconList.length,
      //   tabBuilder: (int index, bool isActive) {
      //     final color = isActive ? Colors.green : Colors.grey;
      //     return Icon(iconList[index], color: color, size: 28);
      //   },
      //   activeIndex: _bottomNavIndex,
      //   gapLocation: GapLocation.center,
      //   notchSmoothness: NotchSmoothness.verySmoothEdge,
      //   leftCornerRadius: 32,
      //   rightCornerRadius: 32,
      //   onTap: (index) => setState(() => _bottomNavIndex = index),
      //   backgroundColor: Colors.white,
      //   borderColor: Colors.green,
      // ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: navItems.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.green : Colors.grey;
          return Container(
            height: 60,
            // padding: EdgeInsets.only(top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(navItems[index]['icon'], color: color, size: 28),
                const SizedBox(height: 2),
                Text(
                  navItems[index]['label'],
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          );
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
          ),
          ),
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


/// old flip working code

  /*Widget animalCard(
      BuildContext context, String imagePath, String label, String categoryId) {
    return InkWell(
        onTap: () {
          debugPrint("SubCategory Tapped: ID = $categoryId");

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
                builder: (context) => ChildSubcategoryList(subCatId: categoryId, subcategoryName: label,),
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
*/
  /// new  flip working  code
  Widget animalCard(
      BuildContext context, String imagePath, String label, String categoryId) {
    return InkWell(
      onTap: () async {
        debugPrint("SubCategory Tapped: ID = $categoryId");

        if (categoryId == "10") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddToCart(subCatId: categoryId),
            ),
          );
        } else {
          // ✅ Check if child subcategories exist before navigating
          final subcategories =
          await ApiService.fetchChildSubcategories(categoryId);

          if (subcategories.isEmpty) {
            // No child categories — go directly to posts
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildSubcategoryPosts(
                  subcategoryId: categoryId,
                  title: label,
                ),
              ),
            );
          } else {
            // Child categories exist — show the list
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildSubcategoryList(
                  subCatId: categoryId,
                  subcategoryName: label,
                ),
              ),
            );
          }
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      ),
    );
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