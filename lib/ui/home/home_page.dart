import 'package:flutter/material.dart';

import '../shared/edit_money_entry_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditMoneyEntryPage(forUpdate: false);
  }
}
