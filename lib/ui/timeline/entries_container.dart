import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/entries_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/ui/shared/overscroll_notification_listener.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class EntriesContainer extends StatelessWidget {
  const EntriesContainer({super.key});

  static const double _entrySpacing = 15;
  static const double _totalEntryHeight = _entrySpacing + MoneyEntryBar.height;
  static const double _bias = _totalEntryHeight / 3;

  // Find the first visible money entry and fire callback
  bool _onScroll(ScrollUpdateNotification notification, List<MoneyEntry> entries, EntriesBloc entriesBloc) {
    if (entries.isEmpty) {
      return true;
    }

    final currentPos = notification.metrics.pixels;
    final int index = ((currentPos + _bias) / _totalEntryHeight).floor();
    final MoneyEntry firstVisibleEntry = entries[index];

    entriesBloc.add(FirstEntryUpdated(firstVisibleEntry));

    /*log(notification.metrics.pixels.toString());
    log("First index: $index");
    log("First entry: $firstVisibleEntry");*/
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          final entriesBloc = context.watch<EntriesBloc>();
          late final List<MoneyEntry> entries;

          switch (entriesBloc.state.runtimeType) {
            case EmptyEntries:
              entries = List.empty();
            case ValidEntries:
              entries = (entriesBloc.state as ValidEntries).entries;
          }

          return OverscrollNotificationListener(
            child: NotificationListener<ScrollUpdateNotification> (
              onNotification: (notification) => _onScroll(notification, entries, entriesBloc),
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
