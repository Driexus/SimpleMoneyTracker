import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/entries_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/ui/shared/overscroll_notification_listener.dart';
import 'package:simplemoneytracker/ui/timeline/first_entry_cubit.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class EntriesContainer extends StatelessWidget {
  const EntriesContainer({super.key, required this.onFirstEntry});

  final ValueChanged<MoneyEntry?> onFirstEntry;

  static const double _entrySpacing = 15;
  static const double _totalEntryHeight = _entrySpacing + MoneyEntryBar.height;
  static const double _bias = _totalEntryHeight / 3;

  // Find the first visible money entry and fire callback
  bool _onScroll(ScrollUpdateNotification notification, List<MoneyEntry> entries, FirstEntryCubit cubit) {
    if (entries.isEmpty) {
      _setFirstVisibleEntry(null, cubit);
      return true;
    }

    final currentPos = notification.metrics.pixels;
    final int index = ((currentPos + _bias) / _totalEntryHeight).floor();
    final MoneyEntry firstVisibleEntry = entries[index];

    _setFirstVisibleEntry(firstVisibleEntry, cubit);

    /*log(notification.metrics.pixels.toString());
    log("First index: $index");
    log("First entry: $firstVisibleEntry");*/
    return true;
  }

  void _setFirstVisibleEntry(MoneyEntry? entry, FirstEntryCubit cubit) {
    if (entry != cubit.firstEntry) {
      cubit.firstEntry = entry;
      onFirstEntry(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          final entries = context.watch<EntriesCubit>().state;
          final firstEntryCubit = context.watch<FirstEntryCubit>();

          return OverscrollNotificationListener(
            child: NotificationListener<ScrollUpdateNotification> (
              onNotification: (notification) => _onScroll(notification, entries, firstEntryCubit),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: entries.map((entry) =>
                        MoneyEntryBar.fromEntry(entry)
                    ).addVerticalSpacing(_entrySpacing)
                ),
              ),
            )
          );
        }
    );
  }
}
