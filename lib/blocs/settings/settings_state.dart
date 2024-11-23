part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

final class EmptySettingsState extends SettingsState {
  const EmptySettingsState();

  @override
  List<Object?> get props => [];
}

final class ValidSettingsState extends SettingsState {
  const ValidSettingsState(this.currency, this.packageInfo);

  final Currency currency;
  final PackageInfo packageInfo;

  @override
  List<Object?> get props => [currency];
}
