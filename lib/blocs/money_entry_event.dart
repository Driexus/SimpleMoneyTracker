part of '../blocs/money_entry_bloc.dart';

@immutable
sealed class MoneyEntryEvent extends Equatable {
  const MoneyEntryEvent();

  @override
  List<Object?> get props => [];
}

final class MoneyTypeUpdated extends MoneyEntryEvent {
  const MoneyTypeUpdated(this.moneyType);

  final MoneyType moneyType;

  @override
  List<Object?> get props => [moneyType];
}

final class MoneyActivityUpdated extends MoneyEntryEvent {
  const MoneyActivityUpdated(this.moneyActivity);

  final MoneyActivity moneyActivity;

  @override
  List<Object?> get props => [moneyActivity];
}

final class DateUpdated extends MoneyEntryEvent {
  const DateUpdated(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class DigitPressed extends MoneyEntryEvent {
  const DigitPressed(this.digit);

  final int digit;

  @override
  List<Object?> get props => [digit];
}

final class BackspacePressed extends MoneyEntryEvent {
  const BackspacePressed();
}

final class DecimalPressed extends MoneyEntryEvent {
  const DecimalPressed();
}

final class EntrySubmitted extends MoneyEntryEvent {
  const EntrySubmitted();
}
