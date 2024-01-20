import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/entries_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class EntriesContainer extends StatelessWidget {
  const EntriesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntriesCubit, List<MoneyEntry>>(
        builder: (context, entries) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: entries.map((entry) =>
                  MoneyEntryBar.fromEntry(entry)
              ).addVerticalSpacing(15)
        )
    );
  }
}
