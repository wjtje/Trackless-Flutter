import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/bloc/location_bloc.dart';
import 'package:trackless/bloc/work_storage.dart';
import 'package:trackless/bloc/worktype_bloc.dart';
import 'package:trackless/main.dart';
import 'package:trackless/models/location.dart';
import 'package:trackless/models/user.dart';
import 'package:trackless/models/work.dart';
import 'package:trackless/models/worktype.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:http/http.dart' as http;

class WorkDialog extends StatefulWidget {
  final Work editWork;

  WorkDialog({Key key, this.editWork}) : super(key: key);

  @override
  _WorkDialogState createState() => _WorkDialogState();
}

class _WorkDialogState extends State<WorkDialog> {
  // For storing the work
  WorkStorage _workStorage = WorkStorage();

  // For storing the date
  DateTime _dateTime = DateTime.now();
  DateTime _editDate;

  // For the location dropdown
  final _locationBloc = LocationBloc();
  int locationID;

  // For the worktype dropdown
  final WorktypeBloc _worktypeBloc = WorktypeBloc();
  int worktypeID;

  // For controlling the TextFormField
  final TextEditingController _dateInput = new TextEditingController();
  final TextEditingController _descriptionInput = new TextEditingController();
  final TextEditingController _timeInput = new TextEditingController();

  @override
  void initState() {
    // Load the details from the edit
    if (widget.editWork != null) {
      print('Work: edit work');

      _dateTime = DateTime.parse(widget.editWork.date);
      _editDate = DateTime.parse(widget.editWork.date); // The org date
      locationID = widget.editWork.location.locationID;
      _descriptionInput.text = widget.editWork.description;
      _timeInput.text = widget.editWork.time.toString();
      worktypeID = widget.editWork.worktype.worktypeID;
    } else {
      _editDate = null;

      // Get last used
      locationID = storage.getItem('editWorkLocation');
      worktypeID = storage.getItem('editWorkWorkType');
    }

    super.initState();
  }

