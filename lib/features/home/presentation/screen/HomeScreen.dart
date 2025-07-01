import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smart_gawali/features/ApiService/api_service.dart';
import 'package:smart_gawali/features/category/presentation/screen/CategoryScreen.dart';
import 'package:smart_gawali/features/category/presentation/screen/category_model.dart';
import 'package:smart_gawali/features/category/presentation/screen/subcategory_model.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/DynamicFormScreen.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/MyPostScreen.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/ProfileScreen.dart';
import 'package:smart_gawali/payment_gateway/easebuzz_payment.dart';
import 'package:smart_gawali/screens/add_to_cart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../AllScreens/presentation/screen/member_ship_dialog.dart';
import '../../../NotificationScreen/notification_screen.dart';
import '../../../category/presentation/screen/ChildSubcategoryList.dart';
import '../../../category/presentation/screen/PostCategoryModel.dart';

import '../../../services/get_server_key.dart';
import '../../../services/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationService = NotificationService();
  // final GetServerKey _getServerKey = GetServerKey();

  int _bottomNavIndex = 0;

  // Add these variables
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

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
  List<CategoryDetail> filteredCategories = [];
  TextEditingController _searchController = TextEditingController();

  List<String> bannerImages = [];
  List<String> advertiseImages = [];
  bool isLoading = true;

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  String? _networkImageUrl;
  File? _localProfileImage;
  String? _userName; // ✅ Declare here

  // @override
  // void initState() {
  //   super.initState();
  //   fetchBannerImages("Banner");
  //   fetchBannerImages("Advertise");
  //   fetchCategories();
  // }
  int _notificationCount = 0; // ← new
  @override
  void initState() {
    super.initState();

    _checkInternetConnection();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isConnected = results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
      });
      if (_isConnected) {
        // Refresh data when connection is restored
        fetchData();
      }
    });
    _loadUserData();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    // notificationService.firebaseInit(context);
    // notificationService.setupInteractMessage(context);
    _initializeNotifications();
    getServiceToken();
    fetchData();
    _loadUserName();
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      final profile = userData['profile']?.toString() ?? '';
      final name = userData['name']?.toString() ?? '';

      if (profile.isNotEmpty) {
        if (Uri.tryParse(profile)?.isAbsolute == true) {
          setState(() {
            _networkImageUrl = profile;
            _localProfileImage = null;
          });
        } else if (await File(profile).exists()) {
          setState(() {
            _localProfileImage = File(profile);
            _networkImageUrl = null;
          });
        }
      }

      setState(() {

        _userName = name; // Make sure this matches your existing variable
      });
    }
  }
  void _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      setState(() {
        _userName = userData['name'] ?? 'User'; // Replace 'name' with actual key
      });
    }
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
        filteredCategories = fetchedCategories;
        filteredCategories = List.from(fetchedCategories);
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

  bool get isSearching => _searchController.text.trim().isNotEmpty;

  Widget buildHomeContent() {
    return RefreshIndicator(
      onRefresh: () async {
        // Call your data fetching methods here
        await fetchData();
      },
      child: SingleChildScrollView(
        physics:
            AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _networkImageUrl != null
                            ? NetworkImage(_networkImageUrl!)
                            : _localProfileImage != null
                            ? FileImage(_localProfileImage!)
                            : const AssetImage('assets/icons/profile_img.png')
                        as ImageProvider,
                      ),
                    ),
                  ),
                  title: const Text(
                    'Welcome',
                    style: TextStyle(color: Colors.black54, fontSize: 14,fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _userName ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

            ),


            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {
                          filteredCategories = categoryItems
                              .where((item) =>
                              item.category.toLowerCase().contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'शोधा',
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              filteredCategories = List.from(categoryItems);
                            });
                          },
                        )
                            : null, // 🔹 Removed mic icon
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() => _notificationCount = 0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(
                                notifications:
                                    notificationService.notifications,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.notifications, color: Colors.green,size: 30,),
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
                            constraints:
                                BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$_notificationCount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
        if (!isSearching) ...[
           Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 160,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                autoPlayInterval: Duration(seconds: 3),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
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

            const SizedBox(height: 8),
            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: bannerImages.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 10,
                activeDotColor: Colors.green,
                dotColor: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
         ],
            // Heading and GridView

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               if (!isSearching) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'तुमच्यासाठी खास व्यापार',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ],
                const SizedBox(height: 10),
                isLoading
                    ? _buildShimmerGrid()
                    : filteredCategories.isEmpty
                        ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5, // or full if you want
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.search_off_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'कोणतेही प्रोडक्ट सापडली नाही',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                )
                        : GridView.builder(
                  itemCount: filteredCategories.length,
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
                              categoryId: filteredCategories[index].id.toString(),
                              categoryName: filteredCategories[index].category,
                            ),
                          ),
                        );
                      },
                      child: CategoryItem(
                        label: filteredCategories[index].category,
                        image: filteredCategories[index].image ?? '',
                      ),
                    );
                  },
                ),
           if (!isSearching) ...[
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'तुमच्यासाठी खास निवड',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width, // full screen width
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 180,
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
           ],
                SizedBox(
                  height: 20,
                )
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
      body:_isConnected
          ? (_bottomNavIndex == 0 ? buildHomeContent() : _screens[_bottomNavIndex])
          : _buildNoInternetScreen(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {

            // First check internet connection
            final connectivityResult = await Connectivity().checkConnectivity();
            final isConnected = connectivityResult.isNotEmpty &&
                connectivityResult.any((r) => r != ConnectivityResult.none);

            if (!isConnected) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('No internet connection')),
              // );
              return;
            }

            final result = await ApiService.verifySubscription();

            String subscriptionStatus = result['status'] ?? 'error';
            String startDate = result['start_date'] ?? '';
            String endDate = result['end_date'] ?? '';

            double itemHeight = 50.0; // Approximate height per ListTile
            double maxHeight = MediaQuery.of(context).size.height * 0.8;
            double calculatedHeight = categoryItems.length * itemHeight + 32; // + padding

            if (subscriptionStatus == 'active') {
              // Show category selection bottom sheet


              showModalBottomSheet(
                backgroundColor: Colors.lightGreen.shade100,
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  // Declare variables outside StatefulBuilder so they persist
                  bool isLoading = true;
                  List<PostCategoryDetail> categoryItems = [];

                  return StatefulBuilder(
                    builder: (context, setState) {
                      // Fetch only once (when the sheet is built the first time)
                      if (isLoading) {
                        debugPrint("Fetching post categories...");
                        ApiService.fetchPostCategories().then((items) {
                          debugPrint("Post categories fetched: ${items.length}");
                          for (var item in items) {
                            debugPrint("Category ID: ${item.id}, Name: ${item.category}");
                          }
                          setState(() {
                            categoryItems = items;
                            isLoading = false;
                          });
                        }).catchError((error) {
                          debugPrint("Error fetching post categories: $error");
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to load categories")),
                          );
                        });
                      }


                      return SizedBox(
                        height: calculatedHeight > maxHeight ? maxHeight : calculatedHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                            shrinkWrap: true,
                            itemCount: categoryItems.length,
                            itemBuilder: (context, index) {
                              final category = categoryItems[index];
                              return ListTile(
                                title: Text(category.category,style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, // Optional: Adjust size as needed
                                ),),
                                onTap: () {
                                  debugPrint("Tapped Category: ${category.category} (ID: ${category.id})");
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DynamicFormScreen(
                                        categoryName: category.category,
                                        categoryId: category.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );

                    },
                  );
                },
              );


            } else {
              String message = '';
              if (subscriptionStatus == 'post_limit') {
                message =
                    'तुम्ही तुमची पोस्ट मर्यादा गाठली आहे. कृपया तुमचा प्लॅन अपग्रेड करा.';
              } else if (subscriptionStatus == 'end_date') {
                message =
                    'तुमचे सदस्यत्व $endDate रोजी कालबाह्य झाले. सुरू ठेवण्यासाठी कृपया रिन्यू करा.';
              } else {
                message = 'कृपया सदस्यता घ्या';
              }

              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 24.0,
                  insetAnimationDuration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1B5E20), // Dark green
                          Color(0xFF388E3C), // Medium green
                          Color(0xFF81C784), // Light green
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'सदस्यता आवश्यक आहे',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white70,
                                ),
                                child: const Text('CANCEL'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const MembershipDialog(),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  'SUBSCRIBE',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: navItems.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Colors.green : Colors.grey;
            return Container(
              height: 80,
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
          // leftCornerRadius: 32,
          // rightCornerRadius: 32,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          backgroundColor: Colors.white,
          shadow: const BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 4,
          )),
    );


  }
}

