import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_thingy/models/transaction_type.dart';
import 'package:money_thingy/providers/transaction_type_provider.dart';
import 'package:money_thingy/providers/transaction_type_toggle_provider.dart';
import 'package:provider/provider.dart';

class TransactionTypeToggle extends StatefulWidget {
  TransactionTypeToggle({Key key}) : super(key: key);

  @override
  TransactionTypeToggleState createState() {
    return TransactionTypeToggleState();
  }
}

class TransactionTypeToggleState extends State<TransactionTypeToggle> {
  List<TransactionType> _transactionTypes = [];
  List<bool> _transactionTypeIsSelected = [];

  transactionTypeToggleOnPressed(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < _transactionTypeIsSelected.length;
          buttonIndex++) {
        if (buttonIndex == index) {
          _transactionTypeIsSelected[buttonIndex] = true;
          Provider.of<TransactionTypeToggleProvider>(context, listen: false)
              .changeSelectedTransactionType(_transactionTypes[buttonIndex]);
        } else {
          _transactionTypeIsSelected[buttonIndex] = false;
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final transactionTypeState = Provider.of<TransactionTypeProvider>(context);
    List<TransactionType> _newTransactionTypes =
        transactionTypeState.formTransactionTypeList;
    if (_newTransactionTypes != _transactionTypes) {
      _transactionTypes = transactionTypeState.formTransactionTypeList;
      _transactionTypeIsSelected = List.generate(
          _transactionTypes.length, (index) => index == 0 ? true : false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = _transactionTypes
        .map((v) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(v.transactionType),
            ))
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ToggleButtons(
        children: buttons,
        isSelected: _transactionTypeIsSelected,
        onPressed: transactionTypeToggleOnPressed,
        borderRadius: BorderRadius.circular(5),
        constraints: BoxConstraints.tightFor(height: 25.0),
      ),
    );
  }
}
