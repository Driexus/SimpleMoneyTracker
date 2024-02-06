part of '../blocs/home_page_bloc.dart';

@immutable
sealed class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object?> get props => [];
}

final class MoneyTypeUpdated extends HomePageEvent {
  const MoneyTypeUpdated(this.moneyType);

  final MoneyType moneyType;

  @override
  List<Object?> get props => [moneyType];
}

final class MoneyActivityUpdated extends HomePageEvent {
  const MoneyActivityUpdated(this.moneyActivity);

  final MoneyActivity moneyActivity;

  @override
  List<Object?> get props => [moneyActivity];
}

final class DateUpdated extends HomePageEvent {
  const DateUpdated(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class DigitPressed extends HomePageEvent {
  const DigitPressed(this.digit);

  final int digit;

  @override
  List<Object?> get props => [digit];
}

final class BackspacePressed extends HomePageEvent {
  const BackspacePressed();
}

final class DecimalPressed extends HomePageEvent {
  const DecimalPressed();
}

final class EntrySubmitted extends HomePageEvent {
  const EntrySubmitted();
}
