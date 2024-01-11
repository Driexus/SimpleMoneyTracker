import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class MoneyEntryBar extends StatelessWidget {
  MoneyEntryBar({super.key, this.imageKey, required this.description, required this.color, this.amount});

  final String? imageKey;
  final String description;
  final Color color;
  final int? amount;

  late final Icon? icon = imageKey != null ? Icon(
      IconsHelper.getIcon(imageKey!),
      color: Colors.white,
      size: 20
  ) : null;

  final BorderRadius borderRadius = BorderRadius.circular(8.0);

  void onTap() {
    log("Clicked on $description");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: icon,
            ),
            AutoSizeText(
              amount.parseAmount(),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                color: Colors.white,
              ),
            ),
            AutoSizeText(
              description,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        )
    );
  }
}
