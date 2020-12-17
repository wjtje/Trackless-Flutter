import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_localizations.dart';
import 'components/drawer.dart';
import 'pages/History.dart';
import 'pages/Home.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin<MyApp> {
  // The app state
  String _appBarTitle = 'this_week_page_title';
  Widget _activePage = HomePage();
  Widget _floatingActionButton = homePageFloatingActionButton;

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
    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scaffold(
          // The appBar
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate(_appBarTitle)),
          ),
          // The active page
          body: _activePage,

          // Animate the floating action button
          floatingActionButton: FadeTransition(
            opacity: _hideFabAnimation,
            child: ScaleTransition(
              scale: _hideFabAnimation,
              alignment: Alignment.center,
              child: _floatingActionButton,
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
                  onTap: () {
                    // Show the correct page
                    if (_appBarTitle != 'this_week_page_title') {
                      _hideFabAnimation.forward(); // Show the FAB

                      setState(() {
                        _appBarTitle = 'this_week_page_title';
                        _activePage = HomePage();
                        _floatingActionButton = homePageFloatingActionButton;
                      });
                    }

                    // Close the drawer
                    Navigator.of(context).pop();
                  },
                ),
                // History
                ListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate('history_page_title')),
                  leading: Icon(Icons.history),
                  onTap: () {
                    // Show the correct page
                    if (_appBarTitle != 'history_page_title') {
                      _hideFabAnimation.reverse(); // Hide the FAB

                      setState(() {
                        _appBarTitle = 'history_page_title';
                        _activePage = HistoryPage();
                        _floatingActionButton = null;
                      });
                    }

                    // Close the drawer
                    Navigator.of(context).pop();
                  },
                ),
                // Account
                ListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate('account_page_title')),
                  leading: Icon(Icons.account_box),
                  onTap: () async {},
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
