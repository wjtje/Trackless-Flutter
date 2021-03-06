import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_failure.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trackless/main.dart';
import 'package:http/http.dart' as http;

import '../work_dialog.dart';

class WorkDialogDelete extends StatelessWidget {
  const WorkDialogDelete({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workDialogState = Provider.of<WorkDialogState>(context);

    Future<void> onRemove() async {
      // Show loader
      context.showLoaderOverlay();

      // Try to remove the data
      try {
        final String apiKey = storage.getItem('apiKey');
        final String serverUrl = storage.getItem('serverUrl');

        final response = await http.delete(
            '$serverUrl/user/~/work/${workDialogState.currentWorkID}',
            headers: {'Authorization': 'Bearer $apiKey'});

        // Make sure its a valid response code
        if (response.statusCode != 200) {
          throw AppFailure.httpExecption(response);
        }

        // Reload the home page
        await dialogReloadHome(context, workDialogState);

        // Close the alert and dialog
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } on AppFailure catch (error) {
        error.displayFailure();
      } finally {
        // Hide the loading animation
        context.hideLoaderOverlay();
      }
    }

    return Visibility(
        visible: workDialogState.editWork != null,
        child: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () {
            // Ask the user
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text(AppLocalizations.of(context)
                          .translate('add_work_removeTitle')),
                      content: Text(AppLocalizations.of(context)
                          .translate('add_work_removeBody')),
                      actions: [
                        TextButton(
                          child: Text(AppLocalizations.of(context)
                              .translate('add_work_removeButton')
                              .toUpperCase()),
                          onPressed: () => {onRemove()},
                        )
                      ],
                    ));
          },
        ));
  }
}
