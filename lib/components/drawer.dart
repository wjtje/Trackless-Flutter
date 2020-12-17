import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_localizations.dart';
import '../main.dart';

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
          // TODO: translate
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

class AboutTrackless extends StatelessWidget {
  const AboutTrackless({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      icon: Icon(Icons.info),
      applicationIcon: Image(
        image: AssetImage('images/T_icon.png'),
        height: 32,
        width: 32,
      ),
      applicationName: 'Trackless',
      applicationVersion: appVersion,
      applicationLegalese: '\u{a9} 2020 Wouter van der Wal',
      aboutBoxChildren: [
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2,
            children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context)
                          .translate('login_disclaimer') +
                      ' '),
              TextSpan(
                text: 'trackless.ga',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Theme.of(context).accentColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://trackless.ga');
                  },
              ),
              TextSpan(style: Theme.of(context).textTheme.bodyText2, text: '.'),
            ],
          ),
        ),
      ],
    );
  }
}
