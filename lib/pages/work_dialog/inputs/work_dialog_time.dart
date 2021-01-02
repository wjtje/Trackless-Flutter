import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';

class WorkDialogTime extends StatelessWidget {
  const WorkDialogTime({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workDialogState = Provider.of<WorkDialogState>(context);

    return TextFormField(
      controller: workDialogState.timeController,
      // Make the text field look good
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('add_work_time'),
          border: OutlineInputBorder(),
          icon: Icon(Icons.access_time)),
      keyboardType: TextInputType.number,
      // Test the input value
      autovalidateMode: AutovalidateMode.always,
      validator: validator(workDialogState, context, 'add_work_time'),
    );
  }
}
