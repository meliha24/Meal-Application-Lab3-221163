// lib/services/my_firebase_messaging_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class MyFirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initializeNotifications() async {

    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final token = await _messaging.getToken();
    print("FCM TOKEN: $token");


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLog(message, "FOREGROUND");

      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription: 'Used for important alerts from the app.',
              icon: android.smallIcon,
            ),
          ),
          payload: message.data['screen'],
        );
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _showLog(message, "OPENED APP (TERMINATED/BACKGROUND)");

    });


  }

  static void handleMessage(RemoteMessage message, {bool isBackground = false}) {
    _showLog(message, isBackground ? "BACKGROUND" : "UNKNOWN");
  }

  static void _showLog(RemoteMessage message, String source) {
    print("===== $source MESSAGE =====");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Data: ${message.data}");
  }
}