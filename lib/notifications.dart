import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  setLocalLocation(getLocation(currentTimeZone));

  const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  // Request permission (Android 13+ only)
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    // THIS IS THE CRITICAL PART
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      //Handle the notification tap here.
      // For now, just printing is enough to confirm it works.
      print('Notification tapped with payload: ${notificationResponse.payload}');
    },
    // This one is for older versions but good to have
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  AndroidFlutterLocalNotificationsPlugin? androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
  print('Notification tapped in background withpayload: ${notificationResponse.payload}');
}