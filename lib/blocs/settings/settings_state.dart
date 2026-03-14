part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState(this.currency, this.visibleStats);

  final Currency currency;
  final List<String> visibleStats;

  @override
  List<Object?> get props => [currency, visibleStats];
}

final class EmptySettingsState extends SettingsState {
  const EmptySettingsState() : super(Currency.euro, const []);
}

final class ValidSettingsState extends SettingsState {
  const ValidSettingsState(super.currency, super.visibleStats, this.packageInfo);

  final PackageInfo packageInfo;

  @override
  List<Object?> get props => [currency, visibleStats, packageInfo];
}
