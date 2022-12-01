import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestPermission();
      // _firebaseMessaging.requestNotificationPermissions();
      // _firebaseMessaging.configure();
      // _firebaseMessaging.

      String? token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      //configure firebase messaging on
      FirebaseMessaging.onMessage.listen((event) {
        pushStreamController.add(event.data);
      });
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      // FirebaseMessaging.onBackgroundMessage(
      //     _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print("onMessageOpenedApp: ${event.messageId}");
      });
      // _firebaseMessaging.configure(
      //   onMessage: (Map<String, dynamic> message) async {
      //     print("onMessage: $message");
      //     //_showItemDialog(message);
      //     pushStreamController.add(message);
      //   },
      //   onBackgroundMessage: myBackgroundMessageHandler,
      //   onLaunch: (Map<String, dynamic> message) async {
      //     print("onLaunch: $message");
      //     //_navigateToItemDetail(message);
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     print("onResume: $message");
      //     //_navigateToItemDetail(message);
      //   },
      // );

      _initialized = true;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  myBackgroundMessageHandler(message.data);
  print("Handling a background message: ${message.messageId}");
}
