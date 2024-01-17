import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class MoneyEntryBar extends StatelessWidget {
  MoneyEntryBar({super.key, this.imageKey, this.description, required this.color, required this.amount, required this.date, this.moneyType});

  MoneyEntryBar.fromEntry(MoneyEntry entry, {Key? key}) : this(
      key: key,
      amount: entry.getStringAmount(),
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

  late final Icon? icon = imageKey != null ? Icon(
      IconsHelper.getIcon(imageKey!),
      color: Colors.white,
      size: 20
  ) : null;

  final BorderRadius borderRadius = BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 55,
        width: 370,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(child: icon),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        description ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        date.toSimpleDate(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                amount,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                moneyType?.displayName ?? "",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}
