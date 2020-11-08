import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/core/models/transaction_type.dart';
import 'package:money_thingy/core/providers/transaction_type_provider.dart';

class TransactionTypeToggleProvider extends ChangeNotifier {
  final log = Logger('TransactionTypeToggleProvider');

  TransactionType _selectedTransactionType;
  TransactionType get selectedTransactionType => _selectedTransactionType;

  TransactionTypeProvider _txnTypeProvider;

  List<TransactionType> get formTransactionTypes => _txnTypeProvider?.formTransactionTypeList;

  TransactionTypeToggleProvider(TransactionTypeProvider transactionTypeProvider,
      {TransactionType selected}) {
    _txnTypeProvider = transactionTypeProvider;

    if (selected == null) {
      changeSelectedTransactionType(
          _txnTypeProvider?.formTransactionTypeList?.elementAt(0));
    } else {
      changeSelectedTransactionType(selected);
    }
  }

  changeSelectedTransactionType(TransactionType newType) {
    if (newType != null) {
      if (_txnTypeProvider?.formTransactionTypeList?.contains(newType) ??
          false) {
        _selectedTransactionType = newType;
        notifyListeners();
      }
    }
  }
}
