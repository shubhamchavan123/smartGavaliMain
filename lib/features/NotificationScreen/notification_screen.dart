// ignore: depend_on_referenced_packages
// ignore_for_file: await_only_futures, avoid_single_cascade_in_expression_statements, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class NotificationScreen extends StatelessWidget {
//   // If you sometimes still want to show details of a specific RemoteMessage,
//   // you can accept it as an *optional* parameter:
//   final RemoteMessage? message;
//
//   const NotificationScreen({ Key? key, this.message }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final title = message?.notification?.title ?? 'Your Notifications';
//     final body  = message?.notification?.body  ?? 'Tap on any notification below.';
//     // You might instead load a list of past notifications from your app's storage.
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Notifications')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Optional header for the one tapped notification
//             Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (message != null) SizedBox(height: 8),
//             if (message != null) Text(body),
//
//             Divider(height: 32),
//
//             // TODO: replace with your real list of notifications
//             Expanded(
//               child: Center(child: Text('No other notifications yet.')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class AppNotification {
  final String? title;
  final String? body;
  final DateTime receivedTime;

  AppNotification({
    this.title,
    this.body,
    DateTime? receivedTime,
  }) : receivedTime = receivedTime ?? DateTime.now();
}


class NotificationScreen extends StatelessWidget {
  final RemoteMessage? message;
  final List<AppNotification> notifications;

  const NotificationScreen({
    Key? key,
    this.message,
    required this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Optionally clear notifications
              },
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
        child: Text(
          'No notifications yet',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                notification.title ?? 'No title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notification.body ?? 'No content'),
              trailing: Text(
                _formatTime(notification.receivedTime),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// class NotificationScreen extends StatelessWidget {
//   final RemoteMessage? message;
//   final List<AppNotification> notifications;
//
//   const NotificationScreen({
//     Key? key,
//     this.message,
//     required this.notifications,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final title = message?.notification?.title ?? 'Your Notifications';
//     final body = message?.notification?.body ?? 'Tap on any notification below.';
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Notifications')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Optional header for the one tapped notification
//             Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (message != null) SizedBox(height: 8),
//             if (message != null) Text(body),
//
//             Divider(height: 32),
//
//             // List of all notifications
//             Expanded(
//               child: notifications.isEmpty
//                   ? Center(child: Text('No notifications yet.'))
//                   : ListView.builder(
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   final notification = notifications[index];
//                   return Card(
//                     margin: EdgeInsets.only(bottom: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (notification.title != null)
//                             Text(
//                               notification.title!,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           if (notification.title != null) SizedBox(height: 4),
//                           if (notification.body != null) Text(notification.body!),
//                           SizedBox(height: 8),
//                           Text(
//                             _formatTime(notification.receivedTime),
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(DateTime time) {
//     return '${time.hour}:${time.minute.toString().padLeft(2, '0')} · ${time.day}/${time.month}/${time.year}';
//   }
// }
/*

class NotificationScreen extends StatefulWidget {
  final RemoteMessage? message;
  const NotificationScreen({super.key, this.message});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Notifications"),
      ),
      // body: widget.message != null
      //     ? Card(
      //         elevation: 5,
      //         child: ListTile(
      //           leading: const Icon(Icons.notifications_active),
      //           title:
      //               Text(widget.message!.notification!.title.toString() ?? ''),
      //           subtitle: Text(widget.message!.notification!.body.toString()),
      //           trailing: Text(widget.message!.data['screen'].toString()),
      //         ),
      //       )
      //     : const Center(
      //         child: Text("no Notifications"),
      //       ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(user!.uid)
            .collection('notifications')
            // .where('isSale', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No notifications found!"),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String docId = snapshot.data!.docs[index].id;
                return GestureDetector(
                  onTap: () async {
                    print("Docid => $docId");
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(user!.uid)
                        .collection('notifications')
                        .doc(docId)
                        .update(
                      {
                        "isSeen": true,
                      },
                    );
                  },
                  child: Card(
                    color: snapshot.data!.docs[index]['isSeen']
                        ? Colors.green.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                    elevation: snapshot.data!.docs[index]['isSeen'] ? 0 : 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(snapshot.data!.docs[index]['isSeen']
                            ? Icons.done
                            : Icons.notification_add),
                      ),
                      title: Text(snapshot.data!.docs[index]['title']),
                      subtitle: Text(snapshot.data!.docs[index]['body']),
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
*/
