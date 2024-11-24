part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState(this.currency);

  final Currency currency;

  @override
  List<Object?> get props => [currency];
}

final class EmptySettingsState extends SettingsState {
  const EmptySettingsState() : super(Currency.euro);
}

final class ValidSettingsState extends SettingsState {
  const ValidSettingsState(super.currency, this.packageInfo);

  final PackageInfo packageInfo;
}
