import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../data/repository/repository.dart';
import '../../modules/home/controllers/home_ticket_data_service.dart';
import '../../modules/home/controllers/statistic_data_service.dart';
import '../../modules/notification/controllers/notification_controller.dart';
import '../../modules/ticket/controllers/ticket_controller.dart';
import 'auth_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;
  NotificationService._internal();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'fbus.notification.', // id
    'Fbus Notification', // title
    description: 'Fbus Copy Right', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await _instance.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_instance.channel);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        debugPrint('Notification: Foreground message received');

        if (notification != null && android != null) {
          _instance.flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                '${_instance.channel.id}.123',
                _instance.channel.name,
                // sound: const RawResourceAndroidNotificationSound(
                //   'sound_notification',
                // ),
                channelDescription: _instance.channel.description,
                importance: Importance.max,
                priority: Priority.high,
                icon: 'mipmap/ic_launcher',
              ),
            ),
          );
        }

        // Reload when receive message
        reloadData();
      },
    );

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void reloadData() {
    Get.find<NotificationController>().fetchNotifications();
    Get.find<TicketController>().ticketDataService.fetchTickets();
    Get.find<HomeTicketDataService>().fetchTicket();
    Get.find<StatisticDataService>().fetch();
  }

  // ignore: unused_element
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint(
        "Notification: Handling a background message: ${message.messageId}");
  }

  static Future<void> registerNotification() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    final String studentId = AuthService.student?.id ?? '';

    var registerNotificationService = repository.registerNotification(
      studentId,
      fcmToken,
    );

    try {
      await registerNotificationService;
      debugPrint('Notification: fcmToken: $fcmToken');
    } catch (error) {
      debugPrint('Notification: Can not register');
      rethrow;
    }
  }

  static Future<void> unregisterNotification() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String studentId = AuthService.student?.id ?? '';

    var registerNotificationService = repository.registerNotification(
      studentId,
      'NULL',
    );

    try {
      await registerNotificationService;
      debugPrint('Notification: unregister successfully');
    } catch (error) {
      debugPrint('Notification: Can not unregister');
      rethrow;
    }
  }
}
