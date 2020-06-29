import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/core/providers/accounts_master_provider.dart';
import 'package:money_thingy/core/providers/category_provider.dart';
import 'package:money_thingy/core/providers/forms/transaction_form_validation_provider.dart';
import 'package:money_thingy/core/providers/transaction_provider.dart';
import 'package:money_thingy/core/providers/transaction_type_provider.dart';
import 'package:money_thingy/ui/views/transaction_update/transaction_update_view.dart';
import 'package:money_thingy/service_locator.dart';
import 'package:provider/provider.dart';

import 'package:money_thingy/core/database/database.dart';
import 'package:money_thingy/ui/views/home_page.dart';

void main() {
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => AccountMasterProvider(), lazy: false),
      ChangeNotifierProvider(
        create: (_) => TransactionTypeProvider(),
        lazy: false,
      ),
      ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(
          create: (_) => TransactionFormValidationProvider()),
    ],
    child: MyApp(),
  ));
  DatabaseProvider.dbProvider.init();

  Logger.root.level = Level.FINE; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.loggerName}_${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Thingy',
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      // ),
      // home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: TransactionUpdateView(),
    );
  }
}
