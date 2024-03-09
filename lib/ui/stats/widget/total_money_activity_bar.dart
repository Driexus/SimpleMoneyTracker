import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../../model/money_activity.dart';

class TotalMoneyActivityBar extends StatelessWidget {
  const TotalMoneyActivityBar({super.key, required this.amount, required this.moneyActivity, required this.typeTotalAmount, this.onPressed});

  TotalMoneyActivityBar.fromSubtotal({super.key, required Subtotal subtotal, required this.typeTotalAmount, this.onPressed}) :
      amount = subtotal.amount,
      moneyActivity = subtotal.moneyActivity;

  final int amount;
  final MoneyActivity moneyActivity;
  final int typeTotalAmount;
  final ValueChanged<MoneyEntry?>? onPressed;

  Icon? get _typeIcon => Icon(
      moneyActivity.imageKey.toIconData(),
      color: Colors.white,
      size: 18
  );

  String get _amountPercentage {
    final percentage = ((amount / typeTotalAmount) * 100).round();
    return percentage == 0 ? "<1%" : "$percentage%";
  }

  BorderRadius get _borderRadius => BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: 370,
        child: Material(
            color: moneyActivity.color.toColor(),
            borderRadius: _borderRadius,
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.black26,
                borderRadius: _borderRadius,
                onTap: () => (),
                child: Stack(
                  children: [
                    Positioned(
                        left: 10,
                        top: 0,
                        bottom: 0,
                        child: Container(child: _typeIcon)
                    ),
                    Positioned(
                        left: 40,
                        top: 0,
                        bottom: 0,
                        child: Center(
                            child: Text(
                              moneyActivity.title,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )
                        )
                    ),
                    Positioned(
                        right: 60,
                        top: 0,
                        bottom: 0,
                        child: Center(
                            child: AutoSizeText(
                              amount.toEuros(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
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
                              _amountPercentage,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )
                        )
                    ),
                    const Positioned(
                        right: 43,
                        top: 0,
                        bottom: 0,
                        child: VerticalDivider(
                          thickness: 2,
                          indent: 7,
                          endIndent: 7,
                          color: Colors.black12,
                        ),
                    ),
                  ],
                )
            )
        )
    );
  }
}
