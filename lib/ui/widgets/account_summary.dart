import 'package:flutter/material.dart';
import 'package:money_thingy/core/providers/accounts_master_provider.dart';
import 'package:provider/provider.dart';

class AccountSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountMasterProvider>(
        builder: (context, accountsMaster, child) {
      final List<Widget> array = accountsMaster.accountsList
          .map((v) => Flexible(
              flex: 1,
              child: ListTile(
                title: Text(v.account),
                subtitle: Text(v.id.toString()),
              )))
          .toList();

      return Row(children: array);
    });
  }
}
