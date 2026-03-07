import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplemoneytracker/notification/upcoming_payment_notification.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:workmanager/workmanager.dart';

Future<void> initNotifications() async {
  // Initialize timezones
  initializeTimeZones();
  final String currentTimeZone = (await FlutterTimezone.getLocalTimezone()).identifier;
  setLocalLocation(getLocation(currentTimeZone));

  // Initialize plugin
  FlutterLocalNotificationsPlugin notificationsPlugin = await initNotificationsPlugin();
  AndroidFlutterLocalNotificationsPlugin? androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  // If we have already requested permission and notifications are disabled, respect user's choice
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool notificationsEnabled = await androidPlugin?.areNotificationsEnabled() ?? false;
  if (sharedPreferences.hasRequestedNotificationPermission() && !notificationsEnabled) {
    return;
  }

  // Request permission (Android 13+ only)
  notificationsEnabled = await androidPlugin?.requestNotificationsPermission() ?? false;
  await sharedPreferences.requestedNotificationPermission();
  if (!notificationsEnabled) {
    return;
  }

  // Initialize WorkManager and task
  await Workmanager().initialize(
      callbackDispatcher
  );
  await scheduleTask();
}

@pragma('vm:entry-point')
Future<FlutterLocalNotificationsPlugin> initNotificationsPlugin() async {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('notification_icon');
  await notificationsPlugin.initialize(settings: const InitializationSettings(android: androidInit)); // TODO: Add callback on notification tap
  return notificationsPlugin;
}

Future<void> scheduleTask() async {
  Duration initialDelay;
  Duration frequency;
  ExistingPeriodicWorkPolicy existingWorkPolicy;

  // Debug
  if (kDebugMode) {
    initialDelay = const Duration(seconds: 5);
    frequency = const Duration(minutes: 15);
    existingWorkPolicy = ExistingPeriodicWorkPolicy.replace;

    log("Scheduled debug payment notification");
    await Workmanager().registerOneOffTask(
      "one-time-future-payments-task",
      "futurePaymentsTask",
      initialDelay: initialDelay,
    );
  }
  // Production
  else {
    DateTime now = DateTime.now();
    DateTime firstRun = DateTime(now.year, now.month, now.day, 11, 0).add(const Duration(days: 1)); // Tomorrow at 11 AM
    initialDelay = firstRun.difference(now);
    frequency = const Duration(days: 1);
    existingWorkPolicy = ExistingPeriodicWorkPolicy.keep;
  }

  // Periodic task
  await Workmanager().registerPeriodicTask(
    "daily-future-payments-task",
    "dailyFuturePaymentsTask",
    frequency: frequency,
    existingWorkPolicy: existingWorkPolicy,
    initialDelay: initialDelay,
  );
}