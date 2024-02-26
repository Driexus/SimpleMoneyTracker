part of '../blocs/stats_bloc.dart';

sealed class StatsState extends Equatable {
  const StatsState(this.filters);

  final MoneyEntryFilters filters;
}

final class EmptyEntries extends StatsState {
  const EmptyEntries(super.filters);

  @override
  List<Object?> get props => [filters];
}

final class ValidEntries extends StatsState {
  const ValidEntries(this.firstEntry, this.entries, super.filters);

  final MoneyEntry firstEntry;
  final List<MoneyEntry> entries;

  @override
  List<Object> get props => [firstEntry, entries, filters];
}