  Future<void> saveWork(BuildContext context) async {
    // Save the work to the server
    print('Work: saving to the server');
    final String apiKey = storage.getItem('apiKey');
    final String serverUrl = storage.getItem('serverUrl');
    final response = await http.post('$serverUrl/user/~/work', body: {
      'worktypeID': worktypeID.toString() ?? '0',
      'locationID': locationID.toString() ?? '0',
      'date':
          '${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()}',
      'time': double.tryParse(_timeInput.value.text).toString() ?? 0.toString(),
      'description': _descriptionInput.value.text ?? ''
    }, headers: {
      'Authorization': 'Bearer $apiKey'
    });

    print('Work: ${response.statusCode}');

    if (response.statusCode == 201) {
      // Save it to localStorage
      _workStorage.saveWork(new Work(
        // Get the workID from the response
        workID: json.decode(response.body)['workID'],
        date:
            '${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()}',
        description: _descriptionInput.value.text,
        time: double.tryParse(_timeInput.value.text) ?? 0,
        // TODO: select the correct user
        user: new User(
            userID: 0,
            firstname: 'TODO:',
            lastname: 'TODO:',
            username: 'TODO:',
            groupID: 0,
            groupName: 'TODO:'),
        location: _locationBloc.getById(locationID),
        worktype: _worktypeBloc.getById(worktypeID),
      ));

      Navigator.of(context).pop();
    } else {
      // Couldn't save your work
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context).translate('add_work_saveError')),
      ));
    }
  }

  Future<void> updateWork(BuildContext context) async {
    // Update the work
    print('Work: saving to the server');
    final String apiKey = storage.getItem('apiKey');
    final String serverUrl = storage.getItem('serverUrl');
    final response = await http.patch('$serverUrl/user/~/work/${widget.editWork.workID}', body: {
      'worktypeID': worktypeID.toString() ?? '0',
      'locationID': locationID.toString() ?? '0',
      'date':
          '${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()}',
      'time': double.tryParse(_timeInput.value.text).toString() ?? 0.toString(),
      'description': _descriptionInput.value.text ?? ''
    }, headers: {
      'Authorization': 'Bearer $apiKey'
    });

    print('Work: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Save it to localStorage
      _workStorage.updateWork(new Work(
        // Get the workID from the response
        workID: widget.editWork.workID,
        date:
            '${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()}',
        description: _descriptionInput.value.text,
        time: double.tryParse(_timeInput.value.text) ?? 0,
        // TODO: select the correct user
        user: new User(
            userID: 0,
            firstname: 'TODO:',
            lastname: 'TODO:',
            username: 'TODO:',
            groupID: 0,
            groupName: 'TODO:'),
        location: _locationBloc.getById(locationID),
        worktype: _worktypeBloc.getById(worktypeID),
      ), _editDate);

      Navigator.of(context).pop();
    } else {
      // Couldn't save your work
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context).translate('add_work_saveError')),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show the correct date in the input
    _dateInput.text =
        '${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        // Change black to white
        iconTheme:
            Theme.of(context).accentIconTheme.copyWith(color: Colors.white),
        textTheme:
            Theme.of(context).accentTextTheme.apply(bodyColor: Colors.white),
        // Show the app bar
        title: Text(AppLocalizations.of(context).translate('add_work_title')),
        actions: [
          Builder(
              builder: (context) => IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    // TODO: Test the data

                    // Update the last used
                    storage.setItem('editWorkLocation', locationID);
                    storage.setItem('editWorkWorkType', worktypeID);

                    // Hide the keyboard and show loading animation
                    FocusScope.of(context).requestFocus(new FocusNode());
                    context.showLoaderOverlay();

                    if (widget.editWork == null) {
                      await saveWork(context);
                    } else {
                      await updateWork(context);
                    }

                    // Close the widget
                    context.hideLoaderOverlay();
                  }))
        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.topLeft,
          child: ListView(children: [
            // Date input
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _dateInput,
              showCursor: false,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).translate('add_work_date'),
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today)),
              onTap: () async {
                // Don't show a keyboard
                FocusScope.of(context).requestFocus(new FocusNode());

                // Show the date dialog
                DateTime newDate = await showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200));

                // Save the date when it is new
                if (newDate != null) {
                  setState(() {
                    _dateTime = newDate;
                  });
                }
              },
            ),
            // Location input
            SizedBox(
              height: 12,
            ),
            StreamBuilder(
                stream: _locationBloc.location,
                initialData: new List<Location>(),
                builder: (context, AsyncSnapshot<List<Location>> snapshot) {
                  List<DropdownMenuItem<int>> items = [];

                  // Create a list with all the options
                  snapshot.data.forEach((element) {
                    items.add(DropdownMenuItem(
                      child: Text(element.place + ' - ' + element.name),
                      value: element.locationID,
                    ));
                  });

                  return DropdownButtonFormField<int>(
                    items: items,
                    value: locationID,
                    isExpanded: true,
                    onChanged: (int newValue) {
                      // Update the value
                      setState(() {
                        locationID = newValue;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('add_work_location'),
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.location_on)),
                  );
                }),
            // Input description
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _descriptionInput,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate('add_work_description'),
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.text_fields)),
            ),
            // Input Time
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _timeInput,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).translate('add_work_time'),
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.access_time)),
              keyboardType: TextInputType.number,
              inputFormatters: [
                // TODO: make sure the time format is correct
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
              ],
            ),
            // Worktype input
            SizedBox(
              height: 12,
            ),
            StreamBuilder(
                stream: _worktypeBloc.worktype,
                initialData: new List<Worktype>(),
                builder: (context, AsyncSnapshot<List<Worktype>> snapshot) {
                  List<DropdownMenuItem<int>> items = [];

                  // Create a list with all the options
                  snapshot.data.forEach((element) {
                    items.add(DropdownMenuItem(
                      child: Text(element.name),
                      value: element.worktypeID,
                    ));
                  });

                  return DropdownButtonFormField<int>(
                    items: items,
                    value: worktypeID,
                    isExpanded: true,
                    onChanged: (int newValue) {
                      // Update the value
                      setState(() {
                        worktypeID = newValue;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('add_work_workType'),
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.work)),
                  );
                }),
          ])),
    );
  }
}
