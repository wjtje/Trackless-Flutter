import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:trackless/global/app_state.dart';
import 'package:trackless/components/async_progress.dart';
import 'package:trackless/pages/account/account_information.dart';
import 'package:trackless/pages/account/account_load.dart';
import 'package:trackless/pages/account/account_options.dart';
import 'package:trackless/pages/account/account_refresh_action.dart';

final accountPage = AppPage(
    pageTitle: 'account_page_title',
    page: AccountPage(),
    appBarActions: [AccountRefreshAction()]);

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with AfterLayoutMixin<AccountPage> {
  @override
  void afterFirstLayout(BuildContext context) {
    // Load the account page on build
    loadAccountPage(context);
  }

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
