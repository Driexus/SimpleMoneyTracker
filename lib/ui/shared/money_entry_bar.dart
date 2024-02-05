import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class MoneyEntryBar extends StatelessWidget {
  MoneyEntryBar({super.key, this.imageKey, this.description, required this.color, required this.amount, required this.date, this.moneyType});

  static const double height = 55;

  MoneyEntryBar.fromEntry(MoneyEntry entry, {Key? key}) : this(
      key: key,
      amount: entry.amount.toEuros(),
      date: entry.createdAt,
      moneyType: entry.type,
      color: Color(entry.activity.color),
      imageKey: entry.activity.imageKey,
      description: entry.activity.title
  );

  final String? imageKey;
  final String? description;
  final Color color;
  final String amount;
  final DateTime date;
  final MoneyType? moneyType;

  late final Icon? activityIcon = imageKey != null ? Icon(
      IconsHelper.getIcon(imageKey!),
      color: Colors.white,
      size: 20
  ) : null;

  late final Icon? typeIcon = moneyType != null ? Icon(
      moneyType!.icon,
      color: Colors.white,
      size: 20
  ) : null;

  final BorderRadius borderRadius = BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: 370,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Container(child: activityIcon)
            ),
            Positioned(
              left: 40,
              top: 5,
              child: Text(
                description ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )
            ),
            Positioned(
              left: 40,
              bottom: 5,
              child: Text(
                date.toDayMonth(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              )
            ),
            Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                amount,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                ),
              )
            ),
            Positioned(
              right: 10,
              top: 5,
              child: Container(child: typeIcon)
            ),
            Positioned(
              right: 10,
              bottom: 5,
              child: AutoSizeText(
                moneyType?.displayName ?? "",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )
            ),
          ],
        )
      )
    );
  }
}
