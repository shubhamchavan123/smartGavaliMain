import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/MyCartScreen.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';
import '../../../ApiService/api_service.dart';

/*
class MyPurchaseScreen extends StatefulWidget {
  const MyPurchaseScreen({super.key});

  @override
  State<MyPurchaseScreen> createState() => _MyPurchaseScreenState();
}

class _MyPurchaseScreenState extends State<MyPurchaseScreen> {
  List<OrderItem> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    var url = ApiService.orderListUrl;
    // 'https://sks.sitsolutions.co.in/order_list';
    final prefs = await SharedPreferences.getInstance();

    // Retrieve saved user_id
    final userId = prefs.getString('user_id') ?? '0';
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['details'] != null && jsonData['details'] is List) {
        final List<OrderItem> loadedOrders = (jsonData['details'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList();

        setState(() {
          orders = loadedOrders;
          isLoading = false;
        });
      } else {
        setState(() {
          orders = [];
          isLoading = false;
        });
        debugPrint(
            'No orders found or unexpected format: ${jsonData['details']}');
      }
    } else {
      setState(() => isLoading = false);
      debugPrint('Failed to load orders: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('माझी खरेदी',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
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
          : orders.isEmpty
          ? RefreshIndicator(
        onRefresh: fetchOrders,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shopping_bag_outlined,
                  size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'आपल्या खात्यात अजून कोणतीही खरेदी नाही.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )

          : RefreshIndicator(
        onRefresh: fetchOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final orderDate = DateFormat('d MMM yyyy').format(
              DateTime.parse(order.createdAt),
            );

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderDate,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('ऑर्डर आयडी ${order.orderNo}',
                        style: const TextStyle(color: Colors.grey)),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Image.network(
                          order.productImage,
                          height: 60,
                          width: 60,
                          fit: BoxFit.fill,
                          errorBuilder: (context, _, __) =>
                          const Icon(Icons.broken_image,
                              size: 60, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('उत्पादन',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('रु. ${order.price}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('एकूण टोटल ',
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        Text(order.totalPrice),
                        const SizedBox(width: 16),
                        const Text('उत्पादन संख्या: ',
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        Text(order.quantity),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order.status == 'Delivered'
                                ? Colors.green.shade100
                                : order.status == 'In Progress'
                                ? Colors.blue.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                                color: order.status == 'Delivered'
                                    ? Colors.green
                                    : order.status == 'In Progress'
                                    ? Colors.blue
                                    : Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),


    );
  }
}
*/

class MyPurchaseScreen extends StatefulWidget {
  const MyPurchaseScreen({super.key});

  @override
  State<MyPurchaseScreen> createState() => _MyPurchaseScreenState();
}

class _MyPurchaseScreenState extends State<MyPurchaseScreen> {
  List<OrderItem> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    var url = ApiService.orderListUrl;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '0';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['details'] != null && jsonData['details'] is List) {
        final List<OrderItem> loadedOrders = (jsonData['details'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList();

        setState(() {
          orders = loadedOrders;
          isLoading = false;
        });
      } else {
        setState(() {
          orders = [];
          isLoading = false;
        });
        debugPrint('No orders found or unexpected format: ${jsonData['details']}');
      }
    } else {
      setState(() => isLoading = false);
      debugPrint('Failed to load orders: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('माझी खरेदी',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
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
          : orders.isEmpty
          ? RefreshIndicator(
        onRefresh: fetchOrders,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shopping_bag_outlined,
                  size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'आपल्या खात्यात अजून कोणतीही खरेदी नाही.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final orderDate = DateFormat('d MMM yyyy')
                .format(DateTime.parse(order.createdAt));

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderDate,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                     Divider(height: 16),
                    const SizedBox(height: 4),
                    Text('ऑर्डर आयडी ${order.orderNo}',
                        style: const TextStyle(color: Colors.grey)),
                     Divider(height: 16),
                    Row(
                      children: [
                        Image.network(
                          order.productImage,
                          height: 90,
                          width: 90,
                          fit: BoxFit.fill,
                          errorBuilder: (context, _, __) =>
                          const Icon(Icons.broken_image,
                              size: 60, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.productName.isNotEmpty ? order.productName : 'उत्पादनाचे नाव', // Default name in Marathi
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),
                              Text('रु. ${order.price}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black87)),
                              Row(
                                children: [
                                  Text('उत्पादन संख्या: ',
                                      style: TextStyle( fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text(order.quantity),
                                ],
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(height: 16),
                    Row(
                      children: [
                        const Text('एकूण रक्कम : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(order.totalPrice,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        const SizedBox(width: 16),

                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order.status == 'Delivered'
                                ? Colors.green.shade100
                                : order.status == 'In Progress'
                                ? Colors.blue.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                                color: order.status == 'Delivered'
                                    ? Colors.green
                                    : order.status == 'In Progress'
                                    ? Colors.blue
                                    : Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderItem {
  final String id;
  final String orderNo;
  final String userId;
  final String productId;
  final String productName; // ✅ New field
  final String quantity;
  final String price;
  final String totalPrice;
  final String address;
  final String orderType;
  final String status;
  final String createdAt;
  final String productImage;

  OrderItem({
    required this.id,
    required this.orderNo,
    required this.userId,
    required this.productId,
    required this.productName, // ✅
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.address,
    required this.orderType,
    required this.status,
    required this.createdAt,
    required this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      orderNo: json['order_no'] ?? '',
      userId: json['user_id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '', // ✅
      quantity: json['quantity'] ?? '0',
      price: json['price'] ?? '0',
      totalPrice: json['total_price'] ?? '0',
      address: json['address'] ?? '',
      orderType: json['order_type'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      productImage: json['product_image'] ?? '',
    );
  }
}

/*
class OrderItem {
  final String orderNo;
  final String productImage;
  final String totalPrice;
  final String quantity;
  final String status;
  final String createdAt;

  OrderItem({
    required this.orderNo,
    required this.productImage,
    required this.totalPrice,
    required this.quantity,
    required this.status,
    required this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderNo: json['order_no'] ?? '',
      productImage: json['product_image'] ?? '',
      totalPrice: json['total_price'] ?? '0',
      quantity: json['quantity'] ?? '0',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
*/
