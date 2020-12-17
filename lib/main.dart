import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info/package_info.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sentry/sentry.dart';

import 'app.dart';
import 'app_localizations.dart';
import 'bloc/location_bloc.dart';
import 'bloc/location_event.dart';
import 'bloc/worktype_bloc.dart';
import 'bloc/worktype_event.dart';
import 'pages/Login.dart';
import 'theme/dark.dart';
import 'theme/light.dart';
import 'dsn.dart';

// Global var for storing sentry
// This is used for debugging
final SentryClient sentry = new SentryClient(dsn: dsn);

// A global var for storing the appVersion name
// It will be build in the main()
String appVersion = ''; // Make sure it is not null

// Global LocalStorage
LocalStorage storage;
Stream<Map<String, dynamic>> storageSteam;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the localStorage
  storage = LocalStorage('tracklessLocalStorage');

  storage.onError.addListener(() {
    print('FAILED TO INIT STORAGE!');
  });

  // Get the package info
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    // Build the appVersion string
    appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
  });

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

    // Reset the work date
    storage.setItem(
        'editWorkDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));

    // Start the app
    runZoned(
      () {
        runApp(BaseApp(
          initRoute: initPage,
        ));

        // Catching flutter error's
        FlutterError.onError = (details, {bool forceReport = false}) {
          try {
            sentry.captureException(
              exception: details.exception,
              stackTrace: details.stack,
            );
          } catch (e) {
            print('Sending report to sentry.io failed: $e');
          } finally {
            // Also use Flutter's pretty error logging to the device's console.
            FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
          }
        };

        // Load basic data from server
        final WorktypeBloc worktypeBloc = WorktypeBloc();
        worktypeBloc.worktypeEventSink.add(LoadWorktypeFromServer());
        worktypeBloc.dispose();

        final LocationBloc locationBloc = LocationBloc();
        locationBloc.locationEventSink.add(LoadLocationFromServer());
        locationBloc.dispose();
      },
      // Catching error's
      onError: (Object error, StackTrace stackTrace) {
        try {
          sentry.captureException(
            exception: error,
            stackTrace: stackTrace,
          );
          print('Error sent to sentry.io: $error');
        } catch (e) {
          print('Sending report to sentry.io failed: $e');
          print('Original error: $error');
        }
      },
    );
  });
}
class BaseApp extends StatelessWidget {
  final String initRoute;
  final RouteObserver routeObserver = RouteObserver<PageRoute>();

  BaseApp({Key key, this.initRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: true,
      child: MaterialApp(
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
        // Import
        supportedLocales: [Locale('en'), Locale('nl')],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          // Find the correct language
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }

          // If the language is not supported load the first lang (en)
          return supportedLocales.first;
        },
      ),
    );
  }
}
