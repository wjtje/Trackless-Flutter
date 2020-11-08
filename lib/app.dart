import 'package:flutter/material.dart';
import 'package:trackless/components/drawer.dart';
import 'package:trackless/pages/Home.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // The app state
  String _appBarTitle = '';
  Widget _activePage;
  Widget _floatingActionButton;

  _MyAppState() {
    _appBarTitle = 'Deze week';
    _activePage = HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The appBar
      appBar: AppBar(
        title: Text(_appBarTitle),
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
              title: Text('Deze week'),
              leading: Icon(Icons.home),
              onTap: () {
                // Show the correct page
                setState(() {});

                // Close the drawer
                Navigator.of(context).pop();
              },
            ),
            // History
            ListTile(title: Text('Geschidenis'), leading: Icon(Icons.history)),
            // Account
            ListTile(
              title: Text('Account'),
              leading: Icon(Icons.account_box),
            ),
            // Other options
            Divider(),
            // Settigns
            ListTile(
              title: Text('Instellingen'),
              leading: Icon(Icons.settings),
            ),
            // About
            ListTile(
              title: Text('Over app'),
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
