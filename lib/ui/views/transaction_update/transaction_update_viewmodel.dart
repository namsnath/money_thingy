import 'package:money_thingy/core/models/account_master.dart';
import 'package:money_thingy/core/models/category.dart';
import 'package:money_thingy/core/models/transaction_type.dart';
import 'package:stacked/stacked.dart';

class TransactionUpdateViewModel extends BaseViewModel {
  String title = 'Transaction Update View';

  // Fields
  double amount;
  String description;
  DateTime modifiedTime;
  DateTime transactionTime;

  AccountMaster selectedAccount;
  TransactionType selectedTransactionType;
  Category selectedCategory;

}