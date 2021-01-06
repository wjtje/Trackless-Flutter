import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:trackless/components/drawer/drawer.dart';
import 'package:trackless/global/app_state.dart';
import 'package:trackless/pages/home/home_load.dart';

import 'functions/app_localizations.dart';
import 'main.dart';
import 'pages/home/home.dart';

/// A global key to show skeleton animations without a [BuildContext]
final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    new GlobalKey<ScaffoldMessengerState>();

/// The global app widget
///
/// This widget will show / hide the Floating Action Button,
/// show the correct page and handle navigation.
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with TickerProviderStateMixin<MyApp>, AfterLayoutMixin<MyApp> {
  AnimationController _hideFabAnimation;

  @override
  void initState() {
    super.initState();

    // Create the FAB animation and show it
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();

    // Load the dateFormatting strings
    initializeDateFormatting();
  }

  @override
  void dispose() {
    // Cleanup the animation
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Check if the serverUrl and apiKey is correct bevore loading the home page
    if (storage.getItem('serverUrl') != null &&
        storage.getItem('apiKey') != null) {
      loadHomePage(context);
    }
  }

  // When scrolling down hide the FAB
  // When scrolling up show the FAB
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          // If the user scroll up show the FAB
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          // If the user scrolls down hide the FAB
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          // If the user does nothing
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current active page
    final appState = Provider.of<AppState>(context);
    final activePage = appState.activePage ?? homePage;

    // Listen for changes in scrolling
    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: WillPopScope(
          onWillPop: () async {
            return appState.goPreviousPage(_hideFabAnimation);
          },
          child: Scaffold(
            key: scaffoldKey,

            // The appBar
            appBar: AppBar(
              title: Text(
                  AppLocalizations.of(context).translate(activePage.pageTitle)),
              actions: activePage.appBarActions,
            ),

            // The current active page
            body: activePage.page,

            // Animate the floating action button
            floatingActionButton: FadeTransition(
              opacity: _hideFabAnimation,
              child: ScaleTransition(
                scale: _hideFabAnimation,
                alignment: Alignment.center,
                // Show the correct Floating action button
                child: activePage.floatingActionButton ??
                    appState.previousPage.floatingActionButton,
              ),
            ),

            // The drawer
            drawer: AppDrawer(_hideFabAnimation),
          ),
        ));
  }
}
