import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplemoneytracker/model/currency.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../model/base_money_type.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const EmptySettingsState()) {
    on<_Initialized>(_init);
    on<CurrencyUpdated>(_currencyUpdated);
    on<VisibleStatsUpdated>(_visibleStatsUpdated);
    add(const _Initialized());
    log("Initialized $runtimeType");
  }

  /// Hacky way to initialize bloc asynchronously through events
  Future<void> _init(_Initialized event, Emitter<SettingsState> emit) async {
    // Get dependencies
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Currency currency = sharedPreferences.getCurrency() ?? Currency.euro;
    List<String> visibleStats = sharedPreferences.getStringList("visible_stats") ?? allMoneyTypes().map((e) => e.enumName).toList();

    emit(ValidSettingsState(currency, visibleStats, packageInfo));
  }

  Future<void> _currencyUpdated(CurrencyUpdated event, Emitter<SettingsState> emit) async {
    // Set currency in prefs
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setCurrency(event.currency);

    // Emit state. State should have been initialized already
    final currentState = state as ValidSettingsState;
    emit(ValidSettingsState(event.currency, currentState.visibleStats, currentState.packageInfo));
  }

  Future<void> _visibleStatsUpdated(VisibleStatsUpdated event, Emitter<SettingsState> emit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("visible_stats", event.visibleStats);

    final currentState = state as ValidSettingsState;
    emit(ValidSettingsState(currentState.currency, event.visibleStats, currentState.packageInfo));
  }
}
