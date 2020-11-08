import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trackless/bloc/work_bloc.dart';
import 'package:trackless/bloc/work_event.dart';
import 'package:trackless/components/drawer.dart';
import 'package:trackless/date.dart';
import 'package:trackless/main.dart';
import 'package:trackless/models/login.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  // Define text controllers
  final _serverInputController = TextEditingController();
  final _usernameInputController = TextEditingController();
  final _passwordInputController = TextEditingController();
  final _deviceNameInputController = TextEditingController();

  _onLoginPressed(BuildContext context) {
    return () async {
      print('Login: Checking values');

      // Check the input values
      String serverUrl = _serverInputController.value.text;
      String username = _usernameInputController.value.text;
      String password = _passwordInputController.value.text;
      String deviceName = _deviceNameInputController.value.text;

      if (serverUrl == '' || username == '' || password == '') {
        // Somethings missing
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Niet alle verplichte velden zijn ingevult'),
        ));
      } else {
        // Test the serverURl
        if (!serverUrl.contains('https://') && !serverUrl.contains('http://')) {
          // Add https
          serverUrl = 'https://$serverUrl';

          print('Login: New serverUrl: "$serverUrl"');
        }

        if (serverUrl[serverUrl.length - 1] == '/') {
          // Add /
          serverUrl = serverUrl.substring(0, serverUrl.length - 1);

          print('Login: New serverUrl: "$serverUrl"');
        }

        // Test the deviceName
        if (deviceName == '') {
          deviceName = '$username\'s device';

          print('Login: New deviceName: "$deviceName"');
        }

        // Send to sever
        final response = await http.post('$serverUrl/login', body: {
          'username': username,
          'password': password,
          'deviceName': deviceName
        });

        if (response.statusCode != 200) {
          // Somethings wrong
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Gebruikers naam of wachtwoord fout'),
          ));
        } else {
          // Save the apikey
          final Login res = Login.fromJson(json.decode(response.body));

          await storage.setItem('apiKey', res.bearer);
          await storage.setItem('serverUrl', serverUrl);

          print('Login: Your apiKey: "${res.bearer}"');

          // Start loading data
          final _workBloc = WorkBloc(
              startDate: firstDayOfWeek(DateTime.parse("2020-11-02")),
              endDate: firstDayOfWeek(DateTime.parse("2020-11-02"))
                  .add(Duration(days: 6)));

          _workBloc.workEventSink.add(LoadWorkFromServer());

          _workBloc.dispose();

          // Go to the homepage
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inloggen'),
        ),
        // The login drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              TracklessDrawerHeader(),
              ListTile(
                title: Text('Inloggen'),
                leading: Icon(Icons.login),
                onTap: () => Navigator.pop(context),
              ),
              TracklessDrawerAppVersion()
            ],
          ),
        ),
        // The login page
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          children: <Widget>[
            // Make sure every thing in centered
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Make sure the maxWidth is 400
                LimitedBox(
                  // Choose the device width if that is smaller
                  maxWidth: ((MediaQuery.of(context).size.width - 32) < 400)
                      ? (MediaQuery.of(context).size.width - 32)
                      : 400,
                  child: Column(
                    children: [
                      // Title
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Trackless',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                      // User inputs
                      SizedBox(
                        height: 30.0,
                      ),
                      // Input server
                      TextField(
                          controller: _serverInputController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Server',
                              icon: Icon(Icons.http))),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Input username
                      TextField(
                        controller: _usernameInputController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Gebruikersnaam',
                            icon: Icon(Icons.person)),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Input password
                      TextField(
                        controller: _passwordInputController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Wachtwoord',
                            icon: Icon(Icons.vpn_key)),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Input deviceName
                      TextField(
                        controller: _deviceNameInputController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Apparaat naam',
                            icon: Icon(Icons.devices)),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Login button
                      Builder(
                        builder: (context) => ButtonTheme(
                          minWidth: double.infinity,
                          child: RaisedButton(
                            child: Text('Inloggen',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: _onLoginPressed(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
