import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trackless/components/drawer/drawer_about.dart';
import 'package:trackless/components/drawer/drawer_header.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/app_localizations.dart';
import '../main.dart';
import '../models/login.dart';
import 'home/home_load.dart';

// TODO: need to improve the login page

class LoginPage extends StatelessWidget {
  // Define text controllers
  final _serverInputController = TextEditingController();
  final _usernameInputController = TextEditingController();
  final _passwordInputController = TextEditingController();
  final _deviceNameInputController = TextEditingController();

  _onLoginPressed(BuildContext context) {
    return () async {
      context.showLoaderOverlay();

      print('Login: Checking values');

      // Check the input values
      String serverUrl = _serverInputController.value.text;
      String username = _usernameInputController.value.text;
      String password = _passwordInputController.value.text;
      String deviceName = _deviceNameInputController.value.text;

      if (serverUrl == '' || username == '' || password == '') {
        // Somethings missing
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).translate('login_error')),
        ));

        context.hideLoaderOverlay();
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
        try {
          final response = await http.post('$serverUrl/login', body: {
            'username': username,
            'password': password,
            'deviceName': deviceName
          });

          context.hideLoaderOverlay();

          if (response.statusCode != 200) {
            // Somethings wrong
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)
                  .translate('login_password_error')),
            ));
          } else {
            // Save the apikey
            final Login res = Login.fromJson(json.decode(response.body));

            await storage.setItem('apiKey', res.bearer);
            await storage.setItem('serverUrl', serverUrl);

            print('Login: Your apiKey: "${res.bearer}"');

            // Go to the homepage
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

            // Load the home page
            loadHomePage(context);
          }
        } on StateError catch (_) {
          // Can not use HTTP
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context).translate('login_http_error')),
          ));
        } finally {
          context.hideLoaderOverlay();
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
          title: Text(AppLocalizations.of(context).translate('login_title')),
        ),
        // The login drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              AppDrawerHeader(),
              ListTile(
                title:
                    Text(AppLocalizations.of(context).translate('login_title')),
                leading: Icon(Icons.login),
                onTap: () => Navigator.pop(context),
              ),
              AppDrawerAbout(),
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
                              labelText: AppLocalizations.of(context)
                                  .translate('login_server'),
                              icon: Icon(Icons.http))),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Input username
                      TextField(
                        controller: _usernameInputController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)
                                .translate('login_username'),
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
                            labelText: AppLocalizations.of(context)
                                .translate('login_password'),
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
                            labelText: AppLocalizations.of(context)
                                .translate('login_deviceName'),
                            icon: Icon(Icons.devices)),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Login button
                      Builder(
                        builder: (context) => Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate('login_btn'),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            onPressed: _onLoginPressed(context),
                          ),
                        ),
                      ),
                      // Disclaimer
                      SizedBox(
                        height: 10,
                      ),
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
                                  .copyWith(
                                      color: Theme.of(context).accentColor),
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
                                  .copyWith(
                                      color: Theme.of(context).accentColor),
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
