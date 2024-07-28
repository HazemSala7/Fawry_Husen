import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_notification_service.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('type')) {
    final type = message.data['type'];
    // Handle data message based on type
    // You can perform background operations or save to local storage here
  }

  // Handle notification message
  if (message.notification != null) {
    // Perform actions based on notification details if needed
  }
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  Future<void> sendNotification() async {
    await FirebaseMessaging.instance.subscribeToTopic('topic_name');

    await FirebaseMessaging.instance.sendMessage(
      data: {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'type': 'sales', // Example type
        'id': '1',
        'status': 'done',
      },
    );
  }

  void _navigateBasedOnNotification(
      BuildContext context, Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'sales':
        Navigator.pushNamed(context, '/sales');
        break;
      case 'order_status':
        Navigator.pushNamed(context, '/order_status');
        break;
      case 'product':
        Navigator.pushNamed(context, '/product_details',
            arguments: {'productId': data['productId']});
        break;
      default:
        break;
    }
  }

  setNotifications(BuildContext context) async {
    LocalNotificationService.initialize(context);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _navigateBasedOnNotification(context, message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationService.display(message);
        // Handle foreground notification
        print(message.notification!.body);
        print(message.notification!.title);
        // Add logic to navigate to page if needed
        // You might use local state or other mechanisms here
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateBasedOnNotification(context, message.data);
    });

    final token = await _firebaseMessaging.getToken();
    print("token");
    print(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_token', token.toString());
  }

  void dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
