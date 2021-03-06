import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/functions/input_validator.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';

class WorkDialogDescription extends StatelessWidget {
  const WorkDialogDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workDialogState = Provider.of<WorkDialogState>(context);

    return TextFormField(
      controller: workDialogState.descriptionController,
      // Make sure multiple lines look good
      minLines: 1,
      maxLines: 4,
      // Make the text field look good
      decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context).translate('add_work_description'),
          border: OutlineInputBorder(),
          icon: Icon(Icons.text_fields)),
      // Test the input value
      autovalidateMode: AutovalidateMode.always,
      validator: inputValidator(
          workDialogState.showInputError, context, 'add_work_description'),
    );
  }
}
