import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> scheduleDailyNotification() async {
  // Notification details
  const androidDetails = AndroidNotificationDetails(
    'daily_channel_id',
    'Daily Notifications',
    channelDescription: 'Daily notification at specific time',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  // Target time: 11:00 AM local time
  final now = TZDateTime.now(local);
  //var scheduled = TZDateTime(local, now.year, now.month, now.day, 11, 0);
  var scheduled = now.add(const Duration(seconds: 15));

  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good morning!',
    'Here is your daily notification',
    scheduled,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good morning!',
    'Here is your daily notification',
    scheduled.add(const Duration(hours: 0)),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good morning!',
    'Here is your daily notification',
    scheduled.add(const Duration(hours: 1)),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good morning!',
    'Here is your daily notification',
    scheduled.add(const Duration(hours: 2)),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good morning!',
    'Here is your daily notification',
    scheduled.add(const Duration(hours: 3)),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good morning!',
    'Here is your daily notification',
    scheduled.add(const Duration(hours: -1)),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good morning!',
    'Here is your daily notification',
    scheduled.add(const Duration(hours: -2)),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

/*  await flutterLocalNotificationsPlugin.show(
    0,
    'Good morning!',
    'Here is your daily notification',
    notificationDetails,
  );*/

  final List<PendingNotificationRequest> pendingNotifications =
  await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  int a = 3;
}

Future<void> initNotifications() async {
  initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  setLocalLocation(getLocation(currentTimeZone));

  const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  // Request permission (Android 13+ only)
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  AndroidFlutterLocalNotificationsPlugin? androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();
}
