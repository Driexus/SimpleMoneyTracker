part of 'stats_bloc.dart';

@immutable
sealed class StatsEvent extends Equatable {
  const StatsEvent();
}

final class DatesUpdated extends StatsEvent {
  const DatesUpdated(this.startDate, this.endDate);

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

final class MonthUpdated extends StatsEvent {
  const MonthUpdated(this.month);

  final DateTime month;

  @override
  List<Object?> get props => [month];
}

final class EntriesChanged extends StatsEvent {
  const EntriesChanged();

  @override
  List<Object?> get props => [];
}
