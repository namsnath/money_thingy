import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/providers/accounts_master_provider.dart';
import 'package:money_thingy/service_locator.dart';
import 'package:provider/provider.dart';

import 'package:money_thingy/database/database.dart';
import 'package:money_thingy/screens/home_page.dart';

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountMasterProvider())
      ],
      child: MyApp(),
    )
  );
  DatabaseProvider.dbProvider.init();

  Logger.root.level = Level.FINE; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Thingy',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
