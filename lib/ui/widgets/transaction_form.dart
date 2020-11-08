import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money_thingy/core/models/account_master.dart';
import 'package:money_thingy/core/models/category.dart';
import 'package:money_thingy/core/providers/category_provider.dart';
import 'package:money_thingy/core/providers/forms/transaction_form_provider.dart';
import 'package:money_thingy/ui/widgets/category_list.dart';
import 'package:provider/provider.dart';

import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({Key key}) : super(key: key);

  @override
  TransactionFormState createState() {
    return TransactionFormState();
  }
}

class TransactionFormState extends State<TransactionForm> {
  CircularBottomNavigationController _navigationController;

  DateFormat dateFormatter = new DateFormat.yMMMd();
  DateFormat timeFormatter = new DateFormat.Hm();

  Row createTimeButtons() {
    final formProvider = Provider.of<TransactionFormProvider>(context);

    TextStyle buttonTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      // decoration: TextDecoration.underline,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton.icon(
            onPressed: () => _selectDate(),
            icon: Icon(Icons.calendar_today),
            label: Text(
              dateFormatter.format(formProvider.transactionTime),
              style: buttonTextStyle,
            )),
        RaisedButton.icon(
            onPressed: () => _selectTime(),
            icon: Icon(Icons.access_time),
            label: Text(
              timeFormatter.format(formProvider.transactionTime),
              style: buttonTextStyle,
            )),
      ],
    );
  }

  Future<Null> _selectDate() async {
    final formProvider =
        Provider.of<TransactionFormProvider>(context, listen: false);
    final selectedDate = formProvider.transactionTime;

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: formProvider.transactionTime,
        firstDate: DateTime(1980),
        lastDate: DateTime(9999));

    if (picked != null && picked != selectedDate) {
      formProvider.changeTransactionTime(DateTime(picked.year, picked.month,
          picked.day, selectedDate.hour, selectedDate.minute));
    }
  }

  Future<Null> _selectTime() async {
    final formProvider =
        Provider.of<TransactionFormProvider>(context, listen: false);

    final selectedDate = formProvider.transactionTime;
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute));

    if (picked != null &&
        (picked.hour != selectedDate.hour ||
            picked.minute != selectedDate.minute)) {
      formProvider.changeTransactionTime(DateTime(selectedDate.year,
          selectedDate.month, selectedDate.day, picked.hour, picked.minute));
    }
  }

  Row createAccountDropdown() {
    Consumer<TransactionFormProvider> dropdown =
        Consumer<TransactionFormProvider>(
      builder: (context, provider, _) => DropdownButton<AccountMaster>(
        value: provider?.selectedAccount,
        underline: Container(
          height: 1,
          // color: Colors.blueAccent,
        ),
        icon: Icon(Icons.keyboard_arrow_down),
        items: provider?.accountsList
                ?.map<DropdownMenuItem<AccountMaster>>(
                    (v) => DropdownMenuItem(child: Text(v.account), value: v))
                ?.toList() ??
            [],
        onChanged: (AccountMaster newValue) {
          provider.changeSelectedAccount(newValue);
        },
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(Icons.account_balance_wallet),
        SizedBox(width: 20),
        Expanded(
          child: dropdown,
        ),
      ],
    );
  }

  Row createCategorySelector() {
    final provider = Provider.of<TransactionFormProvider>(context);
    final selectedCategory =
        provider.selectedCategories[provider.selectedTransactionTypeIndex];
    

        // CategoryList(
        //     transactionTypeIdFilter: selectedCategory.id,
        // ),

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(Icons.category),
        SizedBox(width: 20),
        Expanded(
          child: FlatButton(
            padding: EdgeInsets.only(left: 0),
            child: Row(
              children: <Widget>[
                Text(selectedCategory?.category ?? 'Uncategorized'),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
            onPressed: () => print(''),
          )
        ),
      ],
    );
  }

  Consumer<TransactionFormProvider> createFieldsCard() {
    return Consumer<TransactionFormProvider>(
      builder: (_, provider, __) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20, bottom: 30, right: 20, top: 10),
          child: Column(
            children: <Widget>[
              createAccountDropdown(),
              createCategorySelector(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.attach_money),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        errorText: provider.amount.error,
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        provider.changeAmount(value);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.short_text),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        errorText: provider.description.error,
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) {
                        provider.changeDescription(value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    super.initState();
    int navigationIndex =
        context.read<TransactionFormProvider>().selectedTransactionTypeIndex;
    _navigationController = CircularBottomNavigationController(navigationIndex);
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<TransactionFormProvider>(context);

    List<TabItem> tabItems = List.of([
      new TabItem(Icons.trending_up, "Income", Colors.green,
          labelStyle:
              TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      new TabItem(Icons.trending_down, "Expense", Colors.red,
          labelStyle:
              TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      new TabItem(Icons.trending_flat, "Transfer", Colors.orange,
          labelStyle:
              TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
    ]);

    return Form(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              // physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              children: <Widget>[
                createTimeButtons(),
                createFieldsCard(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Spacer(flex: 1),
              Expanded(
                flex: 2,
                child: RaisedButton(
                  color: Colors.red,
                  child: Text('Cancel'),
                  onPressed: () => print(''),
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: RaisedButton(
                  color: Colors.green,
                  child: Text('Save'),
                  onPressed: () => print(''),
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
          SizedBox(height: 20),
          CircularBottomNavigation(
            tabItems,
            selectedCallback: (int selectedPos) {
              formProvider.changeSelectedTransactionTypeIndex(selectedPos);
            },
            controller: _navigationController,
            barBackgroundColor: Colors.black,
            normalIconColor: Theme.of(context).buttonColor,
          )
        ],
      ),
    );
  }
}
