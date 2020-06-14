import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/models/account_master.dart';
import 'package:money_thingy/widgets/account_summary.dart';
import 'package:provider/provider.dart';
import 'package:money_thingy/database/database.dart';
import 'package:money_thingy/providers/accounts_master_provider.dart';

class HomePage extends StatelessWidget {
  final log = Logger('HomePage');
  final dbProvider = DatabaseProvider.dbProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'HomePage Widget',
            ),
            AccountSummary(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Provider.of<AccountMasterProvider>(context, listen: false)
                .updateAccount(AccountMaster(
                    id: 1,
                    institution: 'inst',
                    account: '${new DateTime.now().millisecondsSinceEpoch}')),
        tooltip: 'Update',
        child: Icon(Icons.sync),
      ),
    );
  }
}
