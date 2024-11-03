part of 'date_span_bloc.dart';

sealed class DateSpanState extends Equatable {
  const DateSpanState();

  DateTime get startDate;
  DateTime get endDate;

  String getHeader();

  @override
  List<Object?> get props => [startDate, endDate];
}

/// A datetime span of custom range
final class CustomSpanState extends DateSpanState {
  const CustomSpanState(this.startDate, this.endDate);

  @override
  final DateTime startDate;

  @override
  final DateTime endDate;

  @override
  String getHeader() => "${startDate.toDateFull()} ${endDate.toDateFull()}";
}

/// A datetime span of exactly 1 month
final class MonthSpanState extends DateSpanState {
  const MonthSpanState(this.year, this.month);

  final int year;
  final int month;

  @override
  DateTime get startDate => DateTime(year, month).startOfMonth();

  @override
  DateTime get endDate => DateTime(year, month).startOfNextMonth();

  @override
  String getHeader() => startDate.toMonthYearFull();
}

/// A datetime span of exactly 1 year
final class YearSpanState extends DateSpanState {
  const YearSpanState(this.year);

  final int year;

  @override
  DateTime get startDate => DateTime(year).startOfMonth();

  @override
  DateTime get endDate => DateTime(year).startOfNextMonth();

  @override
  String getHeader() => year.toString();
}
