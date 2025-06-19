

import 'dart:io';
// import 'package:shopping/screens/user-panel/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ApiService/api_service.dart';
import '../NotificationScreen/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

import 'dart:io';

import 'package:url_launcher/url_launcher.dart';





import 'package:http/http.dart' as http;
import 'dart:convert';






class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;

  Future<void> initialize() async {
    await _setupLocalNotifications();
    await requestNotificationPermission();

    String token = await getDeviceToken();

    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');
    if (userId != null && userId.isNotEmpty && token.isNotEmpty) {
      await _updateDeviceTokenToServer(userId, token);
    }

    await fetchNotificationsFromServer();
  }

  Future<void> requestNotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("📱 Device Token: $token");

    if (token != null && token.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_token', token);
      print("💾 Token saved to SharedPreferences");
    }

    return token ?? '';
  }

  Future<void> _updateDeviceTokenToServer(String userId, String token) async {
    final Uri url = ApiService.tokenUpdate;
    // Uri.parse('https://sks.sitsolutions.co.in/token_update');

    print('📤 Attempting to update device token to server...');
    print('➡️ URL: $url');
    print('➡️ Payload: user_id = $userId, token = $token');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': int.parse(userId),
          'token': token,
        }),
      );

      print('🔁 Response Status: ${response.statusCode}');
      print('🔁 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          print('✅ Token Updated on Server');
        } else {
          print('⚠️ Token Update Failed: ${data['message']}');
        }
      } else {
        print('❌ Token Update API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception while updating token: $e');
    }
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print("📥 Foreground Notification Received: ${message.toMap()}");
      final rawBody = message.notification?.body ?? message.data['content'] ?? '';
      final cleanBody = _cleanHtmlContent(rawBody);

      _addNotification(AppNotification(
        title: message.notification?.title,
        body: cleanBody,
        cleanBody: cleanBody,
        url: message.data['url'],
        receivedTime: DateTime.now(),
      ));

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotificationWithCleanBody(message, cleanBody);
      }
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotification(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotification(context, message);
    });
  }

  void _handleNotification(BuildContext context, RemoteMessage message) {
    final rawBody = message.notification?.body ?? message.data['content'] ?? '';
    final cleanBody = _cleanHtmlContent(rawBody);

    _addNotification(AppNotification(
      title: message.notification?.title ?? message.data['title'],
      body: cleanBody,
      cleanBody: cleanBody,
      url: message.data['url'],
      receivedTime: DateTime.now(),
    ));

    if (message.data['url'] != null && message.data['url'].isNotEmpty) {
      launchUrl(Uri.parse(message.data['url']), mode: LaunchMode.externalApplication);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NotificationScreen(notifications: _notifications),
        ),
      );
    }
  }

  void _addNotification(AppNotification notification) {
    final exists = _notifications.any((n) =>
    n.title == notification.title &&
        n.cleanBody == notification.cleanBody &&
        (n.receivedTime.difference(notification.receivedTime).inSeconds.abs() < 5));

    if (!exists) {
      _notifications.insert(0, notification);
    }
  }

  Future<void> fetchNotificationsFromServer() async {
    try {
      final response = await http.get(
          ApiService.notificationList,
        // Uri.parse('https://sks.sitsolutions.co.in/notification_list'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          List<dynamic> details = jsonData['details'];
          for (var item in details) {
            _notifications.add(AppNotification.fromJson(item));
          }
        }
      }
    } catch (e) {
      print("❌ Error fetching notifications: $e");
    }
  }

  String _cleanHtmlContent(String htmlContent) {
    return htmlContent
        .replaceAll('<p>', '')
        .replaceAll('</p>', '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();
  }

  Future<void> initLocalNotifications(BuildContext context, RemoteMessage message) async {
    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        handleMessage(context, message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    final rawBody = message.notification?.body ?? message.data['content'] ?? '';
    final cleanBody = _cleanHtmlContent(rawBody);
    await showNotificationWithCleanBody(message, cleanBody);
  }

  Future<void> showNotificationWithCleanBody(RemoteMessage message, String cleanBody) async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification?.android?.channelId ?? 'default_channel',
      'Notifications',
      importance: Importance.max,
    );

    final String title = message.notification?.title ?? 'New Notification';
    final String url = message.data['url'] ?? '';

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: 'Channel for important notifications',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(cleanBody),
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      cleanBody,
      notificationDetails,
      payload: url,
    );
  }

  Future<void> handleMessage(BuildContext context, RemoteMessage message) async {
    final url = message.data['url'];
    if (url != null && url.isNotEmpty) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => NotificationScreen(notifications: _notifications),
        ),
            (route) => route.isFirst,
      );
    }
  }

  Future<void> _setupLocalNotifications() async {
    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          launchUrl(Uri.parse(response.payload!), mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}



class AppNotification {
  final String? title;
  final String? body;
  final String? cleanBody;
  final String? url;
  final DateTime receivedTime;
  bool viewed; // <-- NEW field to track view status

  AppNotification({
    required this.title,
    required this.body,
    required this.cleanBody,
    required this.url,
    required this.receivedTime,
    this.viewed = false, // <-- default to false (unviewed)
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    String htmlContent = json['content'] ?? '';
    String cleanContent = _cleanHtmlContent(htmlContent);

    return AppNotification(
      title: json['name'],
      body: cleanContent,
      cleanBody: cleanContent,
      url: _extractUrlFromHtml(htmlContent),
      receivedTime: DateTime.now(),
      viewed: json['viewed'] ?? false, // ensure it's never null
    );
  }

  static String _cleanHtmlContent(String htmlContent) {
    return htmlContent
        .replaceAll('<p>', '')
        .replaceAll('</p>', '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();
  }

  static String? _extractUrlFromHtml(String htmlContent) {
    final match = RegExp(r'https?:\/\/[^\s<"]+').firstMatch(htmlContent);
    return match?.group(0);
  }
}






