import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_firstname.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_lastname.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_save.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details_username.dart';
import 'package:trackless/trackless/models/trackless_user_model.dart';
import 'package:trackless/trackless/trackless_account.dart';

/// A basic dialog to edit some account details
class AccountEditDetails extends StatelessWidget {
  const AccountEditDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountEditDetailsState(
          Provider.of<TracklessAccount>(context, listen: false).tracklessUser),
      child: Builder(
        builder: (context) => WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                // Make the appBar the correct colors
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Theme.of(context).colorScheme.onBackground),

                iconTheme: Theme.of(context).iconTheme.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                elevation: 0,
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

  // Load the account details
  AccountEditDetailsState(TracklessUser user) {
    _firstname.text = user.firstname;
    _lastname.text = user.lastname;
    _username.text = user.username;
  }

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
