import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';
import 'package:trackless/trackless/trackless_worktype.dart';

class WorkDialogWorktype extends StatelessWidget {
  const WorkDialogWorktype({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tracklessWorktypeProvider =
        Provider.of<TracklessWorktypeProvider>(context);
    final workDialogState = Provider.of<WorkDialogState>(context);

    List<DropdownMenuItem<int>> items = [];

    // Create the dropdown items
    if (tracklessWorktypeProvider.worktypeList != null) {
      // Add each worktype to the dropdown list
      tracklessWorktypeProvider.worktypeList.forEach((element) {
        items.add(DropdownMenuItem(
          child: Text(element.name),
          value: element.worktypeID,
        ));
      });
    }

    return DropdownButtonFormField<int>(
      // Add the data and the change function
      items: items,
      value: workDialogState.currentWorktypeID,
      onChanged: (value) => workDialogState.currentWorktypeID = value,
      // Make the input look good
      decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context).translate('add_work_worktype'),
          border: OutlineInputBorder(),
          icon: Icon(Icons.work)),

      // Test the input value
      autovalidateMode: AutovalidateMode.always,
      validator: validator(workDialogState, context, 'add_work_worktype'),
    );
  }
}
