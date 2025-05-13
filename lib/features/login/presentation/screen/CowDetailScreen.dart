import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CowDetailScreen extends StatelessWidget {
  final String image;
  final String price;

  const CowDetailScreen({required this.image, required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Important for gradient visibility
        leading: Container(
          margin: EdgeInsets.all(8),
          // decoration: BoxDecoration(
          //   color: Colors.brown,
          //   shape: BoxShape.circle,
          // ),
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


      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cow image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.share, color: Colors.black),
                      onPressed: () {
                        // Share action here
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            // Price
            Text(
              price,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            // Heading
            Text(
              'माहिती',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            // Description
            Text(
              'ही गाय उत्तम आरोग्यात असून दररोज सरासरी 10–12 लिटर दूध देते. तिचे नियमित लसीकरण केलेले आहे. गाय वयात 5 वर्षे, वेट 2 क्विंटलची आणि दूध उत्पादनासाठी उत्तम उपयोगी.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // WhatsApp action here
                    },
                    icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                    label: Text("व्हॉट्सअॅप चाट"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Phone call action here
                    },
                    icon: Icon(Icons.call),
                    label: Text("कॉल"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
