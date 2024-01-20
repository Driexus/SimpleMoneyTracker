import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/money_entry.dart';
import '../repos/money_entry_repo.dart';

class EntriesCubit extends Cubit<List<MoneyEntry>> {
  static final EntriesCubit _instance = EntriesCubit._init();
  factory EntriesCubit() {
    return _instance;
  }

  EntriesCubit._init() : super(List.empty()) {
    log("Creating Entries Cubit");
    updateEntries();
  }

  static const MoneyEntryRepo _repo = MoneyEntryRepo();

  MoneyEntryFilters? _filters;
  void setFilters(MoneyEntryFilters? filters) {
    _filters = filters;
    updateEntries();
  }

  void updateEntries() {
    _repo.retrieveSome(filters: _filters).then((value) => {
      emit(value)
    });
  }

  void addEntry(MoneyEntry entry) {
    _repo.create(entry).then((value) => updateEntries());
  }
}
