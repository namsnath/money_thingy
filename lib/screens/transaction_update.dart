import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/models/transaction_type.dart';
import 'package:money_thingy/providers/forms/transaction_form_validation_provider.dart';
import 'package:money_thingy/providers/transaction_type_provider.dart';
import 'package:money_thingy/providers/transaction_type_toggle_provider.dart';
import 'package:money_thingy/widgets/transaction_form.dart';
import 'package:provider/provider.dart';

class TransactionUpdate extends StatelessWidget {
  final log = Logger('TransactionUpdate');

  final GlobalKey _transactionFormKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                log.info(Provider.of<TransactionFormValidationProvider>(context,
                        listen: false)
                    .isValid
                    .toString());
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MultiProvider(
                providers: [
                  ChangeNotifierProxyProvider<TransactionTypeProvider,
                      TransactionTypeToggleProvider>(
                    create: (_) => TransactionTypeToggleProvider(),
                    update: (_, txnType, oldToggleProvider) {
                      List<TransactionType> _transactionTypes =
                          txnType.formTransactionTypeList;

                      TransactionType _selectedTransactionType;

                      if (_transactionTypes.length > 0) {
                        if (_transactionTypes.contains(oldToggleProvider.selectedTransactionType)) {
                          _selectedTransactionType = oldToggleProvider.selectedTransactionType;
                        } else {
                          _selectedTransactionType = _transactionTypes[0];
                        }
                      }
                      
                      return TransactionTypeToggleProvider(
                          selected: _selectedTransactionType);
                    },
                  ),
                ],
                child: TransactionForm(key: _transactionFormKey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
