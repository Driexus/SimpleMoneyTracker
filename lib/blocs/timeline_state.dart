part of '../blocs/timeline_bloc.dart';

sealed class TimelineState extends Equatable {
  const TimelineState(this.filters);

  final MoneyEntryFilters filters;
}

final class EmptyEntries extends TimelineState {
  const EmptyEntries(super.filters);

  @override
  List<Object?> get props => [filters];
}

final class ValidEntries extends TimelineState {
  const ValidEntries(this.firstEntry, this.entries, super.filters);

  final MoneyEntry firstEntry;
  final List<MoneyEntry> entries;

  @override
  List<Object> get props => [firstEntry, entries, filters];
}
