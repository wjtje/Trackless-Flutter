import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';

/// A basic add button for the home page
class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        // Define the Floating Action Button
        closedShape: CircleBorder(),
        closedColor: Theme.of(context).colorScheme.secondary,
        closedBuilder: (context, openContainer) => FloatingActionButton(
            child: Icon(Icons.add), onPressed: openContainer),
        // Define the workdialog
        openColor: Theme.of(context).scaffoldBackgroundColor,
        openBuilder: (context, closeContainer) => WorkDialog(null));
  }
}
