import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // print('Handling a background message: ${message.messageId}');
  }

  static Future<void> initNotifications() async {
    await Firebase.initializeApp();

    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Foreground message: ${message.notification?.title}');
    });

    // Notification opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('Notification clicked: ${message.notification?.title}');
    });

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<String?> getFcmToken() async {
    return await _messaging.getToken();
  }
}