import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_version.dart';
// import 'package:sentry/sentry.dart';
import 'package:trackless/global/async_state.dart';
import 'package:trackless/trackless/trackless_account.dart';
import 'package:trackless/trackless/trackless_location.dart';
import 'package:trackless/trackless/trackless_work.dart';
import 'package:trackless/trackless/trackless_worktype.dart';

import 'app.dart';
import 'functions/app_localizations.dart';
import 'global/app_state.dart';
import 'pages/Login.dart';
import 'theme/dark.dart';
import 'theme/light.dart';
// import 'dsn.dart';

// Global var for storing sentry
// This is used for debugging
// final SentryClient sentry = new SentryClient(dsn: dsn);

// Global LocalStorage
LocalStorage storage;

void main() {
  // Make sure the app has started
  WidgetsFlutterBinding.ensureInitialized();

  // Get the package info
  getPackageInfo();

  // Open the localStorage
  storage = LocalStorage('tracklessLocalStorage');

  // Give the user notice something gone wrong
  storage.onError.addListener(() {
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text('Failed to init storage'),
      backgroundColor: Colors.red,
    ));
  });

  // Wait for the storage to start
  storage.ready.then((value) {
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
    // Catching error's
    runZonedGuarded(() {
      runApp(BaseApp(
        initRoute: initPage,
      ));

      // Catching flutter error's
      // FlutterError.onError = (details, {bool forceReport = false}) {
      //   try {
      //     sentry.captureException(
      //       exception: details.exception,
      //       stackTrace: details.stack,
      //     );
      //   } catch (e) {
      //     print('Sending report to sentry.io failed: $e');
      //   } finally {
      //     // Also use Flutter's pretty error logging to the device's console.
      //     FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
      //   }
      // };
    }, (Object error, StackTrace stackTrace) {
      // try {
      //   sentry.captureException(
      //     exception: error,
      //     stackTrace: stackTrace,
      //   );
      //   print('Error sent to sentry.io: $error');
      // } catch (e) {
      //   print('Sending report to sentry.io failed: $e');
      //   print('Original error: $error');
      // }
    });
  });
}

class BaseApp extends StatelessWidget {
  final String initRoute;
  final RouteObserver routeObserver = RouteObserver<PageRoute>();

  BaseApp({Key key, this.initRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // Load all the global providers
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider(create: (_) => AsyncState()),
          ChangeNotifierProvider(create: (_) => TracklessAccount()),
          ChangeNotifierProvider(create: (_) => TracklessWorkProvider()),
          ChangeNotifierProvider(create: (_) => TracklessLocationProvider()),
          ChangeNotifierProvider(create: (_) => TracklessWorktypeProvider()),
        ],
        child: GlobalLoaderOverlay(
          useDefaultLoading: true,
          child: GetMaterialApp(
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
            // Import the localizations stuff
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
        ));
  }
}
