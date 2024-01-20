import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';

class FirstEntryCubit extends Cubit<MoneyEntry?> {

  MoneyEntry? firstEntry;

  FirstEntryCubit(super.initialState);
}
