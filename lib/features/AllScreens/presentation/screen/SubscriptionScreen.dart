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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : subscription == null
              ? const Center(child: Text('No subscription data found.'))
              : Padding(
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
                        colors: [
                          Colors.blue.shade400,
                          Colors.purple.shade400
                        ],
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
                              borderRadius:
                              BorderRadius.circular(16),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildRow('Plan Name',
                                  subscription!.planName),
                              _buildRow('Start Date',
                                  subscription!.startDate),
                              _buildRow('End Date',
                                  subscription!.endDate),
                              _buildRow('Status',
                                  subscription!.status),
                              _buildRow('Post Limit',
                                  subscription!.postLimit),
                              _buildRow('Posts Used',
                                  subscription!.postUsed),
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

class SubscriptionDetails {
  final String startDate;
  final String endDate;
  final String postLimit;
  final String postUsed;
  final String status;
  final String planName;

  SubscriptionDetails({
    required this.startDate,
    required this.endDate,
    required this.postLimit,
    required this.postUsed,
    required this.status,
    required this.planName,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      postLimit: json['post_limit']?.toString() ?? '0',
      postUsed: json['post_used']?.toString() ?? '0',
      status: json['status'] ?? '',
      planName: json['plan_name'] ?? '',
    );
  }
}

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
    // Uri.parse('https://sks.sitsolutions.co.in/latest_subscription');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': widget.userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            subscription = SubscriptionDetails.fromJson(data['details']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Unknown error';
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
        title: const Text('My Subscription',
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
          // 🌄 Background image for the whole screen
          Positioned.fill(
            child: ClipRRect( // Optional: use this if you need rounded corners
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/login_logo.png',
                    fit: BoxFit.fill,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Adjust blur strength
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 🔲 Foreground content
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : subscription == null
              ? const Center(child: Text('No subscription data found.'))
              : Padding(
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
                        // 🔲 Watermark inside the card
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
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with fixed width
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
class SubscriptionDetails {
  final String startDate;
  final String endDate;
  final String postLimit;
  final String postUsed;
  final String status;
  final String planName;

  SubscriptionDetails({
    required this.startDate,
    required this.endDate,
    required this.postLimit,
    required this.postUsed,
    required this.status,
    required this.planName,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      startDate: json['start_date'],
      endDate: json['end_date'],
      postLimit: json['post_limit'],
      postUsed: json['post_used'],
      status: json['status'],
      planName: json['plan_name'],
    );
  }
}
*/
