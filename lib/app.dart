import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/components/drawer.dart';
import 'package:trackless/pages/Home.dart';

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
  initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
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
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
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
            actions: [IconButton(icon: Icon(Icons.refresh), onPressed: () {})],
          ),
          // The active page
          body: _activePage,
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
                  title: Text(AppLocalizations.of(context)
                      .translate('account_page_title')),
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
                AboutTrackless(),
              ],
            ),
          ),
        ));
  }
}
