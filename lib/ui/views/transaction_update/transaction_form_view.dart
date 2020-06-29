import 'package:flutter/material.dart';
import 'package:money_thingy/core/models/transaction_type.dart';
import 'package:money_thingy/ui/views/transaction_update/transaction_update_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TransactionFormView extends StatefulWidget {
  TransactionFormView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionFormViewState();
}

class TransactionFormViewState extends State<TransactionFormView> {
  // TransactionTypesService _txnTypeService = 

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

  Widget getToggleButtons() {
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransactionUpdateViewModel>.nonReactive(
      builder: (context, model, child) => Form(
        child: Expanded(
          child: ListView(
            children: <Widget>[
              getToggleButtons(),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => TransactionUpdateViewModel(),
    );
  }
}
