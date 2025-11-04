import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
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
      entryRepo.calculateSubtotals(MoneyType.expense, startDate, endDate),
      entryRepo.calculateSubtotals(MoneyType.income, startDate, endDate),
    ]).then((futures) {

      Map<MoneyType, int> totals = {
        MoneyType.expense: futures[0] ?? 0,
        MoneyType.income: futures[1] ?? 0,
      };

      Map<MoneyType, List<Subtotal>> subtotals = {
        MoneyType.expense: futures[4] ?? List.empty(),
        MoneyType.income: futures[5] ?? List.empty(),
      };

      return [totals, subtotals];
    });
  }
}
