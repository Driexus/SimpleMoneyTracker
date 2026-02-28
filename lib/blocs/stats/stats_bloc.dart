import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import '../../model/BaseMoneyType.dart';
import '../../model/CompositeMoneyType.dart';
import '../../model/money_activity.dart';
import '../../repos/money_entry_repo.dart';
import 'package:equatable/equatable.dart';

import '../date_span/date_span_bloc.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(this.entryRepo, this.activitiesCubit, this.dateSpanBloc) : super(const EmptyStatsState()) {
    on<DatesUpdated>(_datesUpdated);
    on<EntriesUpdated>(_entriesUpdated);

    // Refresh entries when an entry is added
    entryRepo.addOnEntriesChangedListener(() => add(const EntriesUpdated()));

    // Refresh entries when activities are changed
    activitiesCubit.stream.listen((event) => add(const EntriesUpdated()));

    // Refresh total when dateSpan changes
    dateSpanBloc.stream.listen((state) => add(DatesUpdated(state)));

    log("Initialized StatsBloc");
  }

  final MoneyEntryRepo entryRepo;
  final ActivitiesCubit activitiesCubit;
  final DateSpanBloc dateSpanBloc;

  Future<void> _datesUpdated(DatesUpdated event, Emitter<StatsState> emit) async {
    final totals = await _calculateTotals(event.state.startDate, event.state.endDate);
    emit(NonEmptyStatsState(totals[0], totals[1]));
  }

  /// Renew entries and emit the same state as before.
  Future<void> _entriesUpdated(EntriesUpdated event, Emitter<StatsState> emit) async {
    if (state.runtimeType == EmptyStatsState) {
      emit(const EmptyStatsState());
      return;
    }

    final totals = await _calculateTotals(dateSpanBloc.state.startDate, dateSpanBloc.state.endDate);
    emit(NonEmptyStatsState(totals[0], totals[1]));
  }

  Future<List<dynamic>> _calculateTotals(DateTime? startDate, DateTime? endDate) async {
    MoneyEntryFilters filters = MoneyEntryFilters(
        minDate: startDate, maxDate: endDate);

    return Future.wait<dynamic>([
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.expense])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.income])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.debt])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.credit])),
      entryRepo.calculateSubtotals(MoneyType.expense, startDate, endDate),
      entryRepo.calculateSubtotals(MoneyType.income, startDate, endDate),
      entryRepo.calculateSubtotals(MoneyType.debt, startDate, endDate),
      entryRepo.calculateSubtotals(MoneyType.credit, startDate, endDate),
    ]).then((futures) {

      Map<BaseMoneyType, int> totals = {
        MoneyType.expense: futures[0] ?? 0,
        MoneyType.income: futures[1] ?? 0,
        MoneyType.debt: futures[2] ?? 0,
        MoneyType.credit: futures[3] ?? 0,
      };
      totals[CompositeMoneyType.netIncome] = totals[MoneyType.income]! - totals[MoneyType.expense]!;
      totals[CompositeMoneyType.netCredit] = totals[MoneyType.credit]! - totals[MoneyType.debt]!;

      Map<BaseMoneyType, List<Subtotal>> subtotals = {
        MoneyType.expense: futures[4] ?? List.empty(),
        MoneyType.income: futures[5] ?? List.empty(),
        MoneyType.debt: futures[6] ?? List.empty(),
        MoneyType.credit: futures[7] ?? List.empty(),
      };
      subtotals[CompositeMoneyType.netIncome] = _calculateSubtotals(subtotals[MoneyType.income]!, subtotals[MoneyType.expense]!);
      subtotals[CompositeMoneyType.netCredit] = _calculateSubtotals(subtotals[MoneyType.credit]!, subtotals[MoneyType.debt]!);

      return [totals, subtotals];
    });
  }

  List<Subtotal> _calculateSubtotals(List<Subtotal> incomes, List<Subtotal> expenses) {
    // Use a map to aggregate amounts by MoneyActivity id
    final Map<int, MoneyActivity> moneyActivityMap = {};
    final Map<int, int> totalsMap = {};

    // Add incomes to the map
    for (var subtotal in incomes) {
      moneyActivityMap[subtotal.moneyActivity.id!] = subtotal.moneyActivity;
      totalsMap[subtotal.moneyActivity.id!] = (totalsMap[subtotal.moneyActivity.id!] ?? 0) + subtotal.amount;
    }

    // Subtract expenses from the map
    for (var subtotal in expenses) {
      moneyActivityMap[subtotal.moneyActivity.id!] = subtotal.moneyActivity;
      totalsMap[subtotal.moneyActivity.id!] = (totalsMap[subtotal.moneyActivity.id!] ?? 0) - subtotal.amount;
    }

    // Convert the map back into a List of Subtotal objects
    return totalsMap.entries
        .map((entry) => Subtotal(moneyActivityMap[entry.key]!, entry.value))
        .sorted((o1, o2) => o2.amount.abs().compareTo(o1.amount.abs()))
        .toList();
  }
}
