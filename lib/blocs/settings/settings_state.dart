part of 'settings_bloc.dart';

final class SettingsState extends Equatable {
  const SettingsState(this.currency, this.packageInfo);

  final Currency currency;
  final PackageInfo packageInfo;

  @override
  List<Object?> get props => [currency];
}
