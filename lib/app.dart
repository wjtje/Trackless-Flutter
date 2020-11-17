import 'package:flutter/material.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/components/drawer.dart';
import 'package:trackless/pages/Home.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // The app state
  String _appBarTitle = 'this_week_page_title';
  Widget _activePage = HomePage();
  Widget _floatingActionButton = homePageFloatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The appBar
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(_appBarTitle)),
      ),
      // The active page
      body: _activePage,
      floatingActionButton: _floatingActionButton,
      // The drawer
      drawer: Drawer(
        child: ListView(
          children: [
            // Header
            TracklessDrawerHeader(),
            // This week
            ListTile(
              title: Text(AppLocalizations.of(context)
                  .translate('this_week_page_title')),
              leading: Icon(Icons.home),
              onTap: () {
                // Show the correct page
                setState(() {});

                // Close the drawer
                Navigator.of(context).pop();
              },
            ),
            // History
            ListTile(
                title: Text(AppLocalizations.of(context)
                    .translate('history_page_title')),
                leading: Icon(Icons.history)),
            // Account
            ListTile(
              title: Text(
                  AppLocalizations.of(context).translate('account_page_title')),
              leading: Icon(Icons.account_box),
            ),
            // Other options
            Divider(),
            // Settigns
            ListTile(
              title: Text(AppLocalizations.of(context)
                  .translate('settings_page_title')),
              leading: Icon(Icons.settings),
            ),
            // About
            ListTile(
              title: Text(
                  AppLocalizations.of(context).translate('about_page_title')),
              leading: Icon(Icons.info),
            ),
            // App version
            Divider(),
            TracklessDrawerAppVersion(),
          ],
        ),
      ),
    );
  }
}
