part of '../blocs/home_page_bloc.dart';

final class HomePageState extends Equatable {
  const HomePageState(this.isDecimal, this.currentDecimals, this.amount, this.date, this.moneyType, this.moneyActivity);

  final bool isDecimal;
  final int currentDecimals;
  final int amount;
  final DateTime date;
  final MoneyType moneyType;
  final MoneyActivity? moneyActivity;

  @override
  List<Object?> get props => [isDecimal, currentDecimals, amount, date, moneyType, moneyActivity];

  bool isSubmittable() => moneyActivity != null;
}
