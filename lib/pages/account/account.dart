import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/app_state.dart';
import 'package:trackless/components/async_progress.dart';
import 'package:trackless/pages/account/account_information.dart';
import 'package:trackless/pages/account/account_options.dart';
import 'package:trackless/pages/account/account_refresh_action.dart';
import 'package:trackless/trackless/trackless_account.dart';

final accountPage = AppPage(
    pageTitle: 'account_page_title',
    page: AccountPage(),
    appBarActions: [
      AccountRefreshAction(),
      Builder(
          builder: (context) => IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                final accountState =
                    Provider.of<TracklessAccount>(context, listen: false);

                accountState.tracklessUser = null;
              }))
    ]);

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AsyncProgress(),
        SizedBox(
          height: 16.0,
        ),
        AccountInformation(),
        SizedBox(
          height: 8.0,
        ),
        AccountOptions(),
        SizedBox(
          height: 16.0,
        )
      ],
    );
  }
}
