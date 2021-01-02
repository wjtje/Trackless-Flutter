import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';

/// Date input box for the work dialog
class WorkDialogDate extends StatelessWidget {
  const WorkDialogDate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputController = new TextEditingController();
    final workDialogState = Provider.of<WorkDialogState>(context);

    // Build the current date string for the input
    inputController.text =
        DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
            .format(workDialogState.currentDate);

    return TextFormField(
      controller: inputController,
      showCursor: false,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('add_work_date'),
          border: OutlineInputBorder(),
          icon: Icon(Icons.calendar_today)),
      onTap: () async {
        // Hide the keyboard
        FocusScope.of(context).requestFocus(new FocusNode());

        // Show the date dialog
        DateTime newDate = await showDatePicker(
            context: context,
            initialDate: workDialogState.currentDate,
            firstDate: DateTime.now().subtract(Duration(days: 73000)),
            lastDate: DateTime.now().add(Duration(days: 73000)));

        // Change the date if its valid
        if (newDate != null) {
          workDialogState.currentDate = newDate;
        }
      },
    );
  }
}
