import 'package:flutter/cupertino.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/stats/widget/total_money_activity_bar.dart';
import 'package:simplemoneytracker/ui/stats/widget/total_money_type_bar.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

// TODO: Add on click listeners and disable non-clickable bars
class TotalMoneyBarContainer extends StatelessWidget {
  const TotalMoneyBarContainer({super.key, required this.amount, required this.moneyType, required this.subtotals});

  final int amount;
  final MoneyType moneyType;
  final List<Subtotal> subtotals;

  List<Widget> get _totalMoneyActivityBars {
    int end = subtotals.length < 3 ? subtotals.length : 3;
    final firstSubtotals = subtotals.sublist(0, end);
    return firstSubtotals.map((e) => TotalMoneyActivityBar.fromSubtotal(subtotal: e, typeTotalAmount: amount)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TotalMoneyTypeBar(amount: amount, moneyType: moneyType),
        const SizedBox(height: 15),
        ..._totalMoneyActivityBars.addVerticalSpacing(10)
      ],
    );
  }
}