Widget _buildNoInternetScreen() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon(Icons.wifi_off, size: 80, color: Colors.grey),
        Lottie.asset(
          'assets/icons/no_internet.json',
          width: 300,
          height: 500,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20),
        Text(
          'No Internet Connection',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Please check your internet connection and try again',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),

      ],
    ),
  );
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
              fit: BoxFit.fill,
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
              style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
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

  String? _userName;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = ApiService.fetchSubCategories(widget.categoryId);
    _loadUserName();
  }

  void _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      setState(() {
        _userName = userData['name'] ?? 'User'; // or use 'username' based on your key
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.categoryName),
      //   backgroundColor: Colors.green,
      // ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.categoryName,
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
      // body: FutureBuilder<List<Details>>(
      //   future: _subcategoriesFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return _buildShimmerGrid();
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error loading subcategories'));
      //     }
      //
      //     final subcategories = snapshot.data ?? [];
      //
      //     return Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: GridView.builder(
      //         itemCount: subcategories.length,
      //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: 2,
      //           mainAxisSpacing: 10,
      //           crossAxisSpacing: 10,
      //           childAspectRatio: 0.9,
      //         ),
      //         itemBuilder: (context, index) {
      //           final sub = subcategories[index];
      //           return animalCard(
      //             context,
      //             sub.image ?? 'assets/images/gav.png',
      //             sub.subcategory,
      //             sub.id,
      //             isAdminProduct: sub.isAdminProduct,
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ),
      body: FutureBuilder<List<Details>>(
        future: _subcategoriesFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerGrid();
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 50, color: Colors.red[300]),
                  SizedBox(height: 16),
                  Text(
                    snapshot.error.toString().contains('No subcategories')
                        ? 'No subcategories available'
                        : 'Failed to load subcategories',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _subcategoriesFuture = ApiService.fetchSubCategories(widget.categoryId);
                      });
                    },
                    child: Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          // Empty state (should be caught by error now, but just in case)
          final subcategories = snapshot.data ?? [];
          if (subcategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 50, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text('No subcategories found', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          // Success state
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: subcategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
                  isAdminProduct: sub.isAdminProduct,
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
      BuildContext context, String imagePath, String label, String categoryId,
     {
      String isAdminProduct = "0",
     }
      ) {
    return InkWell(
      onTap: () async {
        debugPrint("Tapped ID: $categoryId | Admin Product: $isAdminProduct");
        debugPrint("SubCategory Tapped: ID = $categoryId");

        if (isAdminProduct == "1") {
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
      child:
      Card(
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
