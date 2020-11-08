import 'package:flutter/widgets.dart';
import 'package:money_thingy/core/models/account_master.dart';
import 'package:money_thingy/core/models/category.dart';
import 'package:money_thingy/core/models/forms/validation_item.dart';
import 'package:money_thingy/core/models/transaction_type.dart';
import 'package:money_thingy/core/providers/accounts_master_provider.dart';
import 'package:money_thingy/core/providers/transaction_type_provider.dart';

class TransactionFormProvider with ChangeNotifier {
  // Constants
  List<int> transactionTypeIds = [1, 2, 3];

  // Form State
  AccountMaster selectedAccount;
  TransactionType selectedTransactionType;
  int selectedTransactionTypeIndex = 0;

  // Categories based on tranctionType
  List<Category> selectedCategories = [null, null, null];

  // Form Fields (Validation Items)
  ValidationItem amount =
      ValidationItem(value: '', isValid: false, error: 'Amount is required');
  ValidationItem description = ValidationItem(isValid: true);
  DateTime modifiedTime = DateTime.now();
  DateTime transactionTime = DateTime.now();

  bool get isValid {
    return amount.isValid && description.isValid;
  }

  // Dependencies
  TransactionTypeProvider depTransactionTypeProvider;
  AccountMasterProvider depAccountMasterProvider;

  // Dependent Values
  List<TransactionType> transactionTypesList;
  List<bool> transactionButtonSelectedState = [];
  List<AccountMaster> accountsList;

  // Constructor
  TransactionFormProvider(
      {TransactionTypeProvider transactionTypeProvider,
      AccountMasterProvider accountMasterProvider,
      TransactionType selectedTransactionType,
      AccountMaster selectedAccount}) {
    depTransactionTypeProvider = transactionTypeProvider;
    depAccountMasterProvider = accountMasterProvider;

    transactionTypesList = transactionTypeProvider?.formTransactionTypeList;
    accountsList = accountMasterProvider?.accountsList;

    // if (selectedTransactionType == null) {
    //   if (transactionTypesList != null && transactionTypesList.length > 0) {
    //     transactionButtonSelectedState = List.generate(
    //         transactionTypesList.length, (index) => index == 0 ? true : false);
    //     changeSelectedTransactionType(transactionTypesList?.elementAt(0));
    //   }
    // } else {
    //   changeSelectedTransactionType(selectedTransactionType);
    // }

    if (selectedAccount == null) {
      if (accountsList != null && accountsList.length > 0) {
        changeSelectedAccount(accountsList?.elementAt(0));
      }
    } else {
      changeSelectedAccount(selectedAccount);
    }
  }

  void changeSelectedAccount(AccountMaster newAccount) {
    if (newAccount != null) {
      if (accountsList?.contains(newAccount) ?? false) {
        selectedAccount = newAccount;
        notifyListeners();
      }
    }
  }

  // changeSelectedTransactionType(TransactionType newType) {
  //   if (newType != null) {
  //     if (transactionTypesList?.contains(newType) ?? false) {
  //       transactionButtonSelectedState = List.generate(
  //           transactionTypesList.length,
  //           (index) =>
  //               index == transactionTypesList.indexOf(newType) ? true : false);
  //       selectedTransactionType = newType;
  //       notifyListeners();
  //     }
  //   }
  // }

  changeSelectedTransactionTypeIndex(int position) {
    selectedTransactionTypeIndex = position;
    notifyListeners();
  }

  void changeAmount(String value) {
    value ??= '';
    bool isNumeric = double.tryParse(value) != null;

    if (value.isEmpty) {
      amount = ValidationItem(
          value: '', isValid: false, error: 'Amount is required');
    } else if (!isNumeric) {
      amount = ValidationItem(
          value: '', isValid: false, error: 'Amount should be a valid number');
    } else if (double.parse(value) < 0) {
      amount = ValidationItem(
          value: '', isValid: false, error: 'Amount should be positive');
    } else {
      amount = ValidationItem(value: value, isValid: true, error: null);
    }

    notifyListeners();
  }

  void changeDescription(String value) {
    description = ValidationItem(value: value, isValid: true);
    notifyListeners();
  }

  void changeTransactionTime(DateTime value) {
    transactionTime = value;
    notifyListeners();
  }
}
