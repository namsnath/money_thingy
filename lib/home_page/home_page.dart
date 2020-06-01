import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/database/database.dart';
import 'package:money_thingy/database/providers/accounts_master_provider.dart';
import 'package:money_thingy/models/accounts_master.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final log = Logger('HomePage');
  final dbProvider = DatabaseProvider.dbProvider;

  Widget renderTiles(BuildContext context) {
    log.fine('Render Tiles called');
    return FutureBuilder(
        future: Provider.of<AccountsMasterProvider>(context).getAccounts(),
        builder: (BuildContext context,
            AsyncSnapshot<List<AccountsMaster>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new LinearProgressIndicator();
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            final List<Widget> array = snapshot.data
                .map((v) => Flexible(
                    flex: 1,
                    child: ListTile(
                      title: Text(v.account),
                      subtitle: Text(v.id.toString()),
                    )))
                .toList();

            return Row(
              children: array,
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'HomePage Widget',
            ),
            Consumer<AccountsMasterProvider>(
                builder: (context, accountsMaster, child) =>
                    renderTiles(context))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: Provider.of<AccountsMasterProvider>(context, listen: false)
            .updateAccount,
        tooltip: 'Update',
        child: Icon(Icons.sync),
      ),
    );
  }
}
