part of '../blocs/timeline_bloc.dart';

@immutable
sealed class TimelineEvent extends Equatable {
  const TimelineEvent();
}

/// All filter values are overwritten
final class FiltersUpdated extends TimelineEvent {
  const FiltersUpdated(this.filters);

  final MoneyEntryFilters filters;

  @override
  List<Object> get props => [filters];
}

/// Non-null filter values overwrite the old. Null filter values are ignored.
final class FiltersAdded extends TimelineEvent {
  const FiltersAdded(this.filters);

  final MoneyEntryFilters filters;

  @override
  List<Object> get props => [filters];
}

final class FirstEntryUpdated extends TimelineEvent {
  const FirstEntryUpdated(this.firstEntry);

  final MoneyEntry firstEntry;

  @override
  List<Object> get props => [firstEntry];
}

final class EntriesChanged extends TimelineEvent {
  const EntriesChanged();

  @override
  List<Object> get props => [];
}
