import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:simplemoneytracker/blocs/stats_bloc.dart';
import 'package:simplemoneytracker/ui/shared/bottom_button.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../../model/money_entry.dart';
import '../../../repos/money_entry_repo.dart';
import '../../shared/overscroll_notification_listener.dart';
import '../widget/total_money_activity_bar.dart';

class BreakdownPage extends StatelessWidget {
  const BreakdownPage({super.key, required this.statsState, required this.moneyType});

  final StatsState statsState;
  final MoneyType moneyType;

  int get total => statsState.totals[moneyType]!;
  List<Subtotal> get subtotals => statsState.subtotals[moneyType]!;

  List<Widget> get _totalMoneyActivityBars => subtotals.map((e) =>
      TotalMoneyActivityBar.fromSubtotal(subtotal: e, typeTotalAmount: total)
  ).toList();

  Map<String, double> get _dataMap {
    Map<String, double> result = {};
    for (Subtotal subtotal in subtotals) {
      result[subtotal.moneyActivity.title] = subtotal.amount.toDouble();
    }
    return result;
  }

  List<Color> get _colorList => subtotals.map((e) => e.moneyActivity.color.toColor()).toList();

  String get _title {
    if (statsState.runtimeType == MonthStatsState) {
      return (statsState as MonthStatsState).month.toMonthYearFull();
    }

    return ""; // TODO: Handle more states
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 45,
              right: 0,
              left: 0,
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black54,
                ),
              ),
            ),
            Positioned(
              top: 115,
              right: 0,
              left: 0,
              child: PieChart(
                dataMap: _dataMap,
                colorList: _colorList,
                chartType: ChartType.ring,
                centerWidget: Text(
                  "Total ${moneyType.displayName}\n${total.toEuros()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                chartRadius: MediaQuery.of(context).size.width / 2.0,
                ringStrokeWidth: 35,
                legendOptions: const LegendOptions(showLegends: false),
                chartValuesOptions: const ChartValuesOptions(showChartValues: false),
              )
            ),
            Positioned(
              top: 380,
              bottom: 65,
              right: 0,
              left: 0,
              child: OverscrollNotificationListener(
                child: NotificationListener<ScrollUpdateNotification> (
                  child: SingleChildScrollView(
                    child: Column(
                      children: _totalMoneyActivityBars.addVerticalSpacing(10)
                    )
                  )
                )
              )
            ),
            BottomButton(
              text: "OK",
              onTap: () => Navigator.pop(context)
            )
          ],
        )
    );
  }
}
