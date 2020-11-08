import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkDialog extends StatefulWidget {
  WorkDialog({Key key}) : super(key: key);

  @override
  _WorkDialogState createState() => _WorkDialogState();
}

class _WorkDialogState extends State<WorkDialog> {
  // For storing the date
  DateTime _dateTime = DateTime.now();

  // For controlling the TextFormField
  final TextEditingController _dateInput = new TextEditingController();
  final TextEditingController _descriptionInput = new TextEditingController();
  final TextEditingController _timeInput = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Show the correct date in the input
    _dateInput.text =
        '${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
        title: Text('Werk toevoegen'),
        actions: [
          TextButton(
            child: Text('Save'),
            onPressed: () {
              // TODO: Add it into the bloc

              // Close the widget
              Navigator.of(context).pop();
            },
          )
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
                  labelText: 'Date',
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
            // SizedBox(height: 12,),
            // DropdownButtonFormField(
            //   value: _locationOption,
            //   items: _locations,
            //   onChanged: (int newValue) {
            //     setState(() {
            //       _locationOption = newValue;
            //     });
            //   },
            //   decoration: InputDecoration(
            //     labelText: 'Location'
            //   ),
            // ),
            // Input description
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _descriptionInput,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              decoration: InputDecoration(
                  labelText: 'Description',
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
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.access_time)),
              keyboardType: TextInputType.number,
              inputFormatters: [
                // TODO make sure the time format is correct
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
              ],
            ),
            // Worktype input
            // SizedBox(height: 12,),
            // DropdownButtonFormField(
            //   value: _worktypeOption,
            //   items: _worktypes,
            //   onChanged: (int newValue) {
            //     setState(() {
            //       _worktypeOption = newValue;
            //     });
            //   },
            //   decoration: InputDecoration(
            //     labelText: 'Worktype'
            //   ),
            // )
          ])),
    );
  }
}
