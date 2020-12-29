import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackless/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trackless/async_state.dart';
import 'package:trackless/main.dart';
import 'package:http/http.dart' as http;
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:trackless/trackless/trackless_work.dart';

import '../work_dialog.dart';

/// A save button for the work dialog
class WorkDialogSave extends StatelessWidget {
  const WorkDialogSave({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.save),
        onPressed: () async {
          // Get access to the data
          final workDialogState =
              Provider.of<WorkDialogState>(context, listen: false);

          // Check for invalid data
          if (workDialogState.currentLocationID == null ||
              workDialogState.currentWorktypeID == null ||
              workDialogState.currentDescription == '' ||
              workDialogState.currentTime == null ||
              !RegExp(r'(^[0-9]{1}|^1[0-9]{1})($|[.,][0-9]{1,2}$)')
                  .hasMatch(workDialogState.currentTime.toString())) {
            // Your are missing something
            workDialogState.showInputError = true; // Show the error's
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)
                    .translate("add_work_dataNotEntered"))));
          } else {
            // Hide the keyboard and show loading animation
            FocusScope.of(context).requestFocus(new FocusNode());
            context.showLoaderOverlay();

            // Try sending the data to the server
            final String apiKey = storage.getItem('apiKey');
            final String serverUrl = storage.getItem('serverUrl');

            try {
              final response = await http.post('$serverUrl/user/~/work', body: {
                'worktypeID': workDialogState.currentWorktypeID.toString(),
                'locationID': workDialogState.currentLocationID.toString(),
                'date': DateFormat('yyyy-MM-dd')
                    .format(workDialogState.currentDate),
                'time': workDialogState.currentTime.toString(),
                'description':
                    workDialogState.descriptionController.value.text.toString()
              }, headers: {
                'Authorization': 'Bearer $apiKey'
              });

              // Make sure its a valid response code
              if (response.statusCode != 201) {
                throw HttpException(response.statusCode.toString());
              }

              // Reload the home page
              () async {
                final asyncState =
                    Provider.of<AsyncState>(context, listen: false);
                // Show the async loading
                asyncState.isAsyncLoading = true;

                // Load the data
                final tracklessWorkProvider =
                    Provider.of<TracklessWorkProvider>(context, listen: false);
                await tracklessWorkProvider.refreshFromServer(
                    tracklessWorkProvider.startDate,
                    tracklessWorkProvider.endDate);

                // Done loading
                asyncState.isAsyncLoading = false;
              }();

              // Hide the loading animation
              context.hideLoaderOverlay();

              // Close the dialog
              Navigator.of(context).pop();
            } on SocketException {
              throw TracklessFailure(1); // No internet connection
            } on HttpException catch (e) {
              switch (e.message) {
                case '400':
                  throw TracklessFailure(6, detailCode: 14); // Bad request
                case '401':
                  throw TracklessFailure(2); // Unauthorized
                case '404':
                  throw TracklessFailure(3); // Not found
                default:
                  throw TracklessFailure(4); // Internal server error
              }
            } on FormatException {
              throw TracklessFailure(5); // Internal error
            } on TypeError {
              throw TracklessFailure(5, detailCode: 15); // Internal error
            } finally {
              // hide the loading animation
              context.hideLoaderOverlay();
            }
          }
        });
  }
}
