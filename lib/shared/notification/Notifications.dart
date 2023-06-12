
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings android = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
  );

  final DarwinInitializationSettings ios = const DarwinInitializationSettings();

  Future<void> initialization() async {

    InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }


  Future<void> sendNotification({
    required String title,
    required String body,
}) async {

    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,);


  }

}