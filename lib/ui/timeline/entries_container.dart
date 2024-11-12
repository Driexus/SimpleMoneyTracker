import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/timeline_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/ui/shared/overscroll_notification_listener.dart';
import 'package:simplemoneytracker/model/currency.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../utils/toast_helper.dart';
import '../shared/navigations.dart';

class EntriesContainer extends StatelessWidget {
  const EntriesContainer({super.key});

  static const double _entrySpacing = 15;
  static const double _totalEntryHeight = _entrySpacing + MoneyEntryBar.height;
  static const double _bias = _totalEntryHeight / 3;

  // Find the first visible money entry and fire callback
  bool _onScroll(ScrollUpdateNotification notification, List<MoneyEntry> entries, TimelineBloc entriesBloc) {
    if (entries.isEmpty) {
      return true;
    }

    final currentPos = notification.metrics.pixels;
    final int index = ((currentPos + _bias) / _totalEntryHeight).floor();
    final MoneyEntry firstVisibleEntry = entries[index];

    entriesBloc.add(FirstEntryUpdated(firstVisibleEntry));
    return true;
  }

  void _showDeleteEntryDialog(MoneyEntry moneyEntry, BuildContext context) {
    MoneyEntryRepo moneyEntryRepo = context.read<MoneyEntryRepo>();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete ${moneyEntry.type.displayName}?'),
        content: Text('Are you sure you want to delete ${moneyEntry.amount.toCurrency(currency: Currency.euro)} of ${moneyEntry.type.displayName}? This action is not reversible.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              moneyEntryRepo.delete(moneyEntry);
              Navigator.pop(context);
              ToastHelper.showToast("Money entry deleted");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          final timelineBloc = context.watch<TimelineBloc>();
          late final List<MoneyEntry> entries;

          switch (timelineBloc.state.runtimeType) {
            case EmptyEntries:
              entries = List.empty();
            case ValidEntries:
              entries = (timelineBloc.state as ValidEntries).entries;
          }

          return OverscrollNotificationListener(
            child: NotificationListener<ScrollUpdateNotification> (
              onNotification: (notification) => _onScroll(notification, entries, timelineBloc),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: entries.map((entry) =>
                        MoneyEntryBar.fromEntry(
                          entry: entry,
                          onPressed: (_) => Navigations.toEditEntryPage(context, entry),
                          onLongPress: (entry) => _showDeleteEntryDialog(entry!, context),
                        )
                    ).addVerticalSpacing(_entrySpacing)
                ),
              ),
            )
          );
        }
    );
  }
}
