import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:smart_gawali/features/login/presentation/screen/MyCartScreen.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';
import '../../../ApiService/api_service.dart';


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
    var url =  ApiService.orderListUrl;
        // 'https://sks.sitsolutions.co.in/order_list';
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': 17}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<OrderItem> loadedOrders = (jsonData['details'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();

      setState(() {
        orders = loadedOrders;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      debugPrint('Failed to load orders: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('माझी खरेदी',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.shopping_cart, color: Colors.brown),
        //   ),
        // ],
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final orderDate = DateFormat('d MMM yyyy').format(
            DateTime.parse(order.createdAt),
          );

          return Card(
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
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => const Icon(
                            Icons.broken_image,
                            size: 60,
                            color: Colors.grey),
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
                            Text('रु. ${order.totalPrice}',
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
                      const Text('एकूण टाकसः ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(order.totalPrice),
                      const SizedBox(width: 16),
                      const Text('संख्या: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
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
