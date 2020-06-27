import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money_thingy/constants/initial_transaction_types.dart';
import 'package:money_thingy/models/account_master.dart';
import 'package:money_thingy/models/category.dart';
import 'package:money_thingy/models/transaction_type.dart';
import 'package:money_thingy/providers/accounts_master_provider.dart';
import 'package:money_thingy/providers/forms/transaction_form_validation_provider.dart';
import 'package:money_thingy/providers/transaction_type_provider.dart';
import 'package:money_thingy/providers/transaction_type_toggle_provider.dart';
import 'package:money_thingy/widgets/category_list.dart';
import 'package:money_thingy/widgets/transaction_type_toggle.dart';
// import 'package:money_thingy/widgets/transaction_type_toggle.dart';
import 'package:provider/provider.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({Key key}) : super(key: key);

  @override
  TransactionFormState createState() {
    return TransactionFormState();
  }
}

class TransactionFormState extends State<TransactionForm> {
  List<AccountMaster> _accounts = [];
  AccountMaster _selectedAccount;

  Category _selectedCategory;
  int _selectedCategoryId = 62;

  DateTime modifiedTime = DateTime.now();

  DateTime selectedDate = DateTime.now();
  DateFormat dateFormatter = new DateFormat.yMMMd();
  DateFormat timeFormatter = new DateFormat.Hm();

  double _amount = 0;
  String _description = '';

  Row createAccountDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<AccountMaster>(
              value: _selectedAccount,
              underline: Container(
                height: 2,
                // color: Colors.blueAccent,
              ),
              icon: Icon(Icons.keyboard_arrow_down),
              items: _accounts
                  .map<DropdownMenuItem<AccountMaster>>(
                      (v) => DropdownMenuItem(child: Text(v.account), value: v))
                  .toList(),
              onChanged: (AccountMaster newValue) {
                setState(() {
                  _selectedAccount = newValue;
                });
              }),
        ),
      ],
    );
  }

  Row createTimeButtons() {
    TextStyle buttonTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      // decoration: TextDecoration.underline,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              dateFormatter.format(selectedDate),
              style: buttonTextStyle,
            )),
        RaisedButton(
            onPressed: () => _selectTime(context),
            child: Text(
              timeFormatter.format(selectedDate),
              style: buttonTextStyle,
            )),
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980),
        lastDate: DateTime(9999));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day,
            selectedDate.hour, selectedDate.minute);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute));

    if (picked != null &&
        (picked.hour != selectedDate.hour ||
            picked.minute != selectedDate.minute)) {
      setState(() {
        selectedDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, picked.hour, picked.minute);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accountState = Provider.of<AccountMasterProvider>(context);
    _accounts = accountState.accountsList;
    _selectedAccount = _accounts.length > 0 ? _accounts[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    final validationProvider =
        Provider.of<TransactionFormValidationProvider>(context);

    return Form(
      child: Expanded(
        child: ListView(
          children: <Widget>[
            TransactionTypeToggle(),
            createAccountDropdown(),
            createTimeButtons(),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Amount',
                errorText: validationProvider.amount.error,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                validationProvider.changeAmount(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                errorText: validationProvider.description.error,
              ),
              textInputAction: TextInputAction.next,
              autofocus: false,
              onChanged: (String value) {
                validationProvider.changeDescription(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
