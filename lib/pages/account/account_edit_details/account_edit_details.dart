import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_firstname.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_lastname.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_save.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_username.dart';

/// A basic dialog to edit some account details
class AccountEditDetails extends StatelessWidget {
  const AccountEditDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountEditDetailsState(),
      child: Builder(
        builder: (context) => WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                // Make the appBar the correct colors
                backgroundColor: Theme.of(context).accentColor,
                iconTheme: Theme.of(context).accentIconTheme,
                textTheme: Theme.of(context).accentTextTheme,
                // Show the correct title
                title: Text(AppLocalizations.of(context)
                    .translate('account_edit_details')),
                // Show the actions
                actions: [AccountEditDetailsSave()],
              ),
              body: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  AccountEditDetailsFirstname(),
                  SizedBox(
                    height: 16,
                  ),
                  AccountEditDetailsLastname(),
                  SizedBox(
                    height: 16,
                  ),
                  AccountEditDetailsUsername()
                ],
              ),
            ),
            onWillPop: () async {
              return true;
            }),
      ),
    );
  }
}

/// The 'global' state for the account dialog
class AccountEditDetailsState with ChangeNotifier {
  // States for the inputs
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _username = TextEditingController();

  // Global states
  bool _showInputError = false;

  /// Should input errors be shown?
  bool get showInputError => _showInputError;

  /// Change the show input error value
  set showInputError(bool newState) {
    if (_showInputError != newState) {
      _showInputError = newState;
      notifyListeners();
    }
  }

  /// Get the current firstname
  String get firstname => _firstname.text;

  /// Get the current lastname
  String get lastname => _lastname.text;

  /// Get the current username
  String get username => _username.text;

  /// Get the current firstname text controller
  TextEditingController get firstnameController => _firstname;

  /// Get the current lastname text controller
  TextEditingController get lastnameController => _lastname;

  /// Get the current username text controller
  TextEditingController get usernameController => _username;
}