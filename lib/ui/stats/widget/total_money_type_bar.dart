import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../shared/navigations.dart';

class TotalMoneyTypeBar extends StatelessWidget {
  const TotalMoneyTypeBar({super.key, required this.amount, required this.moneyType, this.onPressed});

  final int amount;
  final MoneyType moneyType;
  final ValueChanged<MoneyEntry?>? onPressed;

  Icon? get typeIcon => Icon(
      moneyType.icon,
      color: moneyType.color,
      size: 20
  );

  BorderRadius get borderRadius => BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 55,
        width: 370,
        child: Material(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: borderRadius,
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.black26,
                borderRadius: borderRadius,
                onTap: () => Navigations.toBreakdownPage(context, moneyType),
                child: Stack(
                  children: [
                    Positioned(
                        left: 10,
                        top: 0,
                        bottom: 0,
                        child: Container(child: typeIcon)
                    ),
                    Positioned(
                        left: 40,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            "Total ${moneyType.displayName}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          )
                        )
                    ),
                    Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: AutoSizeText(
                            amount.toEuros(),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          )
                        )
                    ),
                  ],
                )
            )
        )
    );
  }
}
