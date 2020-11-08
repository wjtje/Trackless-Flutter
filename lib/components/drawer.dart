import 'package:flutter/material.dart';

import '../common.dart';

/// Quickly make the custom Trackless drawer header
class TracklessDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Title
          Text(
            'Trackless',
            style: Theme.of(context).textTheme.headline6.apply(
                // Make sure the text is readable on the background
                color: Theme.of(context).colorScheme.onSecondary),
          ),
          // Subtitle
          Text('Alpha (Niet voor productie gebruik)',
              style: Theme.of(context).textTheme.subtitle1.apply(
                  // Make sure the text is readable on the background
                  color: Theme.of(context).colorScheme.onSecondary))
        ],
      ),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
    );
  }
}

/// Display the appVersion in the drawer
class TracklessDrawerAppVersion extends StatefulWidget {
  @override
  _TracklessDrawerAppVersionState createState() =>
      _TracklessDrawerAppVersionState();
}

class _TracklessDrawerAppVersionState extends State<TracklessDrawerAppVersion> {
  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(appVersion),
      onTap: () {
        _tapCount++;

        if (_tapCount == 5) {
          Navigator.pop(context);

          // Show a snackbar
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('There aren\'t any developer option. Yet....'),
            duration: Duration(seconds: 10),
          ));

          _tapCount = 0;
        }

        setState(() {
          _tapCount = _tapCount;
        });
      },
    );
  }
}
