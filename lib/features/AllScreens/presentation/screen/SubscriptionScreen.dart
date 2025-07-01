import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../ApiService/api_service.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../ApiService/api_service.dart';

/*
class SubscriptionScreen extends StatefulWidget {
  final int userId;

  const SubscriptionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionDetails? subscription;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSubscription();
  }

  Future<void> fetchSubscription() async {
    final url = ApiService.latestSubscription;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': widget.userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('API Response: ${response.body}');

        if (data['status'] == 'success' && data['details'] != null) {
          setState(() {
            subscription = SubscriptionDetails.fromJson(data['details']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'No subscription details found.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load subscription data.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('माझी सदस्यता',
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
      body: Stack(
        children: [
          // Background with blur
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/login_logo.png',
                    fit: BoxFit.fill,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          // Error or null subscription state
          else if (errorMessage.isNotEmpty || subscription == null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.subscriptions_outlined, size: 60, color: Colors.brown),
                  SizedBox(height: 16),
                  Text(
                    'सदस्यत्वाची कोणतीही माहिती आढळली नाही.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          // Subscription data
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: screenWidth > 600 ? 500 : double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.purple.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/login_logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildRow('Plan Name', subscription!.planName),
                                _buildRow('Start Date', subscription!.startDate),
                                _buildRow('End Date', subscription!.endDate),
                                _buildRow('Status', subscription!.status),
                                _buildRow('Post Limit', subscription!.postLimit),
                                _buildRow('Posts Used', subscription!.postUsed),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      // Stack(
      //   children: [
      //     Positioned.fill(
      //       child: ClipRRect(
      //         borderRadius: BorderRadius.circular(16),
      //         child: Stack(
      //           fit: StackFit.expand,
      //           children: [
      //             Image.asset(
      //               'assets/images/login_logo.png',
      //               fit: BoxFit.fill,
      //             ),
      //             BackdropFilter(
      //               filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      //               child: Container(color: Colors.transparent),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     isLoading
      //         ? const Center(child: CircularProgressIndicator())
      //         : errorMessage.isNotEmpty
      //         ? Center(child: Text('No subscription data found.'))
      //         : subscription == null
      //         ? const Center(child: Text('No subscription data found.'))
      //         : Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Center(
      //         child: SizedBox(
      //           width: screenWidth > 600 ? 500 : double.infinity,
      //           child: Card(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(16),
      //             ),
      //             elevation: 4,
      //             color: Colors.transparent,
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 gradient: LinearGradient(
      //                   colors: [
      //                     Colors.blue.shade400,
      //                     Colors.purple.shade400
      //                   ],
      //                   begin: Alignment.topLeft,
      //                   end: Alignment.bottomRight,
      //                 ),
      //                 borderRadius: BorderRadius.circular(16),
      //               ),
      //               child: Stack(
      //                 children: [
      //                   Positioned.fill(
      //                     child: Opacity(
      //                       opacity: 0.1,
      //                       child: ClipRRect(
      //                         borderRadius:
      //                         BorderRadius.circular(16),
      //                         child: Image.asset(
      //                           'assets/images/login_logo.png',
      //                           fit: BoxFit.cover,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.all(20.0),
      //                     child: Column(
      //                       crossAxisAlignment:
      //                       CrossAxisAlignment.start,
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         _buildRow('Plan Name',
      //                             subscription!.planName),
      //                         _buildRow('Start Date',
      //                             subscription!.startDate),
      //                         _buildRow('End Date',
      //                             subscription!.endDate),
      //                         _buildRow('Status',
      //                             subscription!.status),
      //                         _buildRow('Post Limit',
      //                             subscription!.postLimit),
      //                         _buildRow('Posts Used',
      //                             subscription!.postUsed),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

class SubscriptionScreen extends StatefulWidget {
  final int userId;

  const SubscriptionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionDetails? subscription;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSubscription();
  }

  Future<void> fetchSubscription() async {
    final url = ApiService.latestSubscription;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': widget.userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('API Response: ${response.body}');

        if (data['status'] == 'success' && data['details'] != null) {
          setState(() {
            subscription = SubscriptionDetails.fromJson(data['details']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'No subscription details found.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load subscription data.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('माझी सदस्यता',
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
      body: Stack(
        children: [
          // Blurred background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/login_logo.png',
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage.isNotEmpty || subscription == null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.subscriptions_outlined, size: 60, color: Colors.brown),
                  SizedBox(height: 16),
                  Text(
                    'सदस्यत्वाची कोणतीही माहिती आढळली नाही.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: screenWidth > 600 ? 400 : double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Plan Header Gradient
                        // Container(
                        //
                        //   width: double.infinity,
                        //   padding: const EdgeInsets.symmetric(vertical: 24),
                        //   decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        //     gradient: LinearGradient(
                        //       colors: [Color(0xFFFF6A00), Color(0xFFFFC800)],
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //     ),
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Text(
                        //         subscription!.planName.toUpperCase(),
                        //         style: const TextStyle(
                        //           fontSize: 22,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //       const SizedBox(height: 12),
                        //       Text(
                        //         '₹${subscription!.price}', // You can replace or add duration here
                        //
                        //         style: const TextStyle(
                        //           fontSize: 36,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //       const SizedBox(height: 4),
                        //       const Text(
                        //         'PER MONTH',
                        //         style: TextStyle(fontSize: 12, color: Colors.white),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Stack(
                          children: [
                            // 🔹 Background image
                            Positioned.fill(
                              child: ClipRRect(

                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  'assets/images/subcription_bg.jpg', // ✅ Replace with your actual image path
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // 🔸 Gradient + Content
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                               /* gradient: LinearGradient(
                                  colors: [Color(0xFFFF6A00), Color(0xFFFFC800)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),*/
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5), // ⬅️ White with opacity
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      subscription!.planName.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5), // ⬅️ White with opacity
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '₹${subscription!.price}',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'PER MONTH',
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _buildFeature('Start Date', subscription?.startDate),
                        _buildFeature('Start Date', subscription?.endDate),
                        // _buildFeature('Reason', subscription?.reason),

                        _buildFeature('Post Limit', subscription!.postLimit ),
                        _buildFeature('Posts Used', subscription!.postUsed),
                        _buildFeature('Status', subscription?.status, isAvailable: subscription?.status.toLowerCase() == 'active'),

                        if (subscription!.reason.trim().isNotEmpty)
                          _buildFeature('Reason', subscription?.reason, isAvailable: subscription?.reason.toLowerCase() == 'active'),

                        const SizedBox(height: 20),


                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildFeature(String label, String? value, {bool? isAvailable}) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAvailable != null) // ✅ show icon only when applicable
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                isAvailable ? Icons.check_circle : Icons.cancel,
                color: isAvailable ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

 /* Widget _buildFeature(String text, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            color: isAvailable ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }*/
}

class SubscriptionDetails {
  final String startDate;
  final String endDate;
  final String postLimit;
  final String postUsed;
  final String status;
  final String reason; // 🆕 Added
  final String planName;
  final String price; // 💰 Added earlier

  SubscriptionDetails({
    required this.startDate,
    required this.endDate,
    required this.postLimit,
    required this.postUsed,
    required this.status,
    required this.reason, // 🆕 Constructor
    required this.planName,
    required this.price,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      postLimit: json['post_limit']?.toString() ?? '0',
      postUsed: json['post_used']?.toString() ?? '0',
      status: json['status'] ?? '',
      reason: json['reason'] ?? '', // 🆕 from JSON
      planName: json['plan_name'] ?? '',
      price: json['price']?.toString() ?? '0',
    );
  }
}

