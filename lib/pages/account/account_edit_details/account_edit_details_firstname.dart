import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/functions/input_validator.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details.dart';

class AccountEditDetailsFirstname extends StatelessWidget {
  const AccountEditDetailsFirstname({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountEditDetailsState =
        Provider.of<AccountEditDetailsState>(context);

    return TextFormField(
      controller: accountEditDetailsState.firstnameController,
      // Make the text field look good
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)
            .translate("account_edit_details_firstname"),
        border: OutlineInputBorder(),
      ),
      // Test the input value
      autovalidateMode: AutovalidateMode.always,
      validator: inputValidator(accountEditDetailsState.showInputError, context,
          "account_edit_details_firstname"),
    );
  }
}
