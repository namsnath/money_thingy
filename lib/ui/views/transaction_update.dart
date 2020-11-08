import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/core/models/transaction_type.dart';
import 'package:money_thingy/core/providers/accounts_master_provider.dart';
import 'package:money_thingy/core/providers/forms/transaction_form_provider.dart';
import 'package:money_thingy/core/providers/forms/transaction_form_validation_provider.dart';
import 'package:money_thingy/core/providers/transaction_type_provider.dart';
import 'package:money_thingy/ui/widgets/transaction_form.dart';
import 'package:provider/provider.dart';

class TransactionUpdate extends StatelessWidget {
  final log = Logger('TransactionUpdate');

  final GlobalKey _transactionFormKey = new GlobalKey(debugLabel: 'FormKey');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MultiProvider(
        providers: [
          ChangeNotifierProxyProvider2<TransactionTypeProvider,
              AccountMasterProvider, TransactionFormProvider>(
            create: (_) => TransactionFormProvider(),
            update: (_, txnType, account, oldTxnForm) =>
                TransactionFormProvider(
              transactionTypeProvider: txnType,
              accountMasterProvider: account,
              selectedAccount: oldTxnForm.selectedAccount,
              selectedTransactionType: oldTxnForm.selectedTransactionType,
            ),
            lazy: false,
          ),
        ],
        child: Center(
          child: TransactionForm(),
        ),
      ),
    );
  }
}
