part of 'stats_bloc.dart';

@immutable
sealed class StatsEvent extends Equatable {
  const StatsEvent();
}

/// All filter values are overwritten
final class FiltersUpdated extends StatsEvent {
  const FiltersUpdated(this.filters);

  final MoneyEntryFilters filters;

  @override
  List<Object> get props => [filters];
}

/// Non-null filter values overwrite the old. Null filter values are ignored.
final class FiltersAdded extends StatsEvent {
  const FiltersAdded(this.filters);

  final MoneyEntryFilters filters;

  @override
  List<Object> get props => [filters];
}

final class FirstEntryUpdated extends StatsEvent {
  const FirstEntryUpdated(this.firstEntry);

  final MoneyEntry firstEntry;

  @override
  List<Object> get props => [firstEntry];
}

final class Refreshed extends StatsEvent {
  const Refreshed();

  @override
  List<Object> get props => [];
}
