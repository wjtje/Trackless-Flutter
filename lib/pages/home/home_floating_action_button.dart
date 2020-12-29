import 'package:flutter/material.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';

/// A basic add button for the home page
class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Show the workdialog
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => WorkDialog()));
        });
  }
}
