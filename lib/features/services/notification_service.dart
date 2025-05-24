

import 'dart:io';
// import 'package:shopping/screens/user-panel/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../NotificationScreen/notification_screen.dart';

// class NotificationService {
//   //initialising firebase message plugin
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   //initialising firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   //send notificartion request
//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appsetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }
//
// //Fetch FCM Token
//   Future<String> getDeviceToken() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     String? token = await messaging.getToken();
//     print("getDeviceTokentoken=> $token");
//     return token!;
//   }
//
//   //function to initialise flutter local notification plugin to show notifications for android when app is active
//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();
//
//     var initializationSetting = InitializationSettings(
//         android: androidInitializationSettings,
//         iOS: iosInitializationSettings);
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       handleMessage(context, message);
//     });
//   }
//
// //
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;
//
//       if (kDebugMode) {
//         print("notifications title:${notification!.title}");
//         print("notifications body:${notification.body}");
//         print('count:${android!.count}');
//         print('data:${message.data.toString()}');
//       }
//
//       if (Platform.isIOS) {
//         forgroundMessage();
//       }
//
//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//     });
//   }
//
//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // // when app is terminated
//     // RemoteMessage? initialMessage =
//     //     await FirebaseMessaging.instance.getInitialMessage();
//
//     // if (initialMessage != null) {
//     //   handleMessage(context, initialMessage);
//     // }
//
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//
//     // Handle terminated state
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (message != null && message.data.isNotEmpty) {
//         handleMessage(context, message);
//       }
//     });
//   }
//
//   // function to show visible notification when app is active
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.max,
//       showBadge: true,
//       playSound: true,
//       // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
//     );
//
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: 'your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//             playSound: true,
//             ticker: 'ticker',
//             sound: channel.sound
//             //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
//             //  icon: largeIconPath
//             );
//
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);
//
//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//         payload: 'my_data',
//       );
//     });
//   }
//
//   Future forgroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   // Add this list to store all notifications
//   List<AppNotification> notifications = [];
// // Modify the handleMessage to add to the list
//   Future<void> handleMessage(BuildContext context, RemoteMessage message) async {
//     // Add the new notification to the list
//     notifications.insert(0, AppNotification(
//       title: message.notification?.title,
//       body: message.notification?.body,
//     ));
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NotificationScreen(
//           message: message,
//           notifications: notifications,
//         ),
//       ),
//     );
//   }
//
//   /*Future<void> handleMessage(
//     BuildContext context,
//     RemoteMessage message,
//   ) async {
//     print(
//         "Navigating to appointments screen. Hit here to handle the message. Message data: ${message.data}");
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NotificationScreen(message: message),
//       ),
//     );
//
//     // if (message.data['screen'] == 'cart') {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => const CartScreen(),
//     //     ),
//     //   );
//     // } else {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => NotificationScreen(message: message),
//     //     ),
//     //   );
//     // }
//   }*/
// }
   ///          new code
class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;

  Future<void> initialize() async {
    await _setupLocalNotifications();
    requestNotificationPermission();
    await getDeviceToken();
  }

  void requestNotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();

    print("getDeviceTokentoken=> $token");
    return token ?? '';
  }

  void _addNotification(AppNotification notification) {
    final exists = _notifications.any((n) =>
    n.title == notification.title &&
        n.body == notification.body &&
        (n.receivedTime.difference(notification.receivedTime).inSeconds.abs() < 5));

    if (!exists) {
      _notifications.insert(0, notification);
    }
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      _addNotification(AppNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      ));

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }
  Future<void> setupInteractMessage(BuildContext context) async {
    // From terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _addNotification(AppNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      ));

      // Delay navigation to ensure the app is fully initialized
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NotificationScreen(
              message: initialMessage,
              notifications: _notifications,
            ),
          ),
              (route) => route.isFirst,
        );
      });
    }

    // From background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _addNotification(AppNotification(
        title: event.notification?.title,
        body: event.notification?.body,
      ));

      // Use pushAndRemoveUntil to prevent duplicate screens
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NotificationScreen(
              message: event,
              notifications: _notifications,
            ),
          ),
              (route) => route.isFirst,
        );
      });
    });
  }
  // Future<void> setupInteractMessage(BuildContext context) async {
  //   // From terminated state
  //   RemoteMessage? initialMessage =
  //   await FirebaseMessaging.instance.getInitialMessage();
  //   if (initialMessage != null) {
  //     _addNotification(AppNotification(
  //       title: initialMessage.notification?.title,
  //       body: initialMessage.notification?.body,
  //     ));
  //   }
  //
  //   // From background
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     _addNotification(AppNotification(
  //       title: event.notification?.title,
  //       body: event.notification?.body,
  //     ));
  //     handleMessage(context, event);
  //   });
  // }

  Future<void> initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification?.android?.channelId ?? 'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  Future<void> handleMessage(BuildContext context, RemoteMessage message) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(
          message: message,
          notifications: _notifications,
        ),
      ),
          (route) => route.isFirst,
    );
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }
}
