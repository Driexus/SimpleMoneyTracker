import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:workmanager/workmanager.dart';

import '../model/currency.dart';
import 'notifications.dart';

// This should be more general if different notifications are required in the future
@pragma('vm:entry-point')
void callbackDispatcher() {
  log("callbackDispatcher called");
  Workmanager().executeTask((task, inputData) async {
    log("Work manager executing task");
    final MoneyEntryRepo moneyEntryRepo = MoneyEntryRepo();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final nextNextDay = nextDay.add(const Duration(days: 1));
    final entries = await moneyEntryRepo.retrieveSome(filters: MoneyEntryFilters(minDate: nextDay, maxDate: nextNextDay, allowedTypes: [MoneyType.expense]));

    // No entries, exit
    if (entries.isEmpty) {
      log("No expenses to show tomorrow. Exiting notifications.");
      return Future.value(true);
    }
    else {
      log("Found ${entries.length} expenses for tomorrow. Sending notification.");
    }

    // Build messages
    final sharedPreferences = await SharedPreferences.getInstance();
    final currency = sharedPreferences.getCurrency() ?? Currency.euro;
    final paymentTitle = entries.length == 1 ? "payment" : "payments";
    final title = 'You have ${entries.length} upcoming $paymentTitle';
    final description = entries
        .map((entry) => "${entry.activity.title} payment of ${entry.amount.toCurrency(currency: currency)} due tomorrow")
        .reduce((acc, current) => "$acc\n$current");

    // Card style
    final cardStyle = BigTextStyleInformation(
      description,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    // Show notification
    final FlutterLocalNotificationsPlugin notificationsPlugin = await initNotificationsPlugin();
    await notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: "Upcoming $paymentTitle",
      body: title,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'bg_channel_v4',
          'Background Alerts',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          showWhen: true,
          styleInformation: cardStyle,
        ),
      ),
    );

    return Future.value(true);
  });
}