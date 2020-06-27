import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/models/transaction_type.dart';
import 'package:money_thingy/providers/category_provider.dart';
import 'package:money_thingy/providers/transaction_type_provider.dart';
import 'package:money_thingy/providers/transaction_type_toggle_provider.dart';
import 'package:money_thingy/widgets/category_list.dart';
import 'package:money_thingy/database/database.dart';
import 'package:money_thingy/widgets/transaction_form.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final log = Logger('HomePage');
  final dbProvider = DatabaseProvider.dbProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text('HomePage Widget'),
              // AccountSummary(),
              // CategoryList(
              //   transactionTypeIdFilter: 1,
              // ),
              MultiProvider(
                providers: [
                  ChangeNotifierProxyProvider<TransactionTypeProvider,
                      TransactionTypeToggleProvider>(
                    create: (_) => TransactionTypeToggleProvider(),
                    update: (_, txnType, __) {
                      List<TransactionType> _transactionTypes =
                          txnType.formTransactionTypeList;

                      TransactionType _selectedTransactionType =
                          _transactionTypes.length > 0
                              ? _transactionTypes[0]
                              : null;
                      return TransactionTypeToggleProvider(
                          selected: _selectedTransactionType);
                    },
                  ),
                ],
                child: TransactionForm(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Update',
        child: Icon(Icons.sync),
      ),
    );
  }
}
