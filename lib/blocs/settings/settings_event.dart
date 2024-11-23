part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class CurrencyUpdated extends SettingsEvent {
  const CurrencyUpdated(this.currency);

  final Currency currency;

  @override
  List<Object?> get props => [currency];
}
