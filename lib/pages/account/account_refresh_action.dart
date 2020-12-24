import 'package:flutter/material.dart';
import 'package:trackless/pages/account/account_load.dart';

/// A basic refresh button that will reload the account page
class AccountRefreshAction extends StatelessWidget {
  const AccountRefreshAction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.refresh), onPressed: () => loadAccountPage(context));
  }
}
