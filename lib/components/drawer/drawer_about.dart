import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/functions/app_version.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawerAbout extends StatelessWidget {
  /// A custom drawer option for showing the about this app option
  ///
  /// This will include the app name, icon and other information
  const AppDrawerAbout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      icon: Icon(Icons.info),
      // Show the correct app information
      applicationName: 'Trackless',
      applicationVersion: appVersion(),
      applicationLegalese: '\u{a9} 2020 Wouter van der Wal (wjtje)',
      applicationIcon: Image(
        image: AssetImage('images/ic_launcher.png'),
        width: 32,
        height: 32,
      ),
      // Show a basic disclaimer
      aboutBoxChildren: [
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2,
            children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context)
                      .translate('login_disclaimer')
                      .split('%')[0]),
              TextSpan(
                text: 'sentry.io',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Theme.of(context).accentColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://sentry.io/privacy/');
                  },
              ),
              TextSpan(
                  text: AppLocalizations.of(context)
                      .translate('login_disclaimer')
                      .split('%')[1]),
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
              TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  text: AppLocalizations.of(context)
                      .translate('login_disclaimer')
                      .split('%')[2]),
            ],
          ),
        ),
      ],
    );
  }
}
