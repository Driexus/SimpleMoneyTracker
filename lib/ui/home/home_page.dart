import 'package:flutter/material.dart';
import 'package:simplemoneytracker/cubits/entries_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/home/activity_button_container.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:simplemoneytracker/utils/toast_helper.dart';
import 'numpad.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final EntriesCubit _cubit = EntriesCubit();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MoneyActivity? _currentActivity;
  bool _isDecimal = false;
  int _currentDecimals = 0;
  int? _amount;

  void _reset() => setState(() {
    _currentActivity = null;
    _isDecimal = false;
    _currentDecimals = 0;
    _amount = null;
  });

  void _onActivity(MoneyActivity activity) => setState(() {
    _currentActivity = activity;
  });

  void _onNumber(int number) => setState(() {
    if (_currentDecimals >= 2) {
      return;
    }

    _amount = int.parse(_amount.toStringOrEmpty() + number.toString());
    if (_isDecimal) {
      _currentDecimals ++;
    }
  });

  void _onDecimal() => setState(() {
    _isDecimal = true;
  });

  void _onBackspace() => setState(() {
    if (_isDecimal && _currentDecimals == 0) {
      _isDecimal = false;
    }
    else if (_amount != null) {
      var strAmount = _amount.toString();
      strAmount = strAmount.substring(0, strAmount.length - 1);
      _amount = strAmount == "" ? null : int.parse(strAmount);
    }

    if (_currentDecimals  > 0) {
      _currentDecimals --;
    }
  });

  void _submit(MoneyType moneyEntryType) {
    if (_currentActivity == null) {
      ToastHelper.showToast("Please select an activity before saving an entry");
      return;
    }

    HomePage._cubit.addEntry(MoneyEntry(
        createdAt: DateTime.now(),
        amount: _getDBAmount(),
        type: moneyEntryType,
        currencyId: 1,
        comment: "",
        activity: _currentActivity!
    ));
    _reset();
    ToastHelper.showToast("${moneyEntryType.displayName} entry added");
  }

  int _getDBAmount() {
    if (_amount == null) {
      return 0;
    }

    // Add remaining digits as zeroes
    return int.parse(_amount.toString() + "0" * (2 - _currentDecimals));
  }

  String stringAmount() {
    String result = _amount.toStringOrEmpty();
    if (_isDecimal) {
      String front = result.substring(0, result.length - _currentDecimals);
      String back = result.substring(result.length - _currentDecimals, result.length );
      result = "$front.$back";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 20,
          child: MoneyEntryBar(
            description: _currentActivity?.title,
            color: Colors.cyan,
            imageKey: _currentActivity?.imageKey,
            amount: stringAmount(),
            date: DateTime.now(),
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 100,
          child: ActivityButtonContainer(
            onActivity: _onActivity,
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Numpad(
                onNumber: _onNumber,
                onDecimal: _onDecimal,
                onBackspace: _onBackspace,
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SubmitButton(
                      description: "credit",
                      moneyType: MoneyType.credit,
                      onPressed: () => _submit(MoneyType.credit),
                      color: MoneyType.credit.color,
                    ),
                  ),
                  Expanded(
                    child: _SubmitButton(
                      description: "income",
                      moneyType: MoneyType.income,
                      onPressed: () => _submit(MoneyType.income),
                      color: MoneyType.income.color,
                    ),
                  ),
                  Expanded(
                    child: _SubmitButton(
                      description: "expense",
                      moneyType: MoneyType.expense,
                      onPressed: () => _submit(MoneyType.expense),
                      color: MoneyType.expense.color,
                    ),
                  ),
                  Expanded(
                    child: _SubmitButton(
                      description: "debt",
                      moneyType: MoneyType.debt,
                      onPressed: () => _submit(MoneyType.debt),
                      color: MoneyType.debt.color,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              )
            ],
          )
        )
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  const _SubmitButton({
    required this.description,
    required this.moneyType,
    required this.color,
    this.onPressed,
  });

  final String description;
  final MoneyType moneyType;
  final Color color;
  final VoidCallback? onPressed;

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onPressed?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          border: Border.all(
            color: _isSelected ? widget.color : Colors.grey,
            width: 0.3,
          ),
        ),
        child: Icon(
          widget.moneyType.icon,
          color: widget.color
        ),
      ),
    );
  }
}