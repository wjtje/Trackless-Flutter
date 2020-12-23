import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/app_state.dart';
import 'package:trackless/trackless/trackless_account.dart';
import 'package:trackless/trackless/trackless_failure.dart';

/// A basic refresh button that will reload the account page
class AccountRefreshAction extends StatelessWidget {
  const AccountRefreshAction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () async {
          final appState = Provider.of<AppState>(context, listen: false);
          final accountState =
              Provider.of<TracklessAccount>(context, listen: false);

          appState.isAsyncLoading = true;

          try {
            await accountState.refreshFromServer();
          } on TracklessFailure catch (e) {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: Text(
                  AppLocalizations.of(context).translate('error_${e.code}') +
                      e.toString()),
              backgroundColor: Colors.red,
            ));
          }

          // Wait two seconds bevore closing the animation
          await Future.delayed(Duration(milliseconds: 500));

          appState.isAsyncLoading = false;
        });
  }
}
