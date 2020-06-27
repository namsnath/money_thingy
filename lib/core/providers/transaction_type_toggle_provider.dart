import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/core/models/transaction_type.dart';

class TransactionTypeToggleProvider extends ChangeNotifier {
  final log = Logger('TransactionTypeToggleProvider');

  TransactionType _selectedTransactionType;
  TransactionType get selectedTransactionType => _selectedTransactionType;

  TransactionTypeToggleProvider({TransactionType selected}) {
    if (selected != null)
      changeSelectedTransactionType(selected);
  }

  changeSelectedTransactionType(TransactionType newType) {
    log.info('Updating TxnType');
    _selectedTransactionType = newType;
    notifyListeners();
  }
}