part of 'money_entry_bloc.dart';

final class MoneyEntryState extends Equatable {
  const MoneyEntryState(this.id, this.isDecimal, this.currentDecimals, this.amount, this.date, this.moneyType, this.moneyActivity);

  final int? id;
  final bool isDecimal;
  final int currentDecimals;
  final int amount;
  final DateTime date;
  final MoneyType moneyType;
  final MoneyActivity? moneyActivity;

  @override
  List<Object?> get props => [isDecimal, currentDecimals, amount, date, moneyType, moneyActivity];

  bool isSubmittable() => moneyActivity != null && amount != 0;

  int getDBAmount() {
    // Add remaining digits as zeroes
    return int.parse(amount.toString() + "0" * (2 - currentDecimals));
  }
}
