import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_gawali/features/AllScreens/presentation/screen/MyPostScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPostDetailScreen extends StatefulWidget {
  final PostDetail post;

  const MyPostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<MyPostDetailScreen> createState() => _MyPostDetailScreenState();
}

class _MyPostDetailScreenState extends State<MyPostDetailScreen> {

  final PageController _pageController = PageController(viewportFraction: 0.9);
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final createdAt = DateTime.tryParse(widget.post.createdAt) ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'पोस्टची माहिती',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.post.photo.isNotEmpty)
              // SizedBox(
              //   height: 250,
              //   child: PageView.builder(
              //     itemCount: post.photo.length,
              //     controller: PageController(viewportFraction: 0.9),
              //     itemBuilder: (context, index) {
              //       final imageUrl = post.photo[index];
              //       print('Image URL at index $index: $imageUrl'); // 🔍 Debug print
              //
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
              //         child: Container(
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.green, width: 3),
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(12),
              //             child: Image.network(
              //               imageUrl,
              //               width: double.infinity,
              //               height: 250,
              //               fit: BoxFit.cover,
              //               loadingBuilder: (context, child, loadingProgress) {
              //                 if (loadingProgress == null) return child;
              //                 return Container(
              //                   color: Colors.grey[200],
              //                   child: const Center(child: CircularProgressIndicator()),
              //                 );
              //               },
              //               errorBuilder: (context, error, stackTrace) => Container(
              //                 color: Colors.grey[300],
              //                 child: const Center(
              //                   child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      itemCount: widget.post.photo.length,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        final imageUrl = widget.post.photo[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(child: CircularProgressIndicator()),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.post.photo.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                      activeDotColor: Colors.green,
                      dotColor: Colors.grey,
                    ),
                  ),
                ],
              ),


            const SizedBox(height: 20),

            _buildSectionTitle('मूलभूत माहिती'),
            _buildInfoRow('कॅटेगरी', widget.post.categoryName ?? widget.post.catId),

            if (widget.post.subcategoryName != null && widget.post.subcategoryName!.trim().isNotEmpty)
              _buildInfoRow('सब कॅटेगरी', widget.post.subcategoryName!)
            else if (widget.post.subcategory != null && !RegExp(r'^\d+$').hasMatch(widget.post.subcategory!))
              _buildInfoRow('सब कॅटेगरी', widget.post.subcategory!),

            if (widget.post.childSubcategory != null &&
                widget.post.childSubcategory!.trim().isNotEmpty &&
                !RegExp(r'^\d+$').hasMatch(widget.post.childSubcategory!))
              _buildInfoRow('उप-श्रेणी', widget.post.childSubcategory!), // Translated "Child Subcategory"

            _buildInfoRow('पोस्ट केलेल्या तारीख', dateFormat.format(createdAt)), // Translated "Posted On"
            const Divider(height: 30),

            _buildSectionTitle(widget.post.categoryName?.contains('पशु') == true
                ? 'पशूची माहिती' // Translated "Animal Details"
                : 'उत्पादनाची माहिती'), // Translated "Product Details"

            if (widget.post.name != null)
              _buildInfoRow('नाव', widget.post.name!), // Translated "Name"
            if (widget.post.price != null)
              _buildInfoRow('किंमत', '₹${widget.post.price}'),
            if (widget.post.age != null)
              _buildInfoRow('वय', '${widget.post.age} वर्षे'),
            if (widget.post.weight != null)
              _buildInfoRow('वजन', '${widget.post.weight} ${widget.post.unit ?? ''}'),
            if (widget.post.milk != null)
              _buildInfoRow('दुधाची उत्पादन', widget.post.milk!), // Milk Production
            if (widget.post.isGhabhan == '1')
              _buildInfoRow('गाभण',
                  widget.post.ghabhanMonth != null ? 'हो (${widget.post.ghabhanMonth} महिने)' : 'हो'),
            if (widget.post.vet != null)
              _buildInfoRow('पशुवैद्यकीय माहिती', widget.post.vet!),
            if (widget.post.useYear != null)
              _buildInfoRow('वापराची वर्षे', widget.post.useYear!),
            const Divider(height: 30),

            _buildSectionTitle('विक्रेत्याची माहिती'), // Seller Information
            if (widget.post.shopName != null)
              _buildInfoRow('दुकानाचे नाव', widget.post.shopName!),
            if (widget.post.address != null)
              _buildInfoRow('पत्ता', widget.post.address!),
            const Divider(height: 30),

            if (widget.post.description != null) ...[
              _buildSectionTitle('वर्णन'), // Description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.post.description!,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
              const Divider(height: 30),
            ],


            // _buildSectionTitle('Additional Information'),
            // _buildInfoRow('Status', post.status == '1' ? 'Active' : 'Inactive'),
            // _buildInfoRow('Views', post.views),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text('Call Now',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    await _makePhoneCall(context, widget.post.mobile);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(value.isNotEmpty ? value : 'Not specified', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
          ),
        ],
      ),
    );
  }
}

Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
  final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
  final urlsToTry = [
    'tel:$cleanedNumber',
    'tel://$cleanedNumber',
    'telprompt:$cleanedNumber'
  ];

  for (final url in urlsToTry) {
    try {
      if (await canLaunch(url)) {
        await launch(url);
        return;
      }
    } catch (e) {
      continue;
    }
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not launch dialer')),
    );
  }
}

