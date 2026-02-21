import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:workmanager/workmanager.dart';

Future<void> initNotifications() async {
  // Initialize timezones
  initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  setLocalLocation(getLocation(currentTimeZone));

  // Request permission (Android 13+ only)
  FlutterLocalNotificationsPlugin notificationsPlugin = await initNotificationsPlugin();
  AndroidFlutterLocalNotificationsPlugin? androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();

  // Initialize WorkManager and task
  await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true // TODO: Set to false for release
  );
  await scheduleTask();
}

Future<FlutterLocalNotificationsPlugin> initNotificationsPlugin() async {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await notificationsPlugin.initialize(const InitializationSettings(android: androidInit));
  return notificationsPlugin;
}

Future<void> scheduleTask() async {
  DateTime now = DateTime.now();
  DateTime firstRun = DateTime(now.year, now.month, now.day, 11, 0).add(const Duration(days: 1)); // Tomorrow at 11 AM

  // TODO: Change for release
  Duration initialDelay = const Duration(seconds: 5);
  // Duration initialDelay = firstRun.difference(now);

  await Workmanager().registerPeriodicTask(
    "daily-future-payments-task",
    "futurePaymentsTask",
    // TODO: Change for release
    frequency: const Duration(minutes: 15),
    // TODO: Change for release
    //existingWorkPolicy: ExistingWorkPolicy.keep,
    existingWorkPolicy: ExistingWorkPolicy.replace,
    //frequency: const Duration(hours: 24),
    initialDelay: initialDelay,
  );

  // TODO
  // await Workmanager().registerOneOffTask(
  //   "one-time-future-payments-task",
  //   "futurePaymentsTask",
  //   initialDelay: initialDelay,
  // );
}

// This should be more general if different notifications are required in the future
@pragma('vm:entry-point')
void callbackDispatcher() {
  print("callbackDispatcher called");
  Workmanager().executeTask((task, inputData) async {
    // Card style
    const BigPictureStyleInformation cardStyle = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      contentTitle: '<b>Background Card</b>',
      summaryText: 'Sent while app was closed',
      htmlFormatContentTitle: true,
    );

    // Show notification
    final FlutterLocalNotificationsPlugin notificationsPlugin = await initNotificationsPlugin();
    await notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Background Alert',
      'This came from a background task!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bg_channel_v2',
          'Background Alerts',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: cardStyle,
        ),
      ),
    );

    return Future.value(true);
  });
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
  print('Notification tapped in background with payload: ${notificationResponse.payload}');
}