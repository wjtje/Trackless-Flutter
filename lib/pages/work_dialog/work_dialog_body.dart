import 'package:flutter/material.dart';
import 'package:trackless/pages/work_dialog/inputs/work_dialog_date.dart';
import 'package:trackless/pages/work_dialog/inputs/work_dialog_description.dart';
import 'package:trackless/pages/work_dialog/inputs/work_dialog_location.dart';
import 'package:trackless/pages/work_dialog/inputs/work_dialog_time.dart';
import 'package:trackless/pages/work_dialog/inputs/work_dialog_worktype.dart';

class WorkDialogBody extends StatelessWidget {
  const WorkDialogBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        WorkDialogDate(),
        SizedBox(
          height: 16,
        ),
        WorkDialogLocation(),
        SizedBox(
          height: 16,
        ),
        WorkDialogDescription(),
        SizedBox(
          height: 16,
        ),
        WorkDialogTime(),
        SizedBox(
          height: 16,
        ),
        WorkDialogWorktype(),
      ],
    );
  }
}
