/* Callback event on tapping notification */
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student_grading_app/firebase_options.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/student_grading_listview.dart';

void notificationTapBackground(NotificationResponse notificationResponse) {
  print("notificationTapBackground");
  SgNavigation().push(StudentGradingListView());
}

FlutterLocalNotificationsPlugin? localNotificationsPlugin;

class FirebaseMessagingManager {

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    /* Request permissions on app start */
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      alert: true,
      carPlay: true,
      criticalAlert: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      sound: true,
      alert: true,
      badge: true,
    );

    localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /* Create notification channels for iOS and Android */
    const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
      'student_grading',
      'student_detail',
      importance: Importance.high,
    );

    var initializationSettingsAndroid = const
    AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();

    /* Setup initialization settings */
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    localNotificationsPlugin!.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (str) {
        Map<String, dynamic> data = json.decode(str.payload!);
        handleClick(data);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    /* Event gets fired when it receives background payload */
    FirebaseMessaging.onBackgroundMessage(notificationHandler);

    FirebaseMessaging.onMessage.listen((message) {
      _notificationsHandler(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {

      Future.delayed(const Duration(milliseconds: 300), () {
        if (message != null) {
          debugPrint('background app');
          handleClick(message.data);
        }
      });
    });

    FirebaseMessaging.instance.getInitialMessage()
        .then((RemoteMessage? message) async {

      Future.delayed(const Duration(milliseconds: 300), () {
        if (message != null) {
          debugPrint("background notification ${message.data.toString()}");
          handleClick(message.data);
        }
      });
    });

    /* Getting the generated token from Firebase */
    getToken();
  }

  Future<String?> getToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint("Firebase token $token");
      return token;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void handleClick(Map<String, dynamic> data) {
    SgNavigation().push(StudentGradingListView());
  }

  /* Display notification once a payload received */
  Future<void> _notificationsHandler(RemoteMessage message) async {
    RemoteNotification notification = message.notification ?? const RemoteNotification();

    if (notification.title != null && notification.body != null) {
      _displayNotification(message);
    }
  }

  Future<void> _displayNotification(RemoteMessage message) async {
    RemoteNotification data = message.notification ?? const RemoteNotification();

    /* Configuring specifics for Android and iOS */
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Student Grading', 'student',
        importance: Importance.max,
        playSound: true,
        channelDescription: 'description',
        icon: 'mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(data.body ?? ''),
        priority: Priority.high);

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    /* Encode the payload on the basis of platform */
    await localNotificationsPlugin?.show(
        1, data.title, data.body, platformChannelSpecifics,
        payload: Platform.isAndroid
            ? json.encode(message.data)
            : json.encode(message.notification));
  }

  Future<void> notificationHandler(RemoteMessage message) async {
    _notificationsHandler(message);
  }
}