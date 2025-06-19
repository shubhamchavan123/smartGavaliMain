import 'package:flutter/material.dart';

import 'CowDetailScreen.dart';



class HirvaCharaListingScreen extends StatelessWidget {
  final List<Map<String, String>> cowData = [
    {'image': 'assets/images/chara.png', 'price': 'रु.30,000'},
    {'image': 'assets/images/chara.png', 'price': 'रु.40,000'},
    {'image': 'assets/images/chara.png', 'price': 'रु.45,000'},
    {'image': 'assets/images/chara.png', 'price': 'रु.50,000'},
    {'image': 'assets/images/chara.png', 'price': 'रु.55,000'},
    {'image': 'assets/images/chara.png', 'price': 'रु.60,000'},
    {'image': 'assets/images/chara.png', 'price': 'रु.65,000'},
    {'image': 'assets/images/chara.png', 'price': 'रु.70,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Important for gradient visibility
        title: Text(
          ' हिरवा चारा',
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
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {},
            ),
          ),
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
                  return CowCard(image: cow['image']!, price: cow['price']!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CowCard extends StatelessWidget {
  final String image;
  final String price;

  const CowCard({required this.image, required this.price});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CowDetailScreen(image: image, price: price),
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
