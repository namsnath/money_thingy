import 'package:flutter/widgets.dart';
import 'package:money_thingy/core/models/forms/validation_item.dart';

class TransactionFormValidationProvider with ChangeNotifier {
  ValidationItem _amount =
      ValidationItem(value: '', isValid: false, error: 'Amount is required');
  ValidationItem _description = ValidationItem(isValid: true);

  // Getters
  ValidationItem get amount => _amount;
  ValidationItem get description => _description;

  bool get isValid {
    return _amount.isValid && _description.isValid;
  }

  // Setters
  void changeAmount(String value) {
    value ??= '';
    bool isNumeric = double.tryParse(value) != null;

    if (value.isEmpty) {
      _amount = ValidationItem(
          value: '', isValid: false, error: 'Amount is required');
    } else if (!isNumeric) {
      _amount = ValidationItem(
          value: '', isValid: false, error: 'Amount should be a valid number');
    } else if (double.parse(value) < 0) {
      _amount = ValidationItem(
          value: '', isValid: false, error: 'Amount should be positive');
    } else {
      _amount = ValidationItem(value: value, isValid: true, error: null);
    }

    notifyListeners();
  }

  void changeDescription(String value) {
    _description = ValidationItem(value: value, isValid: true);
    notifyListeners();
  }
}
