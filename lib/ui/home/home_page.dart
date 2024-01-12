import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/home/add_activity/activity_button_container.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../../repos/money_entry_repo.dart';
import 'numpad.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const MoneyEntryRepo _repo = MoneyEntryRepo();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isDecimal = false;
  int _currentDecimals = 0;
  int? _amount;

  String stringAmount() {
    String result = _amount.toStringOrEmpty();
    if (_isDecimal) {
      String front = result.substring(0, result.length - _currentDecimals);
      String back = result.substring(result.length - _currentDecimals, result.length );
      result = "$front.$back";
    }
    return result;
  }

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

  void _submit(MoneyEntryType moneyEntryType) {
    HomePage._repo.create(MoneyEntry(
        createdAt: DateTime.now(),
        amount: _getDBAmount(),
        type: moneyEntryType,
        currencyId: 1,
        comment: ""
    ));
    _reset();
  }

  int _getDBAmount() {
    if (_amount == null) {
      return 0;
    }

    // Add remaining digits as zeroes
    return int.parse(_amount.toString() + "0" * (2 - _currentDecimals));
  }

  void _reset() => setState(() {
    _isDecimal = false;
    _currentDecimals = 0;
    _amount = null;
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 20,
          child: MoneyEntryBar(
            description: 'Test',
            color: Colors.cyan,
            imageKey: "adb",
            amount: stringAmount(),
            date: DateTime.now(),
          )
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 100,
          child: ActivityButtonContainer()
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Column(
            children: [
              Numpad(
                onNumber: _onNumber,
                onDecimal: _onDecimal,
                onBackspace: _onBackspace,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SubmitButton(
                    description: "credit",
                    onPressed: () => _submit(MoneyEntryType.credit),
                  ),
                  _SubmitButton(
                    description: "income",
                    onPressed: () => _submit(MoneyEntryType.income),
                  ),
                  _SubmitButton(
                    description: "expense",
                    onPressed: () => _submit(MoneyEntryType.expense),
                  ),
                  _SubmitButton(
                    description: "debt",
                    onPressed: () => _submit(MoneyEntryType.debt),
                  ),
                ],
              )
            ],
          )
        )
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.description, this.onPressed});

  final String description;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black38,
        textStyle: const TextStyle(fontSize: 12),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      ),
      onPressed: onPressed,
      child: Text(description),
    );
  }
}
