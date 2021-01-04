import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/functions/request.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../../../main.dart';
import '../account_load.dart';

class AccountEditDetailsSave extends StatelessWidget {
  const AccountEditDetailsSave({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.save),
        onPressed: () async {
          final accountEditDetailsState =
              Provider.of<AccountEditDetailsState>(context, listen: false);

          // Check for invalid data
          if (accountEditDetailsState.firstname == '' ||
              accountEditDetailsState.lastname == '' ||
              accountEditDetailsState.username == '') {
            // Something is wrong
            accountEditDetailsState.showInputError = true;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    AppLocalizations.of(context).translate("dataNotEntered"))));
          } else {
            // Hide the keyboard and show loading animation
            FocusScope.of(context).requestFocus(new FocusNode());
            context.showLoaderOverlay();

            // Try sending the data to the server
            final String apiKey = storage.getItem('apiKey');
            final String serverUrl = storage.getItem('serverUrl');

            await tryRequest(context, () async {
              final response = await http.patch('$serverUrl/user/~', body: {
                'firstname': accountEditDetailsState.firstname,
                'lastname': accountEditDetailsState.lastname,
                'username': accountEditDetailsState.username
              }, headers: {
                'Authorization': 'Bearer $apiKey'
              });

              // Make sure its a valid response code
              if (response.statusCode != 200) {
                throw HttpException(response.statusCode.toString());
              }

              // Reload the account page
              await loadAccountPage(context);

              // Hide the loading animation
              context.hideLoaderOverlay();

              // Close the dialog
              Navigator.of(context).pop();
            });
          }
        });
  }
}
