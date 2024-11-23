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

  SettingsBloc._create(this.packageInfo, this.sharedPreferences, this.currency) : super(SettingsState(currency, packageInfo)) {
    on<CurrencyUpdated>(_currencyUpdated);
    log("Initialized $runtimeType");
  }

  static Future<SettingsBloc> create() async {
    // Get dependencies
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get currency or assign default (euro)
    String? currencyCode = sharedPreferences.getString("currency");
    Currency currency = currencyCode != null
        ? Currency.fromCode(currencyCode)
        : Currency.euro;

    return SettingsBloc._create(packageInfo, sharedPreferences, currency);
  }

  final PackageInfo packageInfo;
  final SharedPreferences sharedPreferences;
  final Currency currency;

  Future<void> _currencyUpdated(CurrencyUpdated event, Emitter<SettingsState> emit) async {
    sharedPreferences.setString("currency", event.currency.code);
    emit(SettingsState(event.currency, packageInfo));
  }
}
