import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/functions/input_validator.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';
import 'package:trackless/trackless/trackless_location.dart';

class WorkDialogLocation extends StatelessWidget {
  const WorkDialogLocation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tracklessLocationProvider =
        Provider.of<TracklessLocationProvider>(context);
    final workDialogState = Provider.of<WorkDialogState>(context);

    List<DropdownMenuItem<int>> items = [];

    // Create the dropdown items
    if (tracklessLocationProvider.locationList != null) {
      // Add each location to the dropdown list
      tracklessLocationProvider.locationList.forEach((element) {
        items.add(DropdownMenuItem(
          child: Text(element.fullName),
          value: element.locationID,
        ));
      });
    }

    return DropdownButtonFormField<int>(
      items: items,
      value: workDialogState.currentLocationID,
      onChanged: (value) => workDialogState.currentLocationID = value,
      // Make the input look good
      decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context).translate('add_work_location'),
          border: OutlineInputBorder(),
          icon: Icon(Icons.location_on)),
      // Test the input value
      autovalidateMode: AutovalidateMode.always,
      validator: inputValidator(
          workDialogState.showInputError, context, 'add_work_location'),
    );
  }
}
