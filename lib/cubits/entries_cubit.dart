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

  void updateEntries() {
    _repo.retrieveAll().then((value) => {
      emit(value)
    });
  }

  void addEntry(MoneyEntry activity) {
    _repo.create(activity).then((value) => updateEntries());
  }
}
