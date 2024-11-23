import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplemoneytracker/model/currency.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const EmptySettingsState()) {
    on<_Initialized>(_init);
    on<CurrencyUpdated>(_currencyUpdated);
    add(const _Initialized());
    log("Initialized $runtimeType");
  }

  /// Hacky way to initialize bloc asynchronously through events
  Future<void> _init(_Initialized event, Emitter<SettingsState> emit) async {
    // Get dependencies
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get currency or assign default (euro)
    String? currencyCode = sharedPreferences.getString("currency");
    Currency currency = currencyCode != null
        ? Currency.fromCode(currencyCode)
        : Currency.euro;

    emit(ValidSettingsState(currency, packageInfo));
  }

  Future<void> _currencyUpdated(CurrencyUpdated event, Emitter<SettingsState> emit) async {
    // Set currency in prefs
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("currency", event.currency.code);

    // Emit state. State should have been initialized already
    emit(ValidSettingsState(event.currency, (state as ValidSettingsState).packageInfo));
  }
}
