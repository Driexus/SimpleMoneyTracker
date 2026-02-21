import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This must be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  print("callbackDispatcher called");
  Workmanager().executeTask((task, inputData) async {
    // 1. Initialize notifications INSIDE the background task
    final FlutterLocalNotificationsPlugin localNotify = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotify.initialize(const InitializationSettings(android: androidInit));

    // 2. Define the Card (Big Picture) Style
    const cardStyle = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      contentTitle: '<b>Background Card</b>',
      summaryText: 'Sent while app was closed',
      htmlFormatContentTitle: true,
    );

    // 3. Show it manually
    print("printing notification");
    await localNotify.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Background Alert',
      'This came from a background task!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bg_channel_v1',
          'Background Alerts',
          importance: Importance.max,
          priority: Priority.high,
          //styleInformation: cardStyle,
        ),
      ),
    );

    return Future.value(true);
  });
}