import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/components/drawer/drawer_about.dart';
import 'package:trackless/components/drawer/drawer_header.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/global/app_state.dart';
import 'package:trackless/pages/account/account.dart';
import 'package:trackless/pages/history/history.dart';
import 'package:trackless/pages/home/home.dart';

class AppDrawer extends StatelessWidget {
  final AnimationController fabAnimation;

  /// A custom drawer shown over the whole app
  ///
  /// This fabAnimation is used to show / hide the FAB button
  ///
  /// TODO: Hide / show options based on the users access
  /// TODO: Combine the login drawer with this one
  const AppDrawer(this.fabAnimation, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Don't listen becuse the ui doesn't need to update
    final appState = Provider.of<AppState>(context);
    final activePage = appState.activePage?.pageTitle ?? homePage.pageTitle;

    return Drawer(
      child: ListView(
        children: [
          AppDrawerHeader(),

          // This week
          ListTile(
            selected: activePage == homePage.pageTitle,
            title: Text(
                AppLocalizations.of(context).translate(homePage.pageTitle)),
            leading: Icon(Icons.home),
            onTap: () {
              appState.activePage = homePage; // Set the page
              fabAnimation.forward(); // Show the FAB
              Navigator.of(context).pop(); // Close the drawer
            },
          ),

          // History
          ListTile(
            selected: activePage == historyPage.pageTitle,
            title: Text(
                AppLocalizations.of(context).translate(historyPage.pageTitle)),
            leading: Icon(Icons.history),
            onTap: () {
              appState.activePage = historyPage; // Set the page
              fabAnimation.reverse(); // Hide the FAB
              Navigator.of(context).pop(); // Close the drawer
            },
          ),

          // Account
          ListTile(
            selected: activePage == accountPage.pageTitle,
            title: Text(
                AppLocalizations.of(context).translate(accountPage.pageTitle)),
            leading: Icon(Icons.account_box),
            onTap: () {
              appState.activePage = accountPage; // Set the page
              fabAnimation.reverse(); // Hide the FAB
              Navigator.of(context).pop(); // Close the drawer
            },
          ),

          // Other options
          Divider(),

          // Settigns
          ListTile(
            title: Text(
                AppLocalizations.of(context).translate('settings_page_title')),
            leading: Icon(Icons.settings),
          ),

          AppDrawerAbout()
        ],
      ),
    );
  }
}
