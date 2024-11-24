import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/currency.dart';

class CurrencyDropdownButton extends StatefulWidget {
  const CurrencyDropdownButton({super.key, required this.initialCurrency, required this.onCurrencySelected});

  final Currency initialCurrency;
  final ValueChanged<Currency?> onCurrencySelected;

  @override
  State<CurrencyDropdownButton> createState() => _CurrencyDropdownButtonState();
}

class _CurrencyDropdownButtonState extends State<CurrencyDropdownButton> {

  Currency? _selectedOption;

  @override
  void initState() {
    _selectedOption = widget.initialCurrency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Currency>(
      items: Currency.values.map((currency) => DropdownMenuItem(value: currency, child: Text(currency.symbol))).toList(),
      onChanged: (currency) {
        widget.onCurrencySelected(currency);
        setState(() {
          _selectedOption = currency;
        });
      },
      value: _selectedOption,
    );
  }
}
