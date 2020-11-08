import 'package:flutter/material.dart';
import 'package:trackless/app.dart';
import 'package:trackless/pages/Login.dart';
import 'package:trackless/theme/dark.dart';
import 'package:trackless/theme/light.dart';
import 'package:localstorage/localstorage.dart';

// Global LocalStorage
LocalStorage storage;
Stream<Map<String, dynamic>> storageSteam;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the localStorage
  storage = LocalStorage('tracklessLocalStorage');

  // Wait for the storage to start
  storage.ready.then((value) {
    // Create a broadcast stream that blocs can listen for changes
    storageSteam = storage.stream.asBroadcastStream();

    // Load the correct page
    String initPage = '/';

    String apiKey = storage.getItem('apiKey');
    String serverUrl = storage.getItem('serverUrl');

    print({'apiKey': apiKey, 'serverUrl': serverUrl});

    // Check the apiKey
    if (apiKey == null || serverUrl == null) {
      initPage = '/login';
    }

    // Start the app
    runApp(BaseApp(
      initRoute: initPage,
    ));
  });
}

class BaseApp extends StatelessWidget {
  final String initRoute;
  final RouteObserver routeObserver = RouteObserver<PageRoute>();

  BaseApp({Key key, this.initRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackless',
      // Create the base navigation
      initialRoute: this.initRoute,
      routes: {
        '/': (context) => MyApp(),
        '/login': (context) => LoginPage(),
      },
      navigatorObservers: [routeObserver],
      // Import the themes
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
