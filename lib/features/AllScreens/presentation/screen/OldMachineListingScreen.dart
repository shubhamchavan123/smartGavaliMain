import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/OldMachineDetailScreen.dart';

import '../../../../provider/calcium_mineral_product_provider.dart';
import 'CowDetailScreen.dart';
import 'MyCartScreen.dart';



class OldMachineListingScreen extends StatelessWidget {
  final List<Map<String, String>> cowData = [
    {'image': 'assets/images/machine.png', 'price': 'रु.30,000'},
    {'image': 'assets/images/machine.png', 'price': 'रु.40,000'},
    {'image': 'assets/images/machine.png', 'price': 'रु.45,000'},
    {'image': 'assets/images/machine.png', 'price': 'रु.50,000'},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Important for gradient visibility
        title: Text(
          ' जुने मशीन्स ',
          style: TextStyle(
            color: Colors.black, // Title color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            child: Consumer<CalciumMineralProductProvider>(
              builder: (context, provider, _) {
                // final cartCount = provider.selectedProducts.fold<int>(
                //   0,
                //       (sum, product) => sum + provider.getQuantity(product),
                // );
// To this (counts unique products instead of quantities):
                final cartCount = provider.selectedProducts.length;
                // final cartCount = provider.quantities.values.fold<int>(
                //   0,
                //       (sum, quantity) => sum + quantity,
                // );
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon:
                      const Icon(Icons.shopping_cart, color: Colors.white),


                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCartScreen()),
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
              colors: [
                Color(0xFF2E7D32), // Green at top
                Color(0xFFFFFFFF), // White at bottom
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: cowData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final cow = cowData[index];
                  return OldCard(image: cow['image']!, price: cow['price']!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OldCard extends StatelessWidget {
  final String image;
  final String price;

  const OldCard({required this.image, required this.price});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OldMachineDetailScreen(image: image, price: price),
          ),
        );
      },
      child: Card(
        elevation: 3,
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey.shade200,
              child: Text(
                price,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
