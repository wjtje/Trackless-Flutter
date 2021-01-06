import 'package:flutter/material.dart';
import 'package:trackless/main.dart';

class AppDrawerHeader extends StatelessWidget {
  /// A custom drawer header for this app
  ///
  /// This drawer header will show the app name and the version
  const AppDrawerHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // The app title
            Text(
              'Trackless',
              style: Theme.of(context).textTheme.headline6.apply(
                  // Make sure the text is readable on the background
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
            // The version number
            Text(appVersion,
                style: Theme.of(context).textTheme.bodyText2.apply(
                    // Make sure the text is readable on the background
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(0.74)))
          ],
        ));
  }
}
