import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:trackless/app_state.dart';
import 'package:trackless/pages/account/account.dart';
import 'package:trackless/pages/home/home_load.dart';

import 'app_localizations.dart';
import 'components/drawer.dart';
import 'pages/History.dart';
import 'pages/home/home.dart';
import 'pages/account/account_load.dart';

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

    // Show the fab
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();

    // Load the dateFormatting strings
    initializeDateFormatting();
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadHomePage(context);
  }

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
    final appState = Provider.of<AppState>(context);
    final activePage = appState.activePage ?? homePage;

    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scaffold(
          // The appBar
          appBar: AppBar(
            title: Text(
                AppLocalizations.of(context).translate(activePage.pageTitle)),
            actions: activePage.appBarActions,
          ),

          // The active page
          body: activePage.page,

          // Animate the floating action button
          floatingActionButton: FadeTransition(
            opacity: _hideFabAnimation,
            child: ScaleTransition(
              scale: _hideFabAnimation,
              alignment: Alignment.center,
              child: activePage.floatingActionButton,
            ),
          ),

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
                  onTap: () async {
                    appState.activePage = homePage; // Set the page
                    _hideFabAnimation.forward(); // Show the FAB
                    Navigator.of(context).pop(); // Close the drawer

                    // Load the home page details
                    await loadHomePage(context);
                  },
                ),

                // History
                ListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate('history_page_title')),
                  leading: Icon(Icons.history),
                  onTap: () {
                    appState.activePage = historyPage; // Set the page
                    _hideFabAnimation.reverse(); // Hide the FAB
                    Navigator.of(context).pop(); // Close the drawer
                  },
                ),

                // Account
                ListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate('account_page_title')),
                  leading: Icon(Icons.account_box),
                  onTap: () async {
                    appState.activePage = accountPage; // Set the page
                    _hideFabAnimation.reverse(); // Hide the FAB
                    Navigator.of(context).pop(); // Close the drawer

                    // Load the account details
                    await loadAccountPage(context);
                  },
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
                AboutTrackless(),
              ],
            ),
          ),
        ));
  }
}
