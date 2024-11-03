part of 'date_span_bloc.dart';

@immutable
sealed class DateSpanEvent extends Equatable {
  const DateSpanEvent();

  @override
  List<Object?> get props => [];
}

final class DatesUpdated extends DateSpanEvent {
  const DatesUpdated(this.startDate, this.endDate);

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

//region Month Events

final class MonthUpdated extends DateSpanEvent {
  const MonthUpdated(this.year, this.month);

  final int year;
  final int month;

  @override
  List<Object?> get props => [year, month];
}

final class NextMonth extends DateSpanEvent {
  const NextMonth();
}

final class PreviousMonth extends DateSpanEvent {
  const PreviousMonth();
}

//endregion

//region Year Events

final class YearUpdated extends DateSpanEvent {
  const YearUpdated(this.year);

  final int year;

  @override
  List<Object?> get props => [year];
}

final class NextYear extends DateSpanEvent {
  const NextYear();
}

final class PreviousYear extends DateSpanEvent {
  const PreviousYear();
}

//endregion