import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  final List<AppNotification> notifications;

  const NotificationScreen({super.key, required this.notifications});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<AppNotification> _allNotifications;

/*
  @override
  void initState() {
    super.initState();
    _allNotifications = [...widget.notifications];
    _allNotifications.sort((a, b) => b.receivedTime.compareTo(a.receivedTime));
  }
*/
  @override
  void initState() {
    super.initState();

    final seen = <String>{};
    _allNotifications = widget.notifications.where((n) {
      final key = '${n.title}-${n.cleanBody}';
      if (seen.contains(key)) return false;
      seen.add(key);
      return true;
    }).toList();

    // Sort: latest notification first
    _allNotifications.sort((a, b) => b.receivedTime.compareTo(a.receivedTime));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = constraints.maxWidth > 600 ? 24.0 : 12.0;

        return WillPopScope(
          onWillPop: () async {
            Navigator.popUntil(context, (route) => route.isFirst);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'नोटिफिकेशन्स',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
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
            body: _allNotifications.isEmpty
                ? const Center(child: Text('No notifications yet'))
                : Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ListView.builder(
                itemCount: _allNotifications.length,
                itemBuilder: (context, index) {
                  final notification = _allNotifications[index];
                  return _buildNotificationTile(
                    notification,
                    isViewed: notification.viewed,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationTile(AppNotification notification, {required bool isViewed}) {
    return GestureDetector(
      onTap: () {
        if (!isViewed) {
          setState(() {
            notification.viewed = true;
          });
        }

        if (notification.url != null && notification.url!.isNotEmpty) {
          _launchUrl(notification.url!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: isViewed ? Colors.brown : Color(0xFF6C311E),
              width: 6,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 9,
              offset: Offset(0, 8),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? 'No title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            if (notification.cleanBody != null)
              ..._buildTextWithLinks(notification.cleanBody!,
                  excludeUrl: notification.url),
            if (notification.url != null && notification.url!.isNotEmpty)
              _buildUrlWidget(notification.url!),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextWithLinks(String text, {String? excludeUrl}) {
    final widgets = <Widget>[];
    final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');
    final matches = urlRegExp.allMatches(text);
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        widgets.add(Text(text.substring(lastMatchEnd, match.start)));
      }

      final url = match.group(0)!;

      if (url != excludeUrl) {
        widgets.add(
          InkWell(
            onTap: () => _launchUrl(url),
            child: Text(
              url,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      widgets.add(Text(text.substring(lastMatchEnd)));
    }

    return widgets;
  }

  Widget _buildUrlWidget(String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: InkWell(
        onTap: () => _launchUrl(url),
        child: Text(
          url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/*
class NotificationScreen extends StatefulWidget {
  final List<AppNotification> notifications;

  const NotificationScreen({super.key, required this.notifications});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<AppNotification> _unviewedList;
  late List<AppNotification> _viewedList;

  @override
  void initState() {
    super.initState();
    _unviewedList =
        widget.notifications.where((n) => !n.viewed).toList(growable: true);
    _viewedList =
        widget.notifications.where((n) => n.viewed).toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = constraints.maxWidth > 600 ? 24.0 : 12.0;

        return WillPopScope(
          onWillPop: () async {
            Navigator.popUntil(context, (route) => route.isFirst);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'नोटिफिकेशन्स',
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
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
            body: _unviewedList.isEmpty && _viewedList.isEmpty
                ? const Center(child: Text('No notifications yet'))
                : Padding(
              padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ListView(
                children: [
                  if (_unviewedList.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 8),
                      child: Text('Unviewed',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    ..._unviewedList.map(
                            (n) => _buildNotificationTile(n, isViewed: false))
                  ],
                  if (_viewedList.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 24.0, bottom: 8),
                      child: Text('Viewed',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    ..._viewedList.map(
                            (n) => _buildNotificationTile(n, isViewed: true))
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationTile(AppNotification notification,
      {required bool isViewed}) {
    return GestureDetector(
      onTap: () {
        if (!isViewed) {
          setState(() {
            _unviewedList.remove(notification);
            notification.viewed = true;
            _viewedList.insert(0, notification); // optional: latest at top
          });
        }

        if (notification.url != null && notification.url!.isNotEmpty) {
          _launchUrl(notification.url!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border(
              left: BorderSide(
                  color: isViewed ? Colors.grey : Color(0xFF6C311E),
                  width: 6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 9,
              offset: Offset(0, 8),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? 'No title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            if (notification.cleanBody != null)
              ..._buildTextWithLinks(notification.cleanBody!,
                  excludeUrl: notification.url),
            if (notification.url != null && notification.url!.isNotEmpty)
              _buildUrlWidget(notification.url!),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextWithLinks(String text, {String? excludeUrl}) {
    final widgets = <Widget>[];
    final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');
    final matches = urlRegExp.allMatches(text);
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        widgets.add(Text(text.substring(lastMatchEnd, match.start)));
      }

      final url = match.group(0)!;

      if (url != excludeUrl) {
        widgets.add(
          InkWell(
            onTap: () => _launchUrl(url),
            child: Text(
              url,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      widgets.add(Text(text.substring(lastMatchEnd)));
    }

    return widgets;
  }

  Widget _buildUrlWidget(String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: InkWell(
        onTap: () => _launchUrl(url),
        child: Text(
          url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
*/



/*----------------------------------------------------------------------------------------------------*/

/*
class NotificationScreen extends StatefulWidget {
  final List<AppNotification> notifications;

  const NotificationScreen({super.key, required this.notifications});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late List<AppNotification> _unviewedList;
  late List<AppNotification> _viewedList;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _unviewedList = widget.notifications.where((n) => !n.viewed).toList(growable: true);
    _viewedList = widget.notifications.where((n) => n.viewed).toList(growable: true);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = constraints.maxWidth > 600 ? 24.0 : 12.0;

        return WillPopScope(
          onWillPop: () async {
            Navigator.popUntil(context, (route) => route.isFirst);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'Notifications',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
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
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Unviewed'),
                  Tab(text: 'Viewed'),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // Unviewed Tab
                _buildNotificationList(_unviewedList, isViewed: false, horizontalPadding: horizontalPadding),
                // Viewed Tab
                _buildNotificationList(_viewedList, isViewed: true, horizontalPadding: horizontalPadding),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationList(List<AppNotification> notifications, {required bool isViewed, required double horizontalPadding}) {
    return notifications.isEmpty
        ? const Center(child: Text('No notifications yet'))
        : Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ListView(
        children: notifications
            .map((n) => _buildNotificationTile(n, isViewed: isViewed))
            .toList(),
      ),
    );
  }

  Widget _buildNotificationTile(AppNotification notification, {required bool isViewed}) {
    return GestureDetector(
      onTap: () {
        if (!isViewed) {
          setState(() {
            _unviewedList.remove(notification);
            notification.viewed = true;
            _viewedList.insert(0, notification);
            // Switch to Viewed tab after marking as viewed
            _tabController.animateTo(1);
          });
        }

        if (notification.url != null && notification.url!.isNotEmpty) {
          _launchUrl(notification.url!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border(
              left: BorderSide(
                  color: isViewed ? Colors.grey : Color(0xFF6C311E),
                  width: 6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 9,
              offset: Offset(0, 8),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? 'No title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            if (notification.cleanBody != null)
              ..._buildTextWithLinks(notification.cleanBody!,
                  excludeUrl: notification.url),
            if (notification.url != null && notification.url!.isNotEmpty)
              _buildUrlWidget(notification.url!),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextWithLinks(String text, {String? excludeUrl}) {
    final widgets = <Widget>[];
    final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');
    final matches = urlRegExp.allMatches(text);
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        widgets.add(Text(text.substring(lastMatchEnd, match.start)));
      }

      final url = match.group(0)!;

      if (url != excludeUrl) {
        widgets.add(
          InkWell(
            onTap: () => _launchUrl(url),
            child: Text(
              url,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      widgets.add(Text(text.substring(lastMatchEnd)));
    }

    return widgets;
  }

  Widget _buildUrlWidget(String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: InkWell(
        onTap: () => _launchUrl(url),
        child: Text(
          url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

*/

// class _NotificationScreenState extends State<NotificationScreen> {
//   late List<AppNotification> _notificationList;
//
//   @override
//   void initState() {
//     super.initState();
//     _notificationList = List.from(widget.notifications);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double horizontalPadding = constraints.maxWidth > 600 ? 24.0 : 12.0;
//
//         return WillPopScope(
//           onWillPop: () async {
//             Navigator.popUntil(context, (route) => route.isFirst);
//             return false;
//           },
//           child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: const Text(
//                 'Notifications',
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               leading: const BackButton(color: Colors.black),
//               flexibleSpace: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF2E7D32), Color(0xFFFFFFFF)],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//               ),
//             ),
//             body: _notificationList.isEmpty
//                 ? const Center(child: Text('No notifications yet'))
//                 : Padding(
//
//               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//               child: ListView.builder(
//                 itemCount: _notificationList.length,
//                 itemBuilder: (context, index) {
//                   final notification = _notificationList[index];
//                   return Container(
//
//                     decoration: BoxDecoration(
//
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border(left: BorderSide(color: Color(0xFF6C311E), width: 6)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 9,
//                           offset: Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       notification.title ?? 'No title',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     if (notification.cleanBody != null)
//                                       ..._buildTextWithLinks(
//                                         notification.cleanBody!,
//                                         excludeUrl: notification.url,
//                                       ),
//                                     if (notification.url != null && notification.url!.isNotEmpty)
//                                       _buildUrlWidget(notification.url!),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               /*    Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     _formatTime(notification.receivedTime),
//                                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: Colors.red),
//                                     onPressed: () {
//                                       setState(() {
//                                         _notificationList.removeAt(index);
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),*/
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   List<Widget> _buildTextWithLinks(String text, {String? excludeUrl}) {
//     final widgets = <Widget>[];
//     final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');
//     final matches = urlRegExp.allMatches(text);
//     int lastMatchEnd = 0;
//
//     for (final match in matches) {
//       if (match.start > lastMatchEnd) {
//         widgets.add(Text(text.substring(lastMatchEnd, match.start)));
//       }
//
//       final url = match.group(0)!;
//
//       if (url != excludeUrl) {
//         widgets.add(
//           InkWell(
//             onTap: () => _launchUrl(url),
//             child: Text(
//               url,
//               style: const TextStyle(
//                 color: Colors.blue,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         );
//       }
//
//       lastMatchEnd = match.end;
//     }
//
//     if (lastMatchEnd < text.length) {
//       widgets.add(Text(text.substring(lastMatchEnd)));
//     }
//
//     return widgets;
//   }
//
//   Widget _buildUrlWidget(String url) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 4.0),
//       child: InkWell(
//         onTap: () => _launchUrl(url),
//         child: Text(
//           url,
//           style: const TextStyle(
//             color: Colors.blue,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _launchUrl(String url) async {
//     final uri = Uri.tryParse(url);
//     if (uri != null && await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   String _formatTime(DateTime time) {
//     return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
//   }
// }

