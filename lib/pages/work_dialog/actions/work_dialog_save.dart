import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_failure.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trackless/main.dart';
import 'package:http/http.dart' as http;

import '../work_dialog.dart';

/// A save button for the work dialog
class WorkDialogSave extends StatelessWidget {
  const WorkDialogSave({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workDialogState = Provider.of<WorkDialogState>(context);
    return Visibility(
        visible: workDialogState.editWork == null,
        child: IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              // Check for invalid data
              if (workDialogState.currentLocationID == null ||
                  workDialogState.currentWorktypeID == null ||
                  workDialogState.currentDescription == '' ||
                  workDialogState.currentTimeNull == null ||
                  !RegExp(r'(^[0-9]{1}|^1[0-9]{1})($|[.,][0-9]{1,2}$)')
                      .hasMatch(workDialogState.currentTime.toString())) {
                // Your are missing something
                workDialogState.showInputError = true; // Show the error's
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)
                        .translate("dataNotEntered"))));
              } else {
                // Hide the keyboard and show loading animation
                FocusScope.of(context).requestFocus(new FocusNode());
                context.showLoaderOverlay();

                // Try sending the data to the server
                try {
                  final String apiKey = storage.getItem('apiKey');
                  final String serverUrl = storage.getItem('serverUrl');

                  final response =
                      await http.post('$serverUrl/user/~/work', body: {
                    'worktypeID': workDialogState.currentWorktypeID.toString(),
                    'locationID': workDialogState.currentLocationID.toString(),
                    'date': DateFormat('yyyy-MM-dd')
                        .format(workDialogState.currentDate),
                    'time': workDialogState.currentTime.toString(),
                    'description': workDialogState
                        .descriptionController.value.text
                        .toString()
                  }, headers: {
                    'Authorization': 'Bearer $apiKey'
                  });

                  // Make sure its a valid response code
                  if (response.statusCode != 201) {
                    throw AppFailure.httpExecption(response);
                  }

                  // Update the last used
                  await workDialogState.localStorage
                      .setItem('locationID', workDialogState.currentLocationID);
                  await workDialogState.localStorage
                      .setItem('worktypeID', workDialogState.currentWorktypeID);

                  // Reload the home page
                  await dialogReloadHome(context, workDialogState);

                  // Close the dialog
                  Navigator.of(context).pop();
                } on AppFailure catch (error) {
                  error.displayFailure();
                } finally {
                  // Hide the loading animation
                  context.hideLoaderOverlay();
                }
              }
            }));
  }
}
