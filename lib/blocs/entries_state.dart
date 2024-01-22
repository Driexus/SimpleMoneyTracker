part of '../blocs/entries_bloc.dart';

sealed class EntriesState extends Equatable {
  const EntriesState(this.filters);

  final MoneyEntryFilters filters;
}

final class EmptyEntries extends EntriesState {
  const EmptyEntries(super.filters);

  @override
  List<Object?> get props => [filters];
}

final class ValidEntries extends EntriesState {
  const ValidEntries(this.firstEntry, this.entries, super.filters);

  final MoneyEntry firstEntry;
  final List<MoneyEntry> entries;

  @override
  List<Object> get props => [firstEntry, entries, filters];
}
